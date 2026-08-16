import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "Components"

Item {
    id: root

    implicitWidth: 1000
    implicitHeight: 700

    property alias previousDayButton: previousDayButton
    property alias fromDate: fromDate
    property alias toDate: toDate
    property alias nextDayButton: nextDayButton
    property alias todayButton: todayButton
    property alias filterCombo: comboEntry

    property alias newOperationButton: newOperationButton
    property alias modifyButton: modifyButton
    property alias duplicateButton: duplicateButton
    property alias deleteButton: deleteButton

    property alias operationsTable: operationsTable

    property alias currentBalanceCard: currentBalanceCard
    property alias totalOperationsCard: totalOperationsCard
    property alias totalPaidCard: totalPaidCard
    property alias profitCard: profitCard
    property alias extraProfitCard: extraProfitCard

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.spacingXl
        spacing: theme.spacingLg

        RowLayout {
            Layout.fillWidth: true
            spacing: theme.spacingSm

            SecondaryButton {
                id: previousDayButton
                text: ""
                iconText: "‹"
                implicitWidth: 40
            }

            Text {
                text: "Du"
                color: theme.textMuted
                font.pixelSize: theme.fontSizeSmall
            }

            DateEntry {
                id: fromDate
            }

            Text {
                text: "Au"
                color: theme.textMuted
                font.pixelSize: theme.fontSizeSmall
            }

            DateEntry {
                id: toDate
            }

            SecondaryButton {
                id: nextDayButton
                text: ""
                iconText: "›"
                implicitWidth: 40
            }

            SecondaryButton {
                id: todayButton
                text: "Aujourd'hui"
            }

            Item {
                Layout.fillWidth: true
            }

            ComboEntry {
                id: comboEntry
                implicitWidth: 170

                model: [
                    "Tous",
                    "National",
                    "International"
                ]
            }

            PrimaryButton {
                id: newOperationButton
                text: "Nouvelle opération"
                iconText: "+"
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

            headers: [
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

            columnWidths: [
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
}