import QtQuick
import QtQuick.Controls

Control {
    id: control

    Theme { id: theme }

    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property alias readOnly: field.readOnly
    property alias validator: field.validator
    property string currency: "MAD"
    property color valueColor: theme.text

    implicitHeight: theme.controlHeight
    implicitWidth: 180

    contentItem: Item {
        TextField {
            id: field
            anchors.fill: parent
            leftPadding: 48
            rightPadding: theme.spacingMd
            horizontalAlignment: TextInput.AlignRight
            font.pixelSize: theme.fontSize
            color: control.valueColor
            placeholderTextColor: theme.textDisabled
            selectByMouse: true
            background: Rectangle {
                radius: theme.radius
                color: field.readOnly ? theme.surfaceAlt : theme.surface
                border.width: field.activeFocus && !field.readOnly ? 2 : 1
                border.color: field.activeFocus && !field.readOnly ? theme.primary : theme.border
            }
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: control.currency
            color: theme.textMuted
            font.pixelSize: theme.fontSizeSmall
            font.weight: theme.fontWeightMedium
        }
    }
}
