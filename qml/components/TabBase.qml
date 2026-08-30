import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    property bool shown

    opacity: shown ? 1 : 0
    visible: opacity > 0

    Behavior on opacity {
        FadeAnimation { }
    }
}
