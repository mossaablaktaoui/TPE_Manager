import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window

    width: 1200
    height: 800
    visible: true
    title: "My Application"

    MainForm {
        id: ui
        anchors.fill: parent
    }
}
