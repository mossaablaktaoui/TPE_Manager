import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window

    width: 1440
    height: 900
    minimumWidth: 1180
    minimumHeight: 720
    visible: true
    title: "TPE Manager"

    property string editorMode: "edit"
    property int selectedIndex: -1

    property var operationRows: [
        ["24/10/23", "14:30", "Transaction", "Nationale", "1 500,00", "1 500,00", "0,00", "15,00", "45,00", "0,00", "11 455,00", "Client VIP"],
        ["24/10/23", "15:15", "Fourniture", "—", "450,00", "0,00", "450,00", "0,00", "0,00", "0,00", "11 005,00", "Approvisionnement"],
        ["24/10/23", "16:45", "Transaction", "Internationale", "2 100,00", "2 100,00", "0,00", "21,00", "63,00", "10,00", "13 178,00", ""]
    ]

    function setEditorMode(mode) {
        editorMode = mode
        form.editorTitle.text = mode === "new" ? "Nouvelle opération" : "Modifier l'opération"
    }

    function updateTransactionTypeState() {
        const isTransaction = form.operationType.currentIndex === 0
        form.transactionType.enabled = isTransaction
        form.transactionTypeLabel.opacity = isTransaction ? 1.0 : 0.45
    }

    function updateSelectionActions() {
        const hasSelection = form.operationsTable.selectedRow >= 0
        form.modifyButton.enabled = hasSelection
        form.duplicateButton.enabled = hasSelection
        form.deleteButton.enabled = hasSelection
    }

    function updateTable() {
        form.operationsTable.rows = operationRows
    }

    function selectOperation(index) {
        if (index < 0 || index >= operationRows.length)
            return

        selectedIndex = index
        form.operationsTable.selectedRow = index
        setEditorMode("edit")

        const row = operationRows[index]
        form.dateTimeField.text = row[0]
        form.operationType.currentIndex = row[1] === "Fourniture" ? 1 : 0
        form.transactionType.currentIndex = row[2] === "Internationale" ? 1 : 0
        form.amountField.text = row[3]
        form.paidField.text = row[4]
        form.deductibleField.text = row[5]
        form.commissionField.text = row[6]
        form.profitField.text = row[7]
        form.extraProfitField.text = row[8]
        form.beforeField.text = index === 0 ? "11 410,00" : operationRows[index - 1][9]
        form.afterField.text = row[9]
        form.noteField.text = row[10]

        updateTransactionTypeState()
        updateSelectionActions()
    }

    function newOperation() {
        selectedIndex = -1
        form.operationsTable.selectedRow = -1
        setEditorMode("new")

        form.dateTimeField.text = Qt.formatDateTime(new Date(), "dd/MM/yy hh:mm")
        form.operationType.currentIndex = 0
        form.transactionType.currentIndex = 0
        form.amountField.text = "0,00"
        form.paidField.text = "0,00"
        form.deductibleField.text = "0,00"
        form.commissionField.text = "0,00"
        form.profitField.text = "0,00"
        form.extraProfitField.text = "0,00"
        form.beforeField.text = operationRows.length > 0 ? operationRows[operationRows.length - 1][9] : "0,00"
        form.afterField.text = form.beforeField.text
        form.noteField.text = ""

        updateTransactionTypeState()
        updateSelectionActions()
    }

    function saveOperation() {
        const transaction = form.operationType.currentIndex === 1 ? "—" : form.transactionType.currentText
        const row = [
            form.dateTimeField.text,
            form.operationType.currentText,
            transaction,
            form.amountField.text,
            form.paidField.text,
            form.deductibleField.text,
            form.commissionField.text,
            form.profitField.text,
            form.extraProfitField.text,
            form.afterField.text,
            form.noteField.text
        ]

        const copy = operationRows.slice(0)

        if (editorMode === "new") {
            copy.push(row)
            operationRows = copy
            updateTable()
            selectOperation(copy.length - 1)
            return
        }

        if (selectedIndex >= 0 && selectedIndex < copy.length) {
            copy[selectedIndex] = row
            operationRows = copy
            updateTable()
            selectOperation(selectedIndex)
        }
    }

    function duplicateSelected() {
        const index = form.operationsTable.selectedRow
        if (index < 0 || index >= operationRows.length)
            return

        const copy = operationRows.slice(0)
        const duplicate = copy[index].slice(0)
        duplicate[0] = Qt.formatDateTime(new Date(), "dd/MM/yy hh:mm")
        duplicate[10] = duplicate[10].length > 0 ? duplicate[10] + " (copie)" : "Copie"
        copy.splice(index + 1, 0, duplicate)

        operationRows = copy
        updateTable()
        selectOperation(index + 1)
    }

    function deleteSelected() {
        const index = form.operationsTable.selectedRow
        if (index < 0 || index >= operationRows.length)
            return

        const copy = operationRows.slice(0)
        copy.splice(index, 1)
        operationRows = copy
        updateTable()

        if (copy.length > 0)
            selectOperation(Math.min(index, copy.length - 1))
        else
            newOperation()
    }

    function shiftDates(days) {
        const from = new Date(form.fromDate.date)
        const to = new Date(form.toDate.date)
        from.setDate(from.getDate() + days)
        to.setDate(to.getDate() + days)
        form.fromDate.date = from
        form.toDate.date = to
    }

    function setToday() {
        const today = new Date()
        form.fromDate.date = today
        form.toDate.date = today
    }

    function cancelEditor() {
        if (form.operationsTable.selectedRow >= 0)
            selectOperation(form.operationsTable.selectedRow)
        else if (operationRows.length > 0)
            selectOperation(0)
        else
            newOperation()
    }

    MainForm {
        id: form
        anchors.fill: parent

        previousDayButton.onClicked: window.shiftDates(-1)
        nextDayButton.onClicked: window.shiftDates(1)
        todayButton.onClicked: window.setToday()
        newOperationButton.onClicked: window.newOperation()

        modifyButton.onClicked: window.selectOperation(operationsTable.selectedRow)
        duplicateButton.onClicked: window.duplicateSelected()
        deleteButton.onClicked: window.deleteSelected()
        operationsTable.onRowClicked: function(row) { window.selectOperation(row) }

        operationType.onCurrentIndexChanged: window.updateTransactionTypeState()
        cancelButton.onClicked: window.cancelEditor()
        saveButton.onClicked: window.saveOperation()
    }

    Component.onCompleted: {
        form.fromDate.date = new Date(2023, 9, 1)
        form.toDate.date = new Date(2023, 9, 31)
        updateTable()

        if (operationRows.length > 0)
            selectOperation(0)
        else
            newOperation()
    }
}
