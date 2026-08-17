import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

Rectangle {
    id: table

    Theme { id: theme }
    Settings {
        id: tableSettings
        category: "OperationsTable"
        property string visibleColumnsJson: ""
    }

    property var headers: []
    property var columnWidths: []
    property var rows: []
    property var displayRows: rows
    property var visibleColumns: []
    property int selectedRow: -1
    property int rowHeight: theme.rowHeight
    property int headerHeight: 40
    property int footerHeight: 44
    property int sortColumn: 1
    property int sortOrder: Qt.DescendingOrder
    property int totalContentWidth: {
        let total = 0
        for (let i = 0; i < headers.length; ++i) {
            if (isColumnVisible(i))
                total += columnWidths[i] || 120
        }
        return total
    }

    signal rowClicked(int row)

    function loadVisibleColumns() {
        if (tableSettings.visibleColumnsJson.length === 0)
            return false

        try {
            const stored = JSON.parse(tableSettings.visibleColumnsJson)
            if (!Array.isArray(stored))
                return false

            const next = []
            for (let i = 0; i < headers.length; ++i)
                next.push(stored[i] !== false)

            visibleColumns = next
            return true
        } catch (error) {
            return false
        }
    }

    function saveVisibleColumns() {
        if (visibleColumns.length === headers.length)
            tableSettings.visibleColumnsJson = JSON.stringify(visibleColumns)
    }

    function ensureVisibleColumns() {
        if (headers.length === 0)
            return

        if (loadVisibleColumns())
            return

        if (visibleColumns.length === headers.length)
            return

        const next = []
        for (let i = 0; i < headers.length; ++i)
            next.push(visibleColumns[i] !== false)
        visibleColumns = next
        saveVisibleColumns()
    }

    function isColumnVisible(columnIndex) {
        return columnIndex < headers.length && visibleColumns[columnIndex] !== false
    }

    function visibleColumnCount() {
        let count = 0
        for (let i = 0; i < headers.length; ++i) {
            if (isColumnVisible(i))
                count += 1
        }
        return count
    }

    function setColumnVisible(columnIndex, checked) {
        if (!checked && visibleColumnCount() === 1)
            return

        const next = visibleColumns.slice(0)
        next[columnIndex] = checked
        visibleColumns = next
        saveVisibleColumns()
    }

    function normalizeValue(value, columnIndex) {
        const text = String(value ?? "").trim()

        if (columnIndex === 0) {
            const parts = text.split("-")
            if (parts.length === 3)
                return parts[0] + parts[1] + parts[2]
        }

        if (columnIndex === 1) {
            return text.replace(/:/g, "")
        }

        if (columnIndex >= 4 && columnIndex <= 10) {
            const normalized = text.replace(/\s/g, "").replace(",", ".")
            const numeric = Number(normalized)
            if (!isNaN(numeric))
                return numeric
        }

        return text.toLocaleLowerCase()
    }

    function sortRows() {
        if (sortColumn < 0) {
            displayRows = rows
            return
        }

        const sorted = rows.slice(0)
        sorted.sort(function(leftRow, rightRow) {
            const leftValue = normalizeValue(leftRow[sortColumn], sortColumn)
            const rightValue = normalizeValue(rightRow[sortColumn], sortColumn)

            if (leftValue < rightValue)
                return sortOrder === Qt.AscendingOrder ? -1 : 1
            if (leftValue > rightValue)
                return sortOrder === Qt.AscendingOrder ? 1 : -1
            return 0
        })

        displayRows = sorted
    }

    function toggleSort(columnIndex) {
        if (sortColumn === columnIndex)
            sortOrder = sortOrder === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
        else {
            sortColumn = columnIndex
            sortOrder = Qt.AscendingOrder
        }

        selectedRow = -1
        sortRows()
    }

    onHeadersChanged: ensureVisibleColumns()
    onRowsChanged: sortRows()
    Component.onCompleted: ensureVisibleColumns()

    color: theme.surface
    radius: theme.radius
    border.width: 1
    border.color: theme.border
    clip: true

    Flickable {
        id: horizontalFlick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: footer.top
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
                        model: table.headers.length
                        delegate: Item {
                            required property int index
                            width: table.isColumnVisible(index) ? (table.columnWidths[index] || 120) : 0
                            height: table.headerHeight

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 10
                                text: table.headers[index]
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeXs
                                font.weight: theme.fontWeightSemibold
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: table.sortColumn === index
                                      ? (table.sortOrder === Qt.AscendingOrder ? "▲" : "▼")
                                      : ""
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeXs
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: table.isColumnVisible(index)
                                cursorShape: Qt.PointingHandCursor
                                onClicked: table.toggleSort(index)
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
                        model: table.displayRows

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
                                    model: rowDelegate.modelData.length

                                    delegate: Item {
                                        required property int index
                                        property var cellData: rowDelegate.modelData[index]
                                        width: table.isColumnVisible(index) ? (table.columnWidths[index] || 120) : 0
                                        height: table.rowHeight

                                        Rectangle {
                                            visible: index === 2 && table.isColumnVisible(index)
                                            anchors.left: parent.left
                                            anchors.leftMargin: 10
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: typeText.implicitWidth + 12
                                            height: 24
                                            radius: 4
                                            color: String(cellData) === "Fourniture" ? "#F3E8FF" : "#DBEAFE"

                                            Text {
                                                id: typeText
                                                anchors.centerIn: parent
                                                text: cellData
                                                color: String(cellData) === "Fourniture" ? "#7E22CE" : "#1D4ED8"
                                                font.pixelSize: theme.fontSizeXs
                                                font.weight: theme.fontWeightMedium
                                            }
                                        }

                                        Text {
                                            visible: index !== 2 && table.isColumnVisible(index)
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            anchors.rightMargin: 10
                                            text: cellData
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

    Rectangle {
        id: footer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: table.footerHeight
        color: theme.surfaceAlt

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: theme.border
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 12

            Text {
                Layout.alignment: Qt.AlignVCenter
                text: table.displayRows.length + " ligne(s) affichée(s)"
                color: theme.textMuted
                font.pixelSize: theme.fontSizeSmall
            }

            Item {
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                width: columnsButton.implicitWidth + 20
                height: 30
                radius: 6
                color: columnsMouseArea.containsMouse ? theme.selectionHover : theme.surface
                border.width: 1
                border.color: theme.border

                Text {
                    id: columnsButton
                    anchors.centerIn: parent
                    text: "Colonnes"
                    color: theme.text
                    font.pixelSize: theme.fontSizeSmall
                    font.weight: theme.fontWeightMedium
                }

                MouseArea {
                    id: columnsMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (columnsPopup.opened)
                            columnsPopup.close()
                        else
                            columnsPopup.open()
                    }
                }
            }
        }
    }

    Popup {
        id: columnsPopup
        x: Math.max(12, table.width - width - 12)
        y: table.height - height - footer.height - 8
        width: 220
        modal: false
        focus: true
        padding: 12
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: 10
            color: theme.surface
            border.width: 1
            border.color: theme.border
        }

        contentItem: Column {
            spacing: 8

            Text {
                text: "Colonnes visibles"
                color: theme.text
                font.pixelSize: theme.fontSizeSmall
                font.weight: theme.fontWeightSemibold
            }

            Repeater {
                model: table.headers.length

                delegate: CheckBox {
                    required property int index
                    text: table.headers[index]
                    checked: table.isColumnVisible(index)

                    onToggled: table.setColumnVisible(index, checked)
                }
            }
        }
    }
}
