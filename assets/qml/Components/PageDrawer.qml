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
import QtGraphicalEffects 1.0

Drawer {
    id: drawer

    //
    // Default size options
    //
    implicitHeight: app.effectiveHeight
    implicitWidth: Math.min (parent.width > parent.height ? 320 : 280,
                             Math.min (parent.width, parent.height) * 0.90)

    //
    // Icon properties
    //
    property string iconTitle: ""
    property string iconSource: ""
    property string iconSubtitle: ""
    property size iconSize: Qt.size (72, 72)
    property color iconBgColorLeft: "#de6262"
    property color iconBgColorRight: "#ffb850"

    //
    // List model that generates the page selector
    // Options for selector items are:
    //     - spacer: acts an expanding spacer between to items
    //     - pageTitle: the text to display
    //     - separator: if the element shall be a separator item
    //     - separatorText: optional text for the separator item
    //     - pageIcon: the source of the image to display next to the title
    //
    property alias pages: listView.model
    property alias pageIndex: listView.currentIndex

    //
    // Main layout of the drawer
    //
    ColumnLayout {
        spacing: 0
        anchors.margins: 0
        anchors.fill: parent

        //
        // Icon controls
        //
        Rectangle {
            z: 1
            height: 120
            id: iconRect
            Layout.fillWidth: true

            Rectangle {
                anchors.fill: parent

                LinearGradient {
                    anchors.fill: parent
                    start: Qt.point (0, 0)
                    end: Qt.point (parent.width, 0)

                    gradient: Gradient {
                        GradientStop { position: 1; color: iconBgColorLeft }
                        GradientStop { position: 0; color: iconBgColorRight }
                    }
                }
            }

            RowLayout {
                spacing: app.spacing * 2

                anchors {
                    fill: parent
                    centerIn: parent
                    margins: 2 * app.spacing
                }

                Image {
                    source: iconSource
                    sourceSize: iconSize
                }

                ColumnLayout {
                    spacing: app.spacing
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        Layout.fillHeight: true
                    }

                    Label {
                        color: "#fff"
                        text: iconTitle
                        font.weight: Font.Medium
                        font.pixelSize: app.normalLabel
                    }

                    Label {
                        color: "#fff"
                        opacity: 0.87
                        text: iconSubtitle
                        font.pixelSize: app.smallLabel
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }

        //
        // Page selector
        //
        ListView {
            z: 0
            id: listView
            currentIndex: -1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: currentIndex = 0

            delegate: DrawerItem {
                model: pages
                width: parent.width
                pageSelector: listView

                onClicked: {
                    if (listView.currentIndex !== index)
                        listView.currentIndex = index

                    drawer.close()
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
}
