import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Components"

Item {
    id: root

    width: 1440
    height: 900

    // Controls exported to Main.qml. The UI file contains presentation only.
    property alias previousDayButton: operationPage.previousDayButton
    property alias fromDate: operationPage.fromDate
    property alias toDate: operationPage.toDate
    property alias nextDayButton: operationPage.nextDayButton
    property alias todayButton: operationPage.todayButton
    property alias newOperationButton: operationPage.newOperationButton

    property alias modifyButton: operationPage.modifyButton
    property alias duplicateButton: operationPage.duplicateButton
    property alias deleteButton: operationPage.deleteButton
    property alias operationsTable: operationPage.operationsTable

    property alias editorTitle: editorTitle
    property alias dateTimeField: dateTimeField
    property alias operationType: operationType
    property alias transactionTypeLabel: transactionTypeLabel
    property alias transactionType: transactionType
    property alias amountField: amountField
    property alias paidField: paidField
    property alias deductibleField: deductibleField
    property alias commissionField: commissionField
    property alias profitField: profitField
    property alias extraProfitField: extraProfitField
    property alias beforeField: beforeField
    property alias afterField: afterField
    property alias noteField: noteField
    property alias cancelButton: cancelButton
    property alias saveButton: saveButton

    property alias currentBalanceCard: operationPage.currentBalanceCard
    property alias totalOperationsCard: operationPage.totalOperationsCard
    property alias totalPaidCard: operationPage.totalPaidCard
    property alias profitCard: operationPage.profitCard
    property alias extraProfitCard: operationPage.extraProfitCard

    Theme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        color: theme.appBackground
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: theme.headerHeight
            color: theme.surface

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: theme.spacingLg

                BaseButton {
                    id: baseButton
                    height: 36
                    text: "Parametres"
                }

                Text {
                    text: "TPE Manager"
                    color: theme.text
                    font.pixelSize: theme.fontSizeXl
                    Layout.leftMargin: 0
                    font.weight: theme.fontWeightSemibold
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: "Gestion quotidienne des opérations"
                    color: theme.textMuted
                    font.pixelSize: theme.fontSizeSmall
                    Layout.rightMargin: 0
                    rightPadding: 0
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: theme.divider
            }
        }

        // Main content
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            ColumnLayout {
                id: tabcolum
                
                TabBar {
                    id: tabBar
                    Layout.fillWidth: false
                    spacing: 8

                    background: Rectangle {
                        color: "transparent"
                    }

                    TabButton {
                        id: operationsTab
                        text: "Opérations"
                        width: 120
                        height: 42

                        contentItem: Text {
                            text: operationsTab.text
                            color: operationsTab.checked ? "#e54b22" : "#6b7280"
                            font.pixelSize: 14
                            font.weight: operationsTab.checked ? Font.DemiBold : Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            color: operationsTab.hovered ? "#fff4f0" : "transparent"
                            radius: 6

                            Rectangle {
                                width: parent.width
                                height: 2
                                anchors.bottom: parent.bottom
                                color: operationsTab.checked ? "#e54b22" : "transparent"
                                radius: 1
                            }
                        }
                    }

                    TabButton {
                        id: reportsTab
                        text: "Rapports"
                        width: 110
                        height: 42

                        contentItem: Text {
                            text: reportsTab.text
                            color: reportsTab.checked ? "#e54b22" : "#6b7280"
                            font.pixelSize: 14
                            font.weight: reportsTab.checked ? Font.DemiBold : Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            color: reportsTab.hovered ? "#fff4f0" : "transparent"
                            radius: 6

                            Rectangle {
                                width: parent.width
                                height: 2
                                anchors.bottom: parent.bottom
                                color: reportsTab.checked ? "#e54b22" : "transparent"
                                radius: 1
                            }
                        }
                    }

                    TabButton {
                        id: settingsTab
                        text: "Paramètres"
                        width: 120
                        height: 42

                        contentItem: Text {
                            text: settingsTab.text
                            color: settingsTab.checked ? "#e54b22" : "#6b7280"
                            font.pixelSize: 14
                            font.weight: settingsTab.checked ? Font.DemiBold : Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            color: settingsTab.hovered ? "#fff4f0" : "transparent"
                            radius: 6

                            Rectangle {
                                width: parent.width
                                height: 2
                                anchors.bottom: parent.bottom
                                color: settingsTab.checked ? "#e54b22" : "transparent"
                                radius: 1
                            }
                        }
                    }
                }

                StackLayout {
                        id: tabPages

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        currentIndex: tabBar.currentIndex

                        Operation {
                            id: operationPage

                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Text {
                                anchors.centerIn: parent
                                text: "Rapports"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Text {
                                anchors.centerIn: parent
                                text: "Paramètres"
                            }
                        }
                    }
            }
                
            // Right: editor
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
                            text: "Créer ou Modifier l'opération"
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
                                    text: "Date et heure"
                                    color: theme.textMuted
                                    font.pixelSize: theme.fontSizeSmall
                                    font.weight: theme.fontWeightMedium
                                }

                                Text {
                                    text: "Facture N"
                                    color: theme.textMuted
                                    font.pixelSize: theme.fontSizeSmall
                                    font.weight: theme.fontWeightMedium
                                }

                                Entry {
                                    id: dateTimeField
                                    Layout.fillWidth: true
                                    placeholderText: "24/10/23 14:30"
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
                                    text: "Montant déductible"
                                    color: theme.textMuted
                                    font.pixelSize: theme.fontSizeSmall
                                }

                                Text {
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
                                    text: "Bénéfice"
                                    color: theme.textMuted
                                    font.pixelSize: theme.fontSizeSmall
                                }

                                Text {
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
}
