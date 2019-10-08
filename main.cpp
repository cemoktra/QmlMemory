#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include "normal_random.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Direct3D12);
    
    QGuiApplication app(argc, argv);
    NormalRandom normalRand;  
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    engine.rootContext()->setContextProperty("normalRand", &normalRand);
    engine.load(url);
    return app.exec();
}
