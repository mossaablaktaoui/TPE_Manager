import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Components"

Item {
    id: root

    width: 1440
    height: 900

    property alias operationPage: operationPage

    property alias modifyButton: operationPage.modifyButton
    property alias duplicateButton: operationPage.duplicateButton
    property alias deleteButton: operationPage.deleteButton
    property alias operationsTable: operationPage.operationsTable

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
                spacing: 0

                TabBar {
                    id: tabBar
                    height: 42
                    position: TabBar.Header
                    contentWidth: 1060
                    contentHeight: 42
                    Layout.topMargin: 0
                    Layout.fillWidth: true
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
        }
    }
}
