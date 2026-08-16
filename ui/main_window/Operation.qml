import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 1000
    height: 600

    property var model
    property alias previousDayButton: operationPage.previousDayButton
    property alias fromDate: operationPage.fromDate
    property alias toDate: operationPage.toDate
    property alias nextDayButton: operationPage.nextDayButton
    property alias todayButton: operationPage.todayButton
    property alias filterCombo: operationPage.filterCombo
    property alias newOperationButton: operationPage.newOperationButton
    property alias modifyButton: operationPage.modifyButton
    property alias duplicateButton: operationPage.duplicateButton
    property alias deleteButton: operationPage.deleteButton
    property alias operationsTable: operationPage.operationsTable
    property alias currentBalanceCard: operationPage.currentBalanceCard
    property alias totalOperationsCard: operationPage.totalOperationsCard
    property alias totalPaidCard: operationPage.totalPaidCard
    property alias profitCard: operationPage.profitCard
    property alias extraProfitCard: operationPage.extraProfitCard
    signal rowsLoaded(var rows)

    function formatDateForSql(dateValue) {
        return Qt.formatDate(dateValue, "yyyy-MM-dd")
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

    function updateTable() {
        if (!model)
            return

        const rows = model.obtenir_operations(
            formatDateForSql(operationPage.fromDate.date),
            formatDateForSql(operationPage.toDate.date),
            "ALL"
        )

        const formattedRows = rows.map(formatOperationRow)
        operationPage.operationsTable.rows = formattedRows
        operationPage.totalOperationsCard.value = String(rows.length)
        rowsLoaded(formattedRows)
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

    onModelChanged: updateTable()

    Connections {
        target: operationPage.fromDate

        function onDateChanged() {
            root.updateTable()
        }
    }

    Connections {
        target: operationPage.toDate

        function onDateChanged() {
            root.updateTable()
        }
    }

    Component.onCompleted: {
        operationPage.fromDate.date = new Date(2023, 9, 1)
        operationPage.toDate.date = new Date(2023, 9, 31)
        updateTable()
    }
}


// here is the api:
// 
//     property alias previousDayButton: previousDayButton
//     property alias fromDate: fromDate
//     property alias toDate: toDate
//     property alias nextDayButton: nextDayButton
//     property alias todayButton: todayButton
//     property alias filterCombo: comboEntry
// 
//     property alias newOperationButton: newOperationButton
//     property alias modifyButton: modifyButton
//     property alias duplicateButton: duplicateButton
//     property alias deleteButton: deleteButton
// 
//     property alias operationsTable: operationsTable
// 
//     property alias currentBalanceCard: currentBalanceCard
//     property alias totalOperationsCard: totalOperationsCard
//     property alias totalPaidCard: totalPaidCard
//     property alias profitCard: profitCard
//     property alias extraProfitCard: extraProfitCard
// 
//     property var headers: []
//     property var columnWidths: []
//     property var rows: []
//     property int selectedRow: -1
//     property int rowHeight: theme.rowHeight
//     property int headerHeight: 40
