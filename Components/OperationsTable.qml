import QtQuick
import QtQuick.Controls

Rectangle {
    id: table

    Theme { id: theme }

    property var headers: []
    property var columnWidths: []
    property var rows: []
    property int selectedRow: -1
    property int rowHeight: theme.rowHeight
    property int headerHeight: 40
    property int totalContentWidth: {
        let total = 0
        for (let i = 0; i < columnWidths.length; ++i)
            total += columnWidths[i]
        return total
    }

    signal rowClicked(int row)

    color: theme.surface
    radius: theme.radius
    border.width: 1
    border.color: theme.border
    clip: true

    Flickable {
        id: horizontalFlick
        anchors.fill: parent
        contentWidth: Math.max(width, table.totalContentWidth)
        contentHeight: height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

        Item {
            width: horizontalFlick.contentWidth
            height: horizontalFlick.height

            Rectangle {
                id: header
                anchors.top: parent.top
                width: parent.width
                height: table.headerHeight
                color: theme.surfaceAlt

                Row {
                    anchors.fill: parent
                    Repeater {
                        model: table.headers
                        delegate: Item {
                            required property int index
                            required property var modelData
                            width: table.columnWidths[index] || 120
                            height: table.headerHeight

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 10
                                text: modelData
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeXs
                                font.weight: theme.fontWeightSemibold
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: theme.border
                }
            }

            Flickable {
                id: verticalFlick
                anchors.top: header.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                contentWidth: width
                contentHeight: rowsColumn.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                Column {
                    id: rowsColumn
                    width: verticalFlick.width

                    Repeater {
                        model: table.rows

                        delegate: Rectangle {
                            id: rowDelegate
                            required property int index
                            required property var modelData
                            width: rowsColumn.width
                            height: table.rowHeight
                            color: table.selectedRow === index ? theme.selection
                                  : mouseArea.containsMouse ? theme.selectionHover
                                  : theme.surface

                            Row {
                                anchors.fill: parent

                                Repeater {
                                    model: rowDelegate.modelData

                                    delegate: Item {
                                        required property int index
                                        required property var modelData
                                        width: table.columnWidths[index] || 120
                                        height: table.rowHeight

                                        Rectangle {
                                            visible: index === 1
                                            anchors.left: parent.left
                                            anchors.leftMargin: 10
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: typeText.implicitWidth + 12
                                            height: 24
                                            radius: 4
                                            color: String(modelData) === "Fourniture" ? "#F3E8FF" : "#DBEAFE"

                                            Text {
                                                id: typeText
                                                anchors.centerIn: parent
                                                text: modelData
                                                color: String(modelData) === "Fourniture" ? "#7E22CE" : "#1D4ED8"
                                                font.pixelSize: theme.fontSizeXs
                                                font.weight: theme.fontWeightMedium
                                            }
                                        }

                                        Text {
                                            visible: index !== 1
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            anchors.rightMargin: 10
                                            text: modelData
                                            color: {
                                                if (index === 4 || index === 7 || index === 8)
                                                    return theme.success
                                                if (index === 6)
                                                    return theme.danger
                                                return theme.text
                                            }
                                            font.pixelSize: theme.fontSizeSmall
                                            font.weight: index === 9 ? theme.fontWeightSemibold : Font.Normal
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: index >= 3 && index <= 9 ? Text.AlignRight : Text.AlignLeft
                                            elide: Text.ElideRight
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: theme.divider
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    table.selectedRow = rowDelegate.index
                                    table.rowClicked(rowDelegate.index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
