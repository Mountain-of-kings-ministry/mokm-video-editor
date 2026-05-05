#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "someclass.h"
#include "mediafilemodel.h"
#include "trackmodel.h"
#include "foldermodel.h"

int main(int argc, char *argv[])
{
    qputenv("QT_MEDIA_DISABLE_HWACCEL", "1");
    qputenv("LIBVA_DRIVER_NAME", "i965");

    QGuiApplication app(argc, argv);

    qmlRegisterType<someClass>("kingClass", 1, 0, "SomeClass");

    QQmlApplicationEngine engine;

    MediaFileModel mediaFileModel;
    TrackModel trackModel;
    FolderModel folderModel;

    engine.rootContext()->setContextProperty("mediaFileModel", &mediaFileModel);
    engine.rootContext()->setContextProperty("trackModel", &trackModel);
    engine.rootContext()->setContextProperty("folderModel", &folderModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("mokm_video_editor", "SplashScreen");

    return QCoreApplication::exec();
}
