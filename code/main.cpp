#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlContext>
#include "src/functions/core/MokmProjectManager.h"
#include "src/functions/core/MokmUndoManager.h"
#include "src/functions/database/MediaBinModel.h"
#include "src/functions/timeline/TimelineModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Initialize logic singletons
    new MokmProjectManager(&app);
    new MokmUndoManager(&app);
    new MediaBinModel(&app);
    new TimelineModel(&app);

    // Expose Singletons to QML natively mapped into the global context or via RegisterSingleton
    qmlRegisterSingletonInstance("Mokm.Core", 1, 0, "ProjectManager", MokmProjectManager::instance());
    qmlRegisterSingletonInstance("Mokm.Core", 1, 0, "UndoManager", MokmUndoManager::instance());
    qmlRegisterSingletonInstance("Mokm.Database", 1, 0, "MediaBinModel", MediaBinModel::instance());
    qmlRegisterSingletonInstance("Mokm.Timeline", 1, 0, "TimelineModel", TimelineModel::instance());

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("untitled", "Main");

    return QCoreApplication::exec();
}
