import QtQuick 2.6
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        anchors {
            fill: parent
            topMargin: app.coverTopPadding
            leftMargin: Theme.paddingCover
            rightMargin: Theme.paddingCover
        }

        spacing: Theme.paddingSmall
        
        Label {
            width: parent.width
            text: qsTr("Welcome to Imageworks!")
            wrapMode: Text.WordWrap

            font {
                pixelSize: Theme.fontSizeExtraSmall
                weight: Font.Medium
            }
        }

        Label {
            width: parent.width
            text: qsTr("Edit images and create new ones")
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.secondaryColor
        }
    }
}
