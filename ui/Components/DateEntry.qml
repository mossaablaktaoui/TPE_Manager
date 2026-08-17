import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Control {
    id: control

    Theme { id: theme }

    property date date: new Date()
    property string format: "dd/MM/yyyy"

    function dateFromText(value) {
        const parts = value.trim().split("/")
        if (parts.length !== 3)
            return null

        const day = Number(parts[0])
        const month = Number(parts[1])
        const year = Number(parts[2])
        if (!Number.isInteger(day) || !Number.isInteger(month)
                || !Number.isInteger(year) || year < 1000)
            return null

        const parsed = new Date(year, month - 1, day)
        if (parsed.getFullYear() !== year
                || parsed.getMonth() !== month - 1
                || parsed.getDate() !== day)
            return null

        return parsed
    }

    function commitTextDate() {
        const parsed = dateFromText(field.text)
        if (parsed === null)
            return false

        control.date = parsed
        return true
    }

    implicitHeight: theme.controlHeight
    implicitWidth: 150

    contentItem: RowLayout {
        spacing: 0

        TextField {
            id: field
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: Qt.formatDate(control.date, control.format)
            leftPadding: 16
            rightPadding: 16
            topPadding: 5
            bottomPadding: 5
            font.pixelSize: theme.fontSize
            color: theme.text
            selectByMouse: true
            inputMethodHints: Qt.ImhDate

            background: Rectangle {
                color: theme.surface
                border.width: field.activeFocus ? 2 : 1
                border.color: field.activeFocus ? theme.primary : theme.border
                radius: 0
            }

            onTextEdited: {
                if (text.length === 10)
                    control.commitTextDate()
            }

            onEditingFinished: {
                if (!control.commitTextDate())
                    text = Qt.formatDate(control.date, control.format)
            }
        }

        Button {
            id: calendarButton
            Layout.preferredWidth: theme.controlHeight
            Layout.fillHeight: true

            padding: 10

            // Explicitly target the built-in icon sizing mechanics
            icon.source: "../assets/icons/calendar.svg"
            icon.width: 100
            icon.height: 100

            onClicked: popup.open()

            // FIXED: Swapped Text out for a universally supported Image component.
            // This allows it to work out of the box in QML Preview and C++ compiled runtimes.
            contentItem: Image {
                source: calendarButton.icon.source
                sourceSize.width: calendarButton.icon.width
                sourceSize.height: calendarButton.icon.height

                // Ensures the SVG doesn't distort or break layout boxes
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }

            background: Rectangle {
                color: calendarButton.down ? theme.secondaryPressed
                      : calendarButton.hovered ? theme.secondaryHover
                      : theme.surface
                border.width: 1
                border.color: theme.border
                radius: 0
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
                            popup.close()
                        }
                    }
                }
            }
        }
    }

    onDateChanged: {
        field.text = Qt.formatDate(control.date, control.format)
        calendar.month = control.date.getMonth()
        calendar.year = control.date.getFullYear()
    }

}
