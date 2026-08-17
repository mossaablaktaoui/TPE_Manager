import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 1000
    height: 600

    property var model
    property var modifyButton: operationPage.modifyButton
    property var duplicateButton: operationPage.duplicateButton
    property var deleteButton: operationPage.deleteButton
    property var operationsTable: operationPage.operationsTable

    function formatDateForSql(dateValue) {
        const jsDate = new Date(dateValue)
        const year = jsDate.getFullYear()
        const month = String(jsDate.getMonth() + 1).padStart(2, "0")
        const day = String(jsDate.getDate()).padStart(2, "0")
        return year + "-" + month + "-" + day
    }

    function formatAmount(value) {
        const number = Number(value)
        if (isNaN(number))
            return String(value ?? "")

        return Number(number).toLocaleString(Qt.locale("fr_FR"), "f", 2)
    }

    function formatOperationRow(row) {
        const operationType = row[3] === "FOURNITURE" ? "Fourniture" : "Transaction"
        let transactionType = row[4] || "-"

        if (transactionType === "NATIONALE")
            transactionType = "Nationale"
        else if (transactionType === "INTERNATIONALE")
            transactionType = "Internationale"

        return [
            row[1],
            row[2],
            operationType,
            transactionType,
            formatAmount(row[6]),
            formatAmount(row[7]),
            formatAmount(row[8]),
            formatAmount(row[9]),
            formatAmount(row[10]),
            formatAmount(row[11]),
            formatAmount(row[13]),
            row[14] || ""
        ]
    }

    function selectedOperationType() {
        switch (operationPage.operationTypeFilter.currentIndex) {
        case 1:
            return "TRANSACTION"
        case 2:
            return "FOURNITURE"
        default:
            return "ALL"
        }
    }

    function selectedTransactionType() {
        switch (operationPage.filterCombo.currentIndex) {
        case 1:
            return "NATIONALE"
        case 2:
            return "INTERNATIONALE"
        default:
            return "ALL"
        }
    }

    function updateTable() {
        if (!model)
            return

        const dateFrom = formatDateForSql(operationPage.fromDate.date)
        const dateTo = formatDateForSql(operationPage.toDate.date)
        const rows = model.obtenir_operations(
            dateFrom,
            dateTo,
            selectedOperationType(),
            selectedTransactionType()
        ) || []

        const formattedRows = rows.map(formatOperationRow)
        operationPage.operationsTable.rows = formattedRows
        operationPage.totalOperationsCard.value = String(rows.length)
    }

    function shiftDates(days) {
        const from = new Date(operationPage.fromDate.date)
        const to = new Date(operationPage.toDate.date)
        from.setDate(from.getDate() + days)
        to.setDate(to.getDate() + days)
        operationPage.fromDate.date = from
        operationPage.toDate.date = to
    }

    function setToday() {
        const today = new Date()
        operationPage.fromDate.date = today
        operationPage.toDate.date = today
    }

    OperationForm {
        id: operationPage
        anchors.fill: parent
        operationsTable.headers: [
            "Date",
            "Heure",
            "Type op.",
            "Transaction",
            "Montant op.",
            "Montant versé",
            "Déductible",
            "Comm. CMI",
            "Bénéfice",
            "Bénéfice sup.",
            "Solde après",
            "Remarque"
        ]

        operationsTable.columnWidths: [
            100,
            80,
            110,
            115,
            115,
            120,
            105,
            100,
            100,
            115,
            115,
            190
        ]

        previousDayButton.onClicked: root.shiftDates(-1)
        nextDayButton.onClicked: root.shiftDates(1)
        todayButton.onClicked: root.setToday()
    }

    Connections {
        target: operationPage.fromDate
        function onDateChanged() { root.updateTable() }
    }

    Connections {
        target: operationPage.toDate
        function onDateChanged() { root.updateTable() }
    }

    Connections {
        target: operationPage.operationTypeFilter
        function onCurrentIndexChanged() { root.updateTable() }
    }

    Connections {
        target: operationPage.filterCombo
        function onCurrentIndexChanged() { root.updateTable() }
    }

    onModelChanged: updateTable()

    Component.onCompleted: {
        const today = new Date()
        operationPage.fromDate.date = new Date(today.getFullYear(), today.getMonth(), 1)
        operationPage.toDate.date = new Date(today.getFullYear(), today.getMonth() + 1, 0)
    }
}
