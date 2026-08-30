import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    property bool shown: false

    opacity: shown ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        FadeAnimation { }
    }

    Column {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
        }

        height: implicitHeight
        spacing: Theme.paddingLarge

        Label {
            width: parent.width
            text: qsTr("Welcome to Imageworks!")
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeHuge
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            width: parent.width
            text: qsTr("Open an exisiting image or create a new one to start editing")
            color: Theme.secondaryColor
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeLarge
        }

        ButtonLayout {
            width: parent.width

            Button {
                icon.source: "image://theme/icon-splus-image"
                text: qsTr("Open from gallery")

                onClicked: page.openFromGallery()
            }

            Button {
                icon.source: "image://theme/icon-splus-file-folder"
                text: qsTr("Open from files")

                onClicked: page.openFromFiles()
            }

            Button {
                icon.source: "image://theme/icon-splus-new"
                text: qsTr("Create new image")

                onClicked: page.openNewImagePage()
            }
        }
    }
}
