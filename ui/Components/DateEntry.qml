import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Control {
    id: control

    Theme { id: theme }

    property date date: new Date()
    property string format: "dd/MM/yyyy"

    implicitHeight: theme.controlHeight
    implicitWidth: 150

    contentItem: RowLayout {
        spacing: 0

        TextField {
            id: field
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: Qt.formatDate(control.date, control.format)
            leftPadding: theme.spacingMd
            rightPadding: theme.spacingSm
            font.pixelSize: theme.fontSize
            color: theme.text
            selectByMouse: true

            background: Rectangle {
                color: theme.surface
                border.width: field.activeFocus ? 2 : 1
                border.color: field.activeFocus ? theme.primary : theme.border
                radius: theme.radius
            }

            onEditingFinished: {
                let parsed = Date.fromLocaleDateString(Qt.locale(), text, control.format)
                if (!isNaN(parsed.getTime()))
                    control.date = parsed
                else
                    text = Qt.formatDate(control.date, control.format)
            }
        }

        Button {
            id: calendarButton
            Layout.preferredWidth: theme.controlHeight
            Layout.fillHeight: true
            text: "◫"
            font.pixelSize: 15
            onClicked: popup.open()

            contentItem: Text {
                text: calendarButton.text
                color: theme.textMuted
                font: calendarButton.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: calendarButton.down ? theme.secondaryPressed
                      : calendarButton.hovered ? theme.secondaryHover
                      : theme.surface
                border.width: 1
                border.color: theme.border
                radius: theme.radius
            }
        }
    }

    Popup {
        id: popup
        y: control.height + theme.spacingXs
        padding: theme.spacingSm
        modal: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: theme.surface
            border.width: 1
            border.color: theme.border
            radius: theme.radius
        }

        contentItem: ColumnLayout {
            spacing: theme.spacingSm

            RowLayout {
                Layout.fillWidth: true

                Button {
                    text: "‹"
                    flat: true
                    onClicked: {
                        calendar.month--
                        if (calendar.month < 0) {
                            calendar.month = 11
                            calendar.year--
                        }
                    }
                }

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(new Date(calendar.year, calendar.month, 1), "MMMM yyyy")
                    color: theme.text
                    font.pixelSize: theme.fontSize
                    font.weight: theme.fontWeightMedium
                }

                Button {
                    text: "›"
                    flat: true
                    onClicked: {
                        calendar.month++
                        if (calendar.month > 11) {
                            calendar.month = 0
                            calendar.year++
                        }
                    }
                }
            }

            MonthGrid {
                id: calendar
                month: control.date.getMonth()
                year: control.date.getFullYear()
                locale: Qt.locale()

                delegate: Rectangle {
                    required property var model
                    implicitWidth: 36
                    implicitHeight: 32
                    color: model.today ? theme.selection : "transparent"
                    radius: theme.radiusSmall

                    Text {
                        anchors.centerIn: parent
                        text: model.day
                        color: model.month === calendar.month ? theme.text : theme.textDisabled
                        font.pixelSize: theme.fontSizeSmall
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            control.date = model.date
                            field.text = Qt.formatDate(control.date, control.format)
                            popup.close()
                        }
                    }
                }
            }
        }
    }
}
