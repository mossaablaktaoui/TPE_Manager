import QtQuick
import QtQuick.Controls
import "./"

ApplicationWindow {
    id: window

    width: 1440
    height: 900
    minimumWidth: 1180
    minimumHeight: 720
    visible: true
    title: "TPE Manager"

    property var model

    MainForm {
        id: mainwindow
        anchors.fill: parent
        operationPage.model: window.model
    }
}
