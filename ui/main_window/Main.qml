import QtQuick
import QtQuick.Controls
import "./"

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

    property var model

    function newOperation() {
        selectedIndex = -1
        mainwindow.operationsTable.selectedRow = -1
        setEditorMode("new")

        mainwindow.dateTimeField.text = Qt.formatDateTime(new Date(), "dd/MM/yy hh:mm")
        mainwindow.operationType.currentIndex = 0
        mainwindow.transactionType.currentIndex = 0
        mainwindow.amountField.text = "0,00"
        mainwindow.paidField.text = "0,00"
        mainwindow.deductibleField.text = "0,00"
        mainwindow.commissionField.text = "0,00"
        mainwindow.profitField.text = "0,00"
        mainwindow.extraProfitField.text = "0,00"
        mainwindow.beforeField.text = operationRows.length > 0 ? operationRows[operationRows.length - 1][9] : "0,00"
        mainwindow.afterField.text = mainwindow.beforeField.text
        mainwindow.noteField.text = ""

        updateTransactionTypeState()
        updateSelectionActions()
    }

    function cancelEditor() {
        if (mainwindow.operationsTable.selectedRow >= 0)
            selectOperation(mainwindow.operationsTable.selectedRow)
        else if (operationRows.length > 0)
            selectOperation(0)
        else
            newOperation()
    }

    MainForm {
        id: mainwindow
        anchors.fill: parent
        operationPage.model: window.model
    }
}
