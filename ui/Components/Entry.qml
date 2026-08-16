import QtQuick
import QtQuick.Controls

TextField {
    id: control

    Theme { id: theme }

    implicitHeight: theme.controlHeight
    implicitWidth: 200

    leftPadding: theme.spacingMd
    rightPadding: theme.spacingMd

    font.pixelSize: theme.fontSize
    color: control.enabled ? theme.text : theme.textMuted
    placeholderTextColor: theme.textDisabled
    selectionColor: theme.primary
    selectedTextColor: theme.primaryText
    selectByMouse: true

    background: Rectangle {
        radius: theme.radius
        color: {
            if (!control.enabled || control.readOnly)
                return theme.surfaceAlt
            return theme.surface
        }
        border.width: control.activeFocus && !control.readOnly ? 2 : 1
        border.color: {
            if (control.activeFocus && !control.readOnly)
                return theme.primary
            if (control.hovered && !control.readOnly)
                return theme.borderHover
            return theme.border
        }
    }
}
