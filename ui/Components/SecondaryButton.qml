import QtQuick

BaseButton {
    id: root

    Theme { id: theme }
    normalColor: theme.surface
    hoverColor: theme.secondaryHover
    pressedColor: theme.secondaryPressed
    normalTextColor: theme.secondaryText
    borderColor: theme.border
}
