import QtQuick 2.6
import Sailfish.Silica 1.0

ApplicationWindow
{
    id: app

    readonly property bool isLandscape: orientation & Orientation.LandscapeMask
    readonly property real coverTopPadding: isLandscape ? Theme.paddingLarge : Theme.paddingMedium
    
    allowedOrientations: defaultAllowedOrientations
    initialPage: Qt.resolvedUrl("pages/FirstPage.qml")
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}
