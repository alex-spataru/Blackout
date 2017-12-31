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
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import com.lasconic 1.0

import "Pages"
import "Components"

Page {
    id: ui
    
    //
    // Custom properties
    //
    property alias toolbarTitle: toolbarText.text
    
    //
    // Decreases the stack depth when running on Android,
    // this function is called when the user presses the back
    // button on his/her device.
    //
    function checkStackDepth() {
        if (Qt.platform.os == "android") {
            if (drawer.pageIndex != 0) {
                drawer.pageIndex = 0
                return false;
            }
        }

        return true
    }

    //
    // Toolbar and controls
    //
    header: ToolBar {
        height: 56
        Material.primary: Qt.darker (drawer.iconBgColorLeft, 1.2)

        RowLayout {
            spacing: 3/2 * app.spacing

            anchors {
                fill: parent
                margins: app.spacing
                leftMargin: 3/2 * app.spacing
                rightMargin: 3/2 * app.spacing
            }

            SvgImage {
                sourceSize: Qt.size (24, 24)
                source: "qrc:/icons/menu.svg"

                MouseArea {
                    anchors.fill: parent
                    onClicked: drawer.open()
                }
            }

            Label {
                id: toolbarText
                color: "#ffffff"
                font.weight: Font.Medium
                font.pixelSize: app.mediumLabel
            }

            Item {
                Layout.fillWidth: true
            }

            SvgImage {
                sourceSize: Qt.size (24, 24)
                source: "qrc:/icons/more.svg"

                MouseArea {
                    anchors.fill: parent
                    onClicked: menu.open()
                }

                Menu {
                    id: menu
                    x: app.width - width
                    transformOrigin: Menu.TopRight
                    width: implicitWidth * app.scaleRatio

                    MenuItem {
                        onClicked: app.startNewGame()
                        text: qsTr ("New Game") + Translator.dummy
                    }

                    MenuItem {
                        onClicked: drawer.pageIndex = 4
                        text: qsTr ("Settings") + Translator.dummy
                    }

                    MenuItem {
                        visible: enabled
                        enabled: AdsEnabled
                        onClicked: app.removeAds()
                        height: enabled ? implicitHeight : 0
                        text: qsTr ("Remove Ads") + Translator.dummy
                    }
                }
            }
        }
    }
    
    //
    // Drawer with application name and available pages
    //
    PageDrawer {
        id: drawer
        iconTitle: AppName
        height: app.effectiveHeight
        iconSource: "qrc:/images/logo.png"
        iconSubtitle: qsTr ("Version %1 %2").arg (AppVersion).arg (AppChannel)

        onPageIndexChanged: {
            var indexesWithPages = [0, 1, 2, 3, 4]
            for (var i = 0; i < indexesWithPages.length; ++i) {
                if (pageIndex === indexesWithPages [i]) {
                    stack.clear()
                    toolbarTitle = pages.get (pageIndex).pageTitle
                    break
                }
            }

            switch (pageIndex) {
            case 0:
                stack.push (home)
                break;
            case 1:
                stack.push (scores)
                break;
            case 2:
                stack.push (charts)
                break;
            case 3:
                stack.push (leaderboard)
                break;
            case 4:
                stack.push (settings)
                break;
            case 5:
            case 6:
                /* Separator and spacer, do nothing */
                break;
            case 7:
                app.learnWhist();
                break;
            case 8:
                app.reportBug()
                break;
            case 9:
                app.openRate()
                break;
            }
        }

        pages: ListModel {
            id: pagesModel

            ListElement {
                pageTitle: qsTr ("Home")
                pageIcon: "qrc:/icons/home.svg"
            }

            ListElement {
                pageTitle: qsTr ("Scores Table")
                pageIcon: "qrc:/icons/scores.svg"
            }

            ListElement {
                pageTitle: qsTr ("Charts")
                pageIcon: "qrc:/icons/chart.svg"
            }

            ListElement {
                pageTitle: qsTr ("Leaderboard")
                pageIcon: "qrc:/icons/people.svg"
            }

            ListElement {
                pageTitle: qsTr ("Settings")
                pageIcon: "qrc:/icons/settings.svg"
            }

            ListElement {
                spacer: true
            }

            ListElement {
                separator: true
            }

            ListElement {
                link: true
                pageIcon: "qrc:/icons/help.svg"
                pageTitle: qsTr ("Learn Romanian Whist")
            }

            ListElement {
                link: true
                pageIcon: "qrc:/icons/bug.svg"
                pageTitle: qsTr ("Feature Requests / Bugs")
            }

            ListElement {
                link: true
                pageIcon: "qrc:/icons/star.svg"
                pageTitle: qsTr ("Rate This App")
            }
        }
    }

    //
    // Page loader
    //
    StackView {
        id: stack
        initialItem: home
        
        anchors {
            fill: parent
            margins: app.spacing
        }

        popExit: Transition {}
        popEnter: Transition {}
        pushExit: Transition {}
        pushEnter: Transition {}
        
        Home {
            id: home
            visible: false
        }
        
        Scores {
            id: scores
            visible: false
        }
        
        Charts {
            id: charts
            visible: false
        }

        Leaderboard {
            id: leaderboard
            visible: false
        }
        
        Settings {
            id: settings
            visible: false
        }
    }
    
    //
    // For showing the share menu on Android & iOS
    //
    ShareUtils {
        id: shareUtils
    }
}
