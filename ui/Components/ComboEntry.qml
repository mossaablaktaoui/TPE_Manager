import QtQuick
import QtQuick.Controls

ComboBox {
    id: control

    Theme { id: theme }

    implicitHeight: theme.controlHeight
    implicitWidth: 200
    leftPadding: theme.spacingMd
    rightPadding: 34

    font.pixelSize: theme.fontSize

    contentItem: Text {
        leftPadding: 0
        rightPadding: 0
        text: control.displayText
        font: control.font
        color: control.enabled ? theme.text : theme.textMuted
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    indicator: Text {
        x: control.width - width - 12
        anchors.verticalCenter: parent.verticalCenter
        text: "⌄"
        color: control.enabled ? theme.textMuted : theme.textDisabled
        font.pixelSize: 16
    }

    background: Rectangle {
        radius: theme.radius
        color: control.enabled ? theme.surface : theme.surfaceAlt
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus ? theme.primary : theme.border
    }

    popup: Popup {
        y: control.height + 4
        width: control.width
        padding: 4
        implicitHeight: Math.min(contentItem.implicitHeight + 8, 240)

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color: theme.surface
            border.color: theme.border
            border.width: 1
            radius: theme.radius
        }
    }

    delegate: ItemDelegate {
        width: control.width - 8
        height: 36
        highlighted: control.highlightedIndex === index
        contentItem: Text {
            text: modelData
            color: theme.text
            font.pixelSize: theme.fontSize
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: parent.highlighted ? theme.selection : "transparent"
            radius: theme.radiusSmall
        }
    }
}
