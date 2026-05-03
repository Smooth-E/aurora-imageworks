import QtQuick 2.6
import Sailfish.Silica 1.0

IconButton {
    id: root

    Rectangle {
        anchors {
            top: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: Theme.paddingMedium
        }

        height: Theme.paddingSmall
        color: root.down ? "transparent" : Theme.secondaryColor
        border.color: Theme.secondaryColor
    }
}