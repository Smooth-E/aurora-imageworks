import QtQuick 2.6
import Sailfish.Silica 1.0

Column {
    id: root

    property alias title: titleLabel.text
    property alias summary: summaryLabel.text

    property real paddingLeft: Theme.horizontalPageMargin
    property real paddingRight: Theme.horizontalPageMargin

    width: parent.width
    topPadding: Theme.paddingMedium
    bottomPadding: Theme.paddingMedium
    spacing: Theme.paddingMedium

    Label {
        id: titleLabel

        anchors {
            left: parent.left
            right: parent.right
            leftMargin: root.paddingLeft
            rightMargin: root.paddingRight
        }

        wrapMode: Text.WordWrap
    }

    Label {
        id: summaryLabel

        anchors {
            left: parent.left
            right: parent.right
            leftMargin: root.paddingLeft
            rightMargin: root.paddingRight
        }

        color: Theme.secondaryColor
        wrapMode: Text.WordWrap
    }
}
