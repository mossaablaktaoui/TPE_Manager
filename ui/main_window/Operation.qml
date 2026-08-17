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
    property var operationRowsById: ({})
    property int editingOperationId: 0

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
        const isSupply = row[3] === "FOURNITURE"
        const operationType = isSupply ? "Fourniture" : "Transaction"
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
            isSupply ? "-" : formatAmount(row[7]),
            isSupply ? "-" : formatAmount(row[8]),
            isSupply ? "-" : formatAmount(row[9]),
            isSupply ? "-" : formatAmount(row[10]),
            isSupply ? "-" : formatAmount(row[11]),
            formatAmount(row[13]),
            row[14] || "",
            row[0]
        ]
    }

    function setEditorTime(time) {
        const parts = String(time || "00:00:00").split(":")
        const hour = Number(parts[0])
        const minute = Number(parts[1])
        const second = Number(parts[2])
        operationPage.hourField.currentIndex = hour >= 0 && hour < 24 ? hour : 0
        operationPage.minuteField.currentIndex = minute >= 0 && minute < 60 ? minute : 0
        operationPage.secondField.currentIndex = second >= 0 && second < 60 ? second : 0
    }

    function formatEditorDate(date) {
        const parts = String(date).split("-")
        if (parts.length !== 3)
            return ""
        return parts[2] + "/" + parts[1] + "/" + parts[0]
    }

    function currentEditorDate() {
        const now = new Date()
        return String(now.getDate()).padStart(2, "0") + "/"
                + String(now.getMonth() + 1).padStart(2, "0") + "/"
                + now.getFullYear()
    }

    function editorSqlDateTime() {
        const date = operationPage.dateField.date
        if (!(date instanceof Date) || isNaN(date.getTime()))
            return ""

        return formatDateForSql(date) + " " + operationPage.hourField.currentText
                + ":" + operationPage.minuteField.currentText
                + ":" + operationPage.secondField.currentText
    }

    function numberFromText(value) {
        const normalized = String(value ?? "").replace(/[\s\u202f]/g, "").replace(",", ".")
        const number = Number(normalized)
        return isNaN(number) ? 0 : number
    }

    function updateEditorTypeState() {
        const isTransaction = operationPage.operationType.currentIndex === 0
        const fields = [
            operationPage.factureField,
            operationPage.transactionType,
            operationPage.paidField,
            operationPage.deductibleField,
            operationPage.commissionField,
            operationPage.profitField,
            operationPage.extraProfitField
        ]
        const labels = [
            operationPage.factureLabel,
            operationPage.transactionTypeLabel,
            operationPage.paidLabel,
            operationPage.deductibleLabel,
            operationPage.commissionLabel,
            operationPage.profitLabel,
            operationPage.extraProfitLabel
        ]

        for (let index = 0; index < fields.length; ++index) {
            fields[index].enabled = isTransaction
            labels[index].opacity = isTransaction ? 1.0 : 0.4
        }
    }

    function updateFilterState() {
        const isSupply = operationPage.operationTypeFilter.currentIndex === 2
        if (isSupply)
            operationPage.filterCombo.currentIndex = 0
        operationPage.filterCombo.enabled = !isSupply
    }

    function resetEditor() {
        editingOperationId = 0
        operationPage.editorTitle.text = "Créer une nouvelle opération"
        operationPage.dateField.date = new Date()
        setEditorTime(Qt.formatTime(new Date(), "HH:mm:ss"))
        operationPage.factureField.text = ""
        operationPage.operationType.currentIndex = 0
        operationPage.transactionType.currentIndex = 0
        operationPage.amountField.text = "0,00"
        operationPage.paidField.text = "0,00"
        operationPage.deductibleField.text = "0,00"
        operationPage.commissionField.text = "0,00"
        operationPage.profitField.text = "0,00"
        operationPage.extraProfitField.text = "0,00"
        operationPage.beforeField.text = "0,00"
        operationPage.afterField.text = "0,00"
        operationPage.noteField.text = ""
        updateEditorTypeState()
    }

    function openSelectedOperation() {
        const operationId = selectedOperationId()
        const row = operationRowsById[operationId]
        if (!row)
            return

        editingOperationId = operationId
        operationPage.editorTitle.text = "Modifier l'opération"
        operationPage.dateField.date = new Date(row[1] + "T00:00:00")
        setEditorTime(row[2])
        operationPage.factureField.text = row[5] === null ? "" : String(row[5])
        operationPage.operationType.currentIndex = row[3] === "FOURNITURE" ? 1 : 0
        operationPage.transactionType.currentIndex = row[4] === "INTERNATIONALE" ? 1 : 0
        operationPage.amountField.text = formatAmount(row[6])
        operationPage.paidField.text = formatAmount(row[7])
        operationPage.deductibleField.text = formatAmount(row[8])
        operationPage.commissionField.text = formatAmount(row[9])
        operationPage.profitField.text = formatAmount(row[10])
        operationPage.extraProfitField.text = formatAmount(row[11])
        operationPage.beforeField.text = formatAmount(row[12])
        operationPage.afterField.text = formatAmount(row[13])
        operationPage.noteField.text = row[14] || ""
        updateEditorTypeState()
    }

    function saveEditor() {
        if (!model)
            return

        const dateTime = editorSqlDateTime()
        if (dateTime.length === 0)
            return

        const isSupply = operationPage.operationType.currentIndex === 1
        const operationType = isSupply ? "FOURNITURE" : "TRANSACTION"
        const transactionType = isSupply ? "" : (operationPage.transactionType.currentIndex === 1
                                                    ? "INTERNATIONALE" : "NATIONALE")
        const invoiceNumber = isSupply ? 0 : Number(operationPage.factureField.text) || 0
        const amount = numberFromText(operationPage.amountField.text)
        const paid = isSupply ? 0 : numberFromText(operationPage.paidField.text)
        const deductible = isSupply ? 0 : numberFromText(operationPage.deductibleField.text)
        const commission = isSupply ? 0 : numberFromText(operationPage.commissionField.text)
        const profit = isSupply ? 0 : numberFromText(operationPage.profitField.text)
        const extraProfit = isSupply ? 0 : numberFromText(operationPage.extraProfitField.text)
        const existingRow = operationRowsById[editingOperationId]
        const balanceBefore = existingRow ? Number(existingRow[12]) || 0
                                          : Number(model.solde_avant(dateTime.slice(0, 10))) || 0
        const balanceAfter = balanceBefore - (isSupply ? amount : paid)
        let saved = 0
        if (editingOperationId > 0) {
            saved = model.modifier_operation(
                editingOperationId, dateTime, operationType, transactionType,
                invoiceNumber, amount, paid, deductible, commission, profit,
                extraProfit, balanceBefore, balanceAfter, operationPage.noteField.text
            )
        } else {
            saved = model.ajouter_operation(
                dateTime, operationType, transactionType, invoiceNumber, amount,
                paid, deductible, commission, profit, extraProfit, balanceBefore,
                balanceAfter, operationPage.noteField.text
            )
        }

        if (saved > 0) {
            updateTable()
            resetEditor()
        }
    }

    function updateSummary(rows) {
        let totalPaid = 0
        let totalProfit = 0
        let totalExtraProfit = 0

        for (let index = 0; index < rows.length; ++index) {
            totalPaid += Number(rows[index][7]) || 0
            totalProfit += Number(rows[index][10]) || 0
            totalExtraProfit += Number(rows[index][11]) || 0
        }

        const currentBalance = rows.length > 0 ? Number(rows[rows.length - 1][13]) || 0 : 0
        operationPage.currentBalanceCard.value = formatAmount(currentBalance) + " MAD"
        operationPage.totalOperationsCard.value = String(rows.length)
        operationPage.totalPaidCard.value = formatAmount(totalPaid)
        operationPage.profitCard.value = formatAmount(totalProfit)
        operationPage.extraProfitCard.value = formatAmount(totalExtraProfit)
    }

    function selectedOperationId() {
        const selectedIndex = operationPage.operationsTable.selectedRow
        const displayedRows = operationPage.operationsTable.displayRows
        if (selectedIndex < 0 || selectedIndex >= displayedRows.length)
            return 0

        return Number(displayedRows[selectedIndex][12]) || 0
    }

    function updateActionButtons() {
        const hasSelection = selectedOperationId() > 0
        operationPage.modifyButton.enabled = hasSelection
        operationPage.duplicateButton.enabled = hasSelection
        operationPage.deleteButton.enabled = hasSelection
    }

    function deleteSelectedOperation() {
        const operationId = selectedOperationId()
        if (operationId === 0 || !model)
            return

        if (model.supprimer_operation(operationId) === 1)
            updateTable()
    }

    function duplicateSelectedOperation() {
        const operationId = selectedOperationId()
        if (operationId === 0 || !model)
            return

        if (model.dupliquer_operation(operationId) > 0)
            updateTable()
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
        if (operationPage.operationTypeFilter.currentIndex === 2)
            return "ALL"

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

        const rowsById = {}
        for (let index = 0; index < rows.length; ++index)
            rowsById[rows[index][0]] = rows[index]
        operationRowsById = rowsById

        const formattedRows = rows.map(formatOperationRow)
        operationPage.operationsTable.selectedRow = -1
        operationPage.operationsTable.rows = formattedRows
        updateSummary(rows)
        updateActionButtons()
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
        operationsTable.onRowClicked: root.updateActionButtons()
        modifyButton.onClicked: root.openSelectedOperation()
        duplicateButton.onClicked: root.duplicateSelectedOperation()
        deleteButton.onClicked: root.deleteSelectedOperation()
        cancelButton.onClicked: root.resetEditor()
        saveButton.onClicked: root.saveEditor()
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
        function onCurrentIndexChanged() {
            root.updateFilterState()
            root.updateTable()
        }
    }

    Connections {
        target: operationPage.filterCombo
        function onCurrentIndexChanged() { root.updateTable() }
    }

    Connections {
        target: operationPage.operationType
        function onCurrentIndexChanged() { root.updateEditorTypeState() }
    }

    onModelChanged: {
        updateTable()
        resetEditor()
    }

    Component.onCompleted: {
        const today = new Date()
        operationPage.fromDate.date = today
        operationPage.toDate.date = today
        updateFilterState()
        resetEditor()
        updateActionButtons()
    }
}
