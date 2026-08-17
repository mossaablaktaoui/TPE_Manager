import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../Components"

Item {
    id: root

    implicitWidth: 1400
    implicitHeight: 700

    Theme {
        id: theme
    }

    property alias previousDayButton: previousDayButton
    property alias fromDate: fromDate
    property alias toDate: toDate
    property alias nextDayButton: nextDayButton
    property alias todayButton: todayButton
    property alias operationTypeFilter: typeOperationCombo
    property alias filterCombo: comboEntry

    property alias modifyButton: modifyButton
    property alias duplicateButton: duplicateButton
    property alias deleteButton: deleteButton

    property alias operationsTable: operationsTable

    property alias currentBalanceCard: currentBalanceCard
    property alias totalOperationsCard: totalOperationsCard
    property alias totalPaidCard: totalPaidCard
    property alias profitCard: profitCard
    property alias extraProfitCard: extraProfitCard

    property alias editorTitle: editorTitle
    property alias dateField: dateField
    property alias factureLabel: factureLabel
    property alias factureField: factureField
    property alias operationType: operationType
    property alias transactionTypeLabel: transactionTypeLabel
    property alias transactionType: transactionType
    property alias amountField: amountField
    property alias paidLabel: paidLabel
    property alias paidField: paidField
    property alias deductibleLabel: deductibleLabel
    property alias deductibleField: deductibleField
    property alias commissionLabel: commissionLabel
    property alias commissionField: commissionField
    property alias profitLabel: profitLabel
    property alias profitField: profitField
    property alias extraProfitLabel: extraProfitLabel
    property alias extraProfitField: extraProfitField
    property alias beforeField: beforeField
    property alias afterField: afterField
    property alias noteField: noteField
    property alias cancelButton: cancelButton
    property alias saveButton: saveButton

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            anchors.margins: theme.spacingXl
            Layout.margins: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 5

            GridLayout {
                Layout.fillWidth: true
                rows: 2
                flow: GridLayout.TopToBottom
                columnSpacing: 0
                rowSpacing: 5

                Item {
                }

                SecondaryButton {
                    id: previousDayButton
                    text: ""
                    bottomPadding: 5
                    padding: 0
                    rightPadding: 0
                    leftPadding: 7
                    iconText: "‹"
                    implicitWidth: 40
                    bottomRightRadius: 0
                    topRightRadius: 0

                }

                Text {
                color: theme.textMuted
                text: "Du"
                font.pixelSize: theme.fontSizeSmall
                leftPadding: 5
            }

                DateEntry {
                    id: fromDate
                }

                Text {
                    text: "Au"
                    color: theme.textMuted
                    font.pixelSize: theme.fontSizeSmall
                    leftPadding: 5
                }

                DateEntry {
                    id: toDate
                }

                Item {
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                }

                SecondaryButton {
                    id: nextDayButton
                    iconText: "›"
                    text: ""
                    bottomPadding: 5
                    padding: 0
                    rightPadding: 0
                    leftPadding: 7
                    implicitWidth: 40
                    bottomLeftRadius: 0
                    topLeftRadius: 0
                }

                SecondaryButton {
                    id: todayButton
                    text: "Aujourd'hui"
                    Layout.leftMargin: 5
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: "Type de Operation"
                    color: theme.textMuted
                    font.pixelSize: theme.fontSizeSmall
                    leftPadding: 5
                    Layout.leftMargin: 5
                }

                ComboEntry {
                    id: typeOperationCombo
                    implicitWidth: 170
                    Layout.leftMargin: 5

                    model: ["Tous", "Transaction", "Fournitures"]
                }

                Text {
                    text: "Type de Transaction"
                    color: theme.textMuted
                    font.pixelSize: theme.fontSizeSmall
                    leftPadding: 5
                }

                ComboEntry {
                    id: comboEntry
                    implicitWidth: 170
                    Layout.leftMargin: 5

                    model: ["Tous", "National", "International"]
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: theme.spacingSm

                Text {
                    text: "Historique des opérations"
                    color: theme.text
                    font.pixelSize: theme.fontSizeLg
                    font.weight: theme.fontWeightSemibold
                }

                Item {
                    Layout.fillWidth: true
                }

                SecondaryButton {
                    id: exportTableButton
                    text: "Export Table"
                }

                SecondaryButton {
                    id: modifyButton
                    text: "Modifier"
                    iconText: "✎"
                }

                SecondaryButton {
                    id: duplicateButton
                    text: "Dupliquer"
                    iconText: "⧉"
                }

                DangerButton {
                    id: deleteButton
                    text: "Supprimer"
                    iconText: "×"
                }
            }

            OperationsTable {
                id: operationsTable

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 300
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: theme.spacingMd

                StatCard {
                    id: currentBalanceCard
                    Layout.fillWidth: true

                    title: "Solde actuel"
                    value: "12 450,00 MAD"
                    valueColor: theme.primary
                    emphasis: true
                }

                StatCard {
                    id: totalOperationsCard
                    Layout.fillWidth: true

                    title: "Total des opérations"
                    value: "45"
                }

                StatCard {
                    id: totalPaidCard
                    Layout.fillWidth: true

                    title: "Total versé"
                    value: "8 500,00"
                    valueColor: theme.success
                }

                StatCard {
                    id: profitCard
                    Layout.fillWidth: true

                    title: "Bénéfice"
                    value: "450,00"
                    valueColor: theme.info
                }

                StatCard {
                    id: extraProfitCard
                    Layout.fillWidth: true

                    title: "Bénéfice supplémentaire"
                    value: "120,00"
                    valueColor: theme.purple
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: theme.editorWidth
            Layout.fillHeight: true
            color: theme.surface

            Rectangle {
                anchors.left: parent.left
                width: 1
                height: parent.height
                color: theme.divider
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 58
                    color: theme.surface
                    Layout.leftMargin: 1

                    Text {
                        id: editorTitle
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Créer une nouvelle opération"
                        color: theme.text
                        font.pixelSize: theme.fontSizeLg
                        font.weight: theme.fontWeightSemibold
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: theme.divider
                    }
                }

                ScrollView {
                    width: 380
                    height: 666
                    padding: 10
                    topPadding: 10
                    contentHeight: 666
                    contentWidth: 360
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                    ColumnLayout {
                        anchors.fill: parent
                        layoutDirection: Qt.LeftToRight
                        spacing: 10

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: 12
                            rowSpacing: 7

                            Text {
                                text: "Date"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                                font.weight: theme.fontWeightMedium
                            }

                            Text {
                                id: factureLabel
                                text: "N° de facture"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                                font.weight: theme.fontWeightMedium
                            }

                            DateEntry {
                                id: dateField
                                Layout.fillWidth: true
                            }

                            Entry {
                                id: factureField
                                Layout.fillWidth: true
                                placeholderText: "1"
                            }
                        }

                        Text {
                            text: "Type d'opération"
                            color: theme.textMuted
                            font.pixelSize: theme.fontSizeSmall
                            font.weight: theme.fontWeightMedium
                        }

                        ComboEntry {
                            id: operationType
                            Layout.fillWidth: true
                            model: ["Transaction", "Fourniture"]
                        }

                        Text {
                            id: transactionTypeLabel
                            text: "Type de transaction"
                            color: theme.textMuted
                            font.pixelSize: theme.fontSizeSmall
                            font.weight: theme.fontWeightMedium
                        }

                        ComboEntry {
                            id: transactionType
                            Layout.fillWidth: true
                            model: ["Nationale", "Internationale"]
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: 12
                            rowSpacing: 7

                            Text {
                                text: "Montant opération"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                            }

                            Text {
                                id: paidLabel
                                text: "Montant versé"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                            }

                            MoneyEntry {
                                id: amountField
                                Layout.fillWidth: true
                            }

                            MoneyEntry {
                                id: paidField
                                Layout.fillWidth: true
                                valueColor: theme.success
                            }

                            Text {
                                id: deductibleLabel
                                text: "Montant déductible"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                            }

                            Text {
                                id: commissionLabel
                                text: "Commission CMI"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                            }

                            MoneyEntry {
                                id: deductibleField
                                Layout.fillWidth: true
                            }

                            MoneyEntry {
                                id: commissionField
                                Layout.fillWidth: true
                                valueColor: theme.danger
                            }

                            Text {
                                id: profitLabel
                                text: "Bénéfice"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                            }

                            Text {
                                id: extraProfitLabel
                                text: "Bénéfice supplémentaire"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSmall
                            }

                            MoneyEntry {
                                id: profitField
                                Layout.fillWidth: true
                                valueColor: theme.info
                            }

                            MoneyEntry {
                                id: extraProfitField
                                Layout.fillWidth: true
                                valueColor: theme.purple
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 74
                            radius: theme.radius
                            color: theme.surfaceAlt
                            border.width: 1
                            border.color: theme.border

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: "Solde avant"
                                        color: theme.textMuted
                                        font.pixelSize: theme.fontSizeSmall
                                    }

                                    Text {
                                        id: beforeField
                                        text: "11 410,00"
                                        color: theme.text
                                        font.pixelSize: theme.fontSize
                                        font.weight: theme.fontWeightMedium
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true
                                    color: theme.divider
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: "Solde après"
                                        color: theme.primary
                                        font.pixelSize: theme.fontSizeSmall
                                    }

                                    Text {
                                        id: afterField
                                        text: "11 455,00"
                                        color: theme.primary
                                        font.pixelSize: theme.fontSize
                                        font.weight: theme.fontWeightSemibold
                                    }
                                }
                            }
                        }

                        Text {
                            text: "Remarque"
                            color: theme.textMuted
                            font.pixelSize: theme.fontSizeSmall
                            font.weight: theme.fontWeightMedium
                        }

                        TextArea {
                            id: noteField
                            Layout.fillWidth: true
                            Layout.preferredHeight: 74
                            padding: 10
                            wrapMode: TextEdit.Wrap
                            font.pixelSize: theme.fontSize
                            color: theme.text
                            placeholderText: "Ajouter une remarque..."
                            placeholderTextColor: theme.textDisabled

                            background: Rectangle {
                                color: theme.surface
                                radius: theme.radius
                                border.width: 1
                                border.color: theme.border
                            }
                        }
                    }
                }

                Rectangle {
                    id: rectangle
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    color: theme.surface

                    Rectangle {
                        anchors.top: parent.top
                        width: parent.width
                        height: 1
                        color: theme.divider
                    }

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                        spacing: 10

                        SecondaryButton {
                            id: cancelButton
                            Layout.fillWidth: true
                            text: "Effacer"
                        }

                        PrimaryButton {
                            id: saveButton
                            Layout.fillWidth: true
                            text: "Enregistrer"
                        }
                    }
                }
            }
        }
    }
}
