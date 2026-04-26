#include "MokmProjectManager.h"
#include "../database/MediaBinModel.h"
#include "../timeline/TimelineModel.h"
#include "../timeline/TimelineClipModel.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>
#include <QDebug>
#include <QDir>

static MokmProjectManager *s_instance = nullptr;

MokmProjectManager::MokmProjectManager(QObject *parent)
    : QObject(parent), m_projectName("Untitled Project"), m_projectPath(""), m_isDirty(false)
{
    s_instance = this;

    m_autoSaveTimer = new QTimer(this);
    m_autoSaveTimer->setInterval(60000); // 60 seconds
    connect(m_autoSaveTimer, &QTimer::timeout, this, &MokmProjectManager::autoSave);
    m_autoSaveTimer->start();

    loadRecentProjects();
}

MokmProjectManager::~MokmProjectManager()
{
    if (m_autoSaveTimer)
    {
        m_autoSaveTimer->stop();
    }
}

MokmProjectManager *MokmProjectManager::instance()
{
    return s_instance;
}

QString MokmProjectManager::projectName() const
{
    return m_projectName;
}

void MokmProjectManager::setProjectName(const QString &projectName)
{
    if (m_projectName == projectName)
        return;
    m_projectName = projectName;
    emit projectNameChanged();
    markDirty();
}

QString MokmProjectManager::projectPath() const
{
    return m_projectPath;
}

bool MokmProjectManager::isDirty() const
{
    return m_isDirty;
}

QStringList MokmProjectManager::recentProjects() const
{
    loadRecentProjects();
    QSettings settings("MOKM", "VideoEditor");
    return settings.value("recentProjects").toStringList();
}

void MokmProjectManager::loadRecentProjects()
{
    // Loaded on demand via QSettings
}

void MokmProjectManager::saveRecentProjects()
{
    QSettings settings("MOKM", "VideoEditor");
    settings.setValue("recentProjects", recentProjects());
}

void MokmProjectManager::addToRecentProjects(const QString &path)
{
    QSettings settings("MOKM", "VideoEditor");
    QStringList list = settings.value("recentProjects").toStringList();
    list.removeAll(path);
    list.prepend(path);
    while (list.size() > 10)
        list.removeLast();
    settings.setValue("recentProjects", list);
    emit recentProjectsChanged();
}

QString MokmProjectManager::autoSavePath() const
{
    if (m_projectPath.isEmpty())
    {
        return QDir::temp().filePath("mokm_untitled.autosave");
    }
    return m_projectPath + ".autosave";
}

void MokmProjectManager::markDirty()
{
    if (!m_isDirty)
    {
        m_isDirty = true;
        emit isDirtyChanged();
    }
}

bool MokmProjectManager::createNewProject(const QString &name)
{
    m_projectName = name;
    m_projectPath = "";
    m_isDirty = false;

    // Clear models
    MediaBinModel::instance()->clear();
    TimelineModel::instance()->clear();

    emit projectNameChanged();
    emit projectPathChanged();
    emit isDirtyChanged();
    emit projectLoaded();
    return true;
}

bool MokmProjectManager::loadProject(const QString &path)
{
    // Remove autosave if exists after successful load
    if (readFromJson(path))
    {
        m_projectPath = path;
        m_isDirty = false;
        emit projectPathChanged();
        emit isDirtyChanged();
        emit projectLoaded();
        addToRecentProjects(path);

        // Clean up autosave
        QFile autoSave(autoSavePath());
        if (autoSave.exists())
            autoSave.remove();

        return true;
    }
    return false;
}

bool MokmProjectManager::saveProject()
{
    if (m_projectPath.isEmpty())
    {
        qWarning() << "No project path set. Use saveProjectAs.";
        return false;
    }
    return writeToJson(m_projectPath);
}

bool MokmProjectManager::saveProjectAs(const QString &path)
{
    if (writeToJson(path))
    {
        m_projectPath = path;
        m_isDirty = false;
        emit projectPathChanged();
        emit isDirtyChanged();
        addToRecentProjects(path);
        return true;
    }
    return false;
}

void MokmProjectManager::autoSave()
{
    if (!m_isDirty || m_projectPath.isEmpty())
        return;

    QString aPath = autoSavePath();
    if (writeToJson(aPath))
    {
        qDebug() << "Auto-saved to" << aPath;
    }
}

bool MokmProjectManager::checkForAutoSave()
{
    QString aPath = autoSavePath();
    QFile file(aPath);
    if (file.exists())
    {
        emit autoSaveRecovered(aPath);
        return true;
    }
    return false;
}

void MokmProjectManager::clearRecentProjects()
{
    QSettings settings("MOKM", "VideoEditor");
    settings.remove("recentProjects");
    emit recentProjectsChanged();
}

