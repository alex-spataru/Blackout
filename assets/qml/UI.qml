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
            if (stack.depth > 1) {
                stack.pop()
                return false
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
                source: "qrc:/icons/toolbar/menu.svg"

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
                source: "qrc:/icons/toolbar/more.svg"
            }
        }
    }
    
    //
    // Drawer with application name and available pages
    //
    PageDrawer {
        id: drawer
        iconTitle: AppName
        iconSource: "qrc:/images/logo.png"
        iconSubtitle: qsTr ("Version %1 %2").arg (AppVersion).arg (AppChannel)

        onPageSelected: {
            toolbarTitle = pages.get (pageIndex).pageTitle

            switch (pageIndex) {
            case 0:
                while (stack.depth > 1)
                    stack.pop()
                break;
            case 1:
                stack.push (scores)
                break;
            case 2:
                stack.push (charts)
                break;
            case 3:
                stack.push (settings)
                break;
            default:
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
                pageTitle: qsTr ("Settings")
                pageIcon: "qrc:/icons/settings.svg"
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
