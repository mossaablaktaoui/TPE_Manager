import QtQuick

BaseButton {
    Theme { id: theme }
    normalColor: theme.surface
    hoverColor: "#FEF2F2"
    pressedColor: "#FEE2E2"
    normalTextColor: theme.danger
    borderColor: theme.border
}
