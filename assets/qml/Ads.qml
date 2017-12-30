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
import QtQuick.Window 2.0
import com.dreamdev.QtAdMobBanner 1.0

Item {
    id: ads

    //
    // Custom values (which is used by other components to adapt the UI to shown ads)
    //
    readonly property int bannerHeight: 50
    readonly property int sbHeight: Screen.height - Screen.desktopAvailableHeight
    property int adHeight: AdsEnabled && ad.isLoaded && ad.visible ? bannerHeight : 0

    //
    // Move UI slowly while the ad loads
    //
    Behavior on adHeight { NumberAnimation {duration: 250} }

    //
    // Locates the banner on the bottom of the screen
    //
    function locateBanner() {
        if (AdsEnabled)
            ad.y = (app.height - bannerHeight + sbHeight) * DevicePixelRatio
        else
            ad.y = app.height * 2 * DevicePixelRatio
    }

    //
    // Update banner location when window size changes
    //
    Connections {
        target: app
        onHeightChanged: locateBanner()
    }

    //
    // Configure the banner ad
    //
    Component.onCompleted: {
        locateBanner()
        ad.visible = AdsEnabled
        for (var i = 0; i < TestDevices.length; ++i)
            ad.addTestDevice (TestDevices [i])
    }

    //
    // Banner ad
    //
    AdMobBanner {
        id: ad
        onLoaded: locateBanner()
        Component.onCompleted: {
            unitId = BannerId
            visible = AdsEnabled
            size = AdMobBanner.SmartBanner
        }
    }
}
