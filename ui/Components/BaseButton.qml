import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: control

    Theme { id: theme }

    property color normalColor: theme.primary
    property color hoverColor: theme.primaryHover
    property color pressedColor: theme.primaryPressed
    property color normalTextColor: theme.primaryText
    property color disabledTextColor: theme.textDisabled
    property color borderColor: "transparent"
    property string iconText: ""
    property int buttonHeight: theme.controlHeight

    implicitHeight: buttonHeight
    implicitWidth: Math.max(92, contentRow.implicitWidth + 28)

    leftPadding: theme.spacingMd
    rightPadding: theme.spacingMd
    topPadding: 0
    bottomPadding: 0

    font.pixelSize: theme.fontSize
    font.weight: theme.fontWeightMedium

    contentItem: RowLayout {
        id: contentRow
        spacing: 7

        Item { Layout.fillWidth: true; Layout.preferredWidth: 1 }

        Text {
            visible: control.iconText.length > 0
            text: control.iconText
            color: control.enabled ? control.normalTextColor : control.disabledTextColor
            font.pixelSize: control.font.pixelSize + 2
            font.weight: Font.Medium
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            text: control.text
            color: control.enabled ? control.normalTextColor : control.disabledTextColor
            font: control.font
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        Item { Layout.fillWidth: true; Layout.preferredWidth: 1 }
    }

    background: Rectangle {
        radius: theme.radius
        color: {
            if (!control.enabled)
                return theme.surfaceAlt
            if (control.down)
                return control.pressedColor
            if (control.hovered)
                return control.hoverColor
            return control.normalColor
        }
        border.width: control.borderColor === "transparent" ? 0 : 1
        border.color: control.borderColor
    }

    HoverHandler {
        cursorShape: control.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
