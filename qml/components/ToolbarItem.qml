import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    id: root

    property alias label: tag.text
    property alias icon: button.icon
    property bool down

    signal clicked(var mouse)

    implicitWidth: Theme.itemSizeSmall
    implicitHeight: column.height

    Column {
        id: column

        width: parent.width
        height: implicitHeight

        IconButton {
            id: button

            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.itemSizeSmall
            width: height
            down: root.down || mouseArea.pressed
        }

        Item {
            width: 1
            height: Theme.paddingSmall
        }

        Label {
            id: tag

            width: parent.width
            height: implicitHeight
            color: root.down ? Theme.highlightColor : Theme.primaryColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Item {
            width: 1
            height: Theme.paddingMedium
        }

        Rectangle {
            width: parent.width
            height: Theme.paddingSmall
            color: root.down ? "transparent" : Theme.secondaryColor
            border.color: Theme.secondaryColor
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: root.clicked(mouse)
    }
}
