/*
 * Copyright (c) 2017 Alex Spataru <alex_spataru@outlook.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <QtQml>
#include <QScreen>
#include <QQuickStyle>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "shareutils.h"
#include "QtAdMobBanner.h"
#include "QtAdMobInterstitial.h"

#include "AdInfo.h"
#include "Version.h"
#include "Translator.h"

int main (int argc, char** argv)
{
    QGuiApplication::setAttribute (Qt::AA_EnableHighDpiScaling);
    QGuiApplication app (argc, argv);

    ShareUtils::DeclareQML();
    QmlAdMobBanner::DeclareQML();
    QmlAdMobInterstitial::DeclareQML();
    qreal dpr = app.primaryScreen()->devicePixelRatio();

    QQmlApplicationEngine engine;
    QQuickStyle::setStyle ("Material");
    engine.rootContext()->setContextProperty ("BannerId", BANNER_ID);
    engine.rootContext()->setContextProperty ("DevicePixelRatio", dpr);
    engine.rootContext()->setContextProperty ("AdsEnabled", ADS_ENABLED);
    engine.rootContext()->setContextProperty ("AppName", APP_NAME);
    engine.rootContext()->setContextProperty ("AppChannel", APP_CHANNEL);
    engine.rootContext()->setContextProperty ("AppVersion", APP_VERSION);
    engine.rootContext()->setContextProperty ("TestDevices", TEST_DEVICES);
    engine.rootContext()->setContextProperty ("AppDeveloper", APP_DEVELOPER);
    engine.load (QUrl (QStringLiteral ("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    return app.exec();
}
