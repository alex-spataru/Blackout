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

import QtQuick 2.0
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import "."
import "Pages"

ApplicationWindow {
    id: app
    width: 300
    height: 480
    visible: true
    title: AppName

    //
    // Constants
    //
    readonly property int spacing: 8
    readonly property int smallLabel: 12
    readonly property int largeLabel: 22
    readonly property int mediumLabel: 18
    readonly property int normalLabel: 16
    readonly property int extraSmallLabel: 10
    readonly property int extraLargeLabel: 24
    readonly property alias bannerHeight: ads.adHeight
    readonly property int effectiveHeight: height - bannerHeight
    
    //
    // Display the application window on launch
    //
    Component.onCompleted: {
        if (Qt.platform.os === "android")
            showMaximized()
        else
            showNormal()
    }
    
    //
    // Decrease stack depth before closing the application.
    // This allows the Android user to use the back button to navigate the UI
    //
    onClosing: close.accepted = ui.checkStackDepth()

    //
    // Opens a link that allows the user to report a bug
    //
    function reportBug() {
        Qt.openUrlExternally ("https://github.com/alex-spataru/romanian-whist/issues")
    }

    //
    // Opens a link that allows the user to learn whist (in theory)
    //
    function learnWhist() {
        Qt.openUrlExternally ("http://www.bridgeguys.com/WGlossary/WhistRomania.html")
    }

    //
    // Clears the current data and starts a new game
    //
    function startNewGame() {

    }

    //
    // Opens an URL to install the ad-free version of the app
    //
    function removeAds() {
        if (Qt.platform.os === "android")
            Qt.openUrlExternally ("market:details?id=" + AppId + "noads")
        else
            Qt.openUrlExternally ("https://github.com/alex-spataru/romanian-whist")
    }

    //
    // Opens a link that allows the user to rate the application
    //
    function openRate() {
        if (Qt.platform.os === "android")
            Qt.openUrlExternally ("market:details?id=" + AppId)
        else
            Qt.openUrlExternally ("https://github.com/alex-spataru/romanian-whist")
    }

    //
    // Save settings between runs
    //
    Settings {
        property alias appX: app.x
        property alias appY: app.y
        property alias appWidth: app.width
        property alias appHeight: app.height
    }

    //
    // User interface
    //
    UI {
        id: ui
        anchors.fill: parent
        anchors.bottomMargin: app.spacing + bannerHeight
    }

    //
    // Ad control unit
    //
    Ads {
        id: ads
        anchors.fill: parent
    }
}
