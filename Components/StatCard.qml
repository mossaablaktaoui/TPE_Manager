import QtQuick
import QtQuick.Layouts

Rectangle {
    id: card

    Theme { id: theme }

    property string title: ""
    property string value: ""
    property color valueColor: theme.text
    property bool emphasis: false

    implicitHeight: 66
    implicitWidth: 150
    radius: theme.radius
    color: emphasis ? theme.warningSurface : theme.surface
    border.width: 1
    border.color: emphasis ? "#F6C5B6" : theme.border

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        Text {
            Layout.fillWidth: true
            text: card.title
            color: theme.textMuted
            font.pixelSize: theme.fontSizeSmall
            elide: Text.ElideRight
        }

        Text {
            Layout.fillWidth: true
            text: card.value
            color: card.valueColor
            font.pixelSize: theme.fontSize
            font.weight: theme.fontWeightSemibold
            elide: Text.ElideRight
        }
    }
}