bool MokmProjectManager::writeToJson(const QString &path)
{
    QJsonObject rootObject;
    rootObject["projectName"] = m_projectName;
    rootObject["version"] = "1.0";

    // Serialize MediaBinModel
    QJsonArray mediaBinArray;
    QVariantList mediaItems = MediaBinModel::instance()->getAllMedia();
    for (const auto &item : mediaItems)
    {
        mediaBinArray.append(QJsonValue::fromVariant(item));
    }
    rootObject["mediaBin"] = mediaBinArray;

    // Serialize TimelineModel
    QJsonArray tracksArray;
    auto *timeline = TimelineModel::instance();
    for (int i = 0; i < timeline->rowCount(); ++i)
    {
        QModelIndex idx = timeline->index(i, 0);
        QJsonObject trackObj;
        trackObj["id"] = timeline->data(idx, Qt::UserRole + 1).toString();
        trackObj["name"] = timeline->data(idx, Qt::UserRole + 2).toString();
        trackObj["isAudio"] = timeline->data(idx, Qt::UserRole + 3).toBool();
        trackObj["isMuted"] = timeline->data(idx, Qt::UserRole + 4).toBool();
        trackObj["isSolo"] = timeline->data(idx, Qt::UserRole + 5).toBool();
        trackObj["height"] = timeline->data(idx, Qt::UserRole + 6).toInt();

        auto *clipsModel = timeline->data(idx, Qt::UserRole + 7).value<TimelineClipModel *>();
        QJsonArray clipsArray;
        if (clipsModel)
        {
            for (const auto &clip : clipsModel->clips())
            {
                QJsonObject clipObj;
                clipObj["id"] = clip.id;
                clipObj["mediaId"] = clip.mediaId;
                clipObj["mediaName"] = clip.mediaName;
                clipObj["trackIndex"] = clip.trackIndex;
                clipObj["startFrame"] = clip.startFrame;
                clipObj["durationFrames"] = clip.durationFrames;
                clipObj["sourceInFrame"] = clip.sourceInFrame;
                clipObj["sourceOutFrame"] = clip.sourceOutFrame;
                clipObj["color"] = clip.color;
                clipsArray.append(clipObj);
            }
        }
        trackObj["clips"] = clipsArray;
        tracksArray.append(trackObj);
    }
    rootObject["timeline"] = tracksArray;

    QJsonDocument doc(rootObject);
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly))
    {
        qWarning() << "Could not open file for writing:" << path;
        return false;
    }

    file.write(doc.toJson());
    file.close();

    m_isDirty = false;
    emit isDirtyChanged();
    return true;
}

bool MokmProjectManager::readFromJson(const QString &path)
{
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly))
    {
        qWarning() << "Could not open file for reading:" << path;
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);
    if (parseError.error != QJsonParseError::NoError)
    {
        qWarning() << "JSON parse error:" << parseError.errorString();
        return false;
    }

    if (!doc.isObject())
        return false;

    QJsonObject rootObject = doc.object();
    m_projectName = rootObject["projectName"].toString("Untitled Project");
    emit projectNameChanged();

    // Deserialize MediaBinModel
    MediaBinModel::instance()->clear();
    QJsonArray mediaBinArray = rootObject["mediaBin"].toArray();
    for (const auto &val : mediaBinArray)
    {
        QJsonObject item = val.toObject();
        QString filePath = item["filePath"].toString();
        if (!filePath.isEmpty())
        {
            MediaBinModel::instance()->importMediaLocal(filePath);
        }
    }

    // Deserialize TimelineModel
    TimelineModel::instance()->clear();
    QJsonArray tracksArray = rootObject["timeline"].toArray();
    for (const auto &tval : tracksArray)
    {
        QJsonObject trackObj = tval.toObject();
        bool isAudio = trackObj["isAudio"].toBool();
        if (isAudio)
        {
            TimelineModel::instance()->addAudioTrack();
        }
        else
        {
            TimelineModel::instance()->addVideoTrack();
        }

        int trackIdx = TimelineModel::instance()->rowCount() - 1;
        QJsonArray clipsArray = trackObj["clips"].toArray();
        for (const auto &cval : clipsArray)
        {
            QJsonObject clipObj = cval.toObject();
            QString mediaId = clipObj["mediaId"].toString();
            QString mediaName = clipObj["mediaName"].toString();
            double startFrame = clipObj["startFrame"].toDouble();
            double durationFrames = clipObj["durationFrames"].toDouble();
            TimelineModel::instance()->addClipToTrack(trackIdx, mediaId, mediaName, startFrame, durationFrames);
        }
    }

    return true;
}
