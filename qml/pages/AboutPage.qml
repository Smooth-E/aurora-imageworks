import QtQuick 2.6
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import QtGraphicalEffects 1.0

Page {
    allowedOrientations: Orientation.All

    AppBar {
        id: appBar

        headerText: qsTr("About")
    }

    SilicaFlickable {
        anchors {
            fill: parent
            topMargin: appBar.height
        }

        contentHeight: column.height
        topMargin: Theme.paddingLarge
        bottomMargin: Theme.paddingLarge

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }

            height: childrenRect.height
            spacing: Theme.paddingMedium

            Image {
                id: icon

                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.dp(128)
                height: width
                source: Qt.resolvedUrl("../symbols/app-icon.png")

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: icon.width
                        height: icon.height
                        radius: Theme.paddingLarge
                    }
                }
            }

            Label {
                width: parent.width
                text: qsTr("Imageworks")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                
                font {
                    pixelSize: Theme.fontSizeLarge
                    weight: Font.DemiBold
                }
            }

            Label {
                width: parent.width
                text: qsTr("Feature-rich image editing application for Aurora OS based on Python Pillow library. Originally made for Sailfish OS, then ported to Aurora OS by Smooth-E.")
                horizontalAlignment: Text.AlignHCenter
                color: Theme.colorSecondary
                wrapMode: Text.WordWrap
            }

            Label {
                width: parent.width
                text: qsTr("Imageworks is free software, distributed under the terms of GNU GPL v3.")
                color: Theme.secondaryColor
                wrapMode: Text.WordWrap
            }

            Label {
                width: parent.width
                color: Theme.secondaryColor
                wrapMode: Text.WordWrap

                text: "Copyright © 2020 Tobias Planitzer"
                      + "\nCopyright © 2021-2022 Mark Washeim"
                      + "\nCopyright © 2026 Smooth-E"
            }

            ButtonLayout {
                width: parent.width

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("View source code on GitHub")

                    onClicked: {
                        if (mouse.button === Qt.LeftButton) {
                            Qt.openUrlExternally("https://github.com/smooth-e/aurora-imageworks")
                        }
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Support port maintainer through Boosty")

                    onClicked: {
                        if (mouse.button === Qt.LeftButton) {
                            Qt.openUrlExternally("https://boosty.to/smooth-e/donate")
                        }
                    }
                }
            }
        }
    }
}
