import QtQuick

BaseButton {
    Theme { id: theme }
    normalColor: theme.primary
    hoverColor: theme.primaryHover
    pressedColor: theme.primaryPressed
    normalTextColor: theme.primaryText
    borderColor: "transparent"
}
