import QtQuick

QtObject {
    // Brand
    readonly property color primary: "#E54B22"
    readonly property color primaryHover: "#D9431D"
    readonly property color primaryPressed: "#C63B18"
    readonly property color primaryText: "#FFFFFF"

    // Text / neutral
    readonly property color text: "#111827"
    readonly property color textSecondary: "#4B5563"
    readonly property color textMuted: "#6B7280"
    readonly property color textDisabled: "#9CA3AF"

    // Semantic
    readonly property color success: "#16A34A"
    readonly property color danger: "#DC2626"
    readonly property color dangerHover: "#C91F1F"
    readonly property color dangerPressed: "#B91C1C"
    readonly property color dangerText: "#FFFFFF"
    readonly property color info: "#2563EB"
    readonly property color purple: "#7C3AED"

    // Surfaces
    readonly property color appBackground: "#F9FAFB"
    readonly property color surface: "#FFFFFF"
    readonly property color surfaceAlt: "#F3F4F6"
    readonly property color secondary: "#F9FAFB"
    readonly property color secondaryHover: "#F3F4F6"
    readonly property color secondaryPressed: "#E5E7EB"
    readonly property color secondaryText: "#111827"
    readonly property color border: "#DDE2E8"
    readonly property color borderHover: "#C7CDD5"
    readonly property color divider: "#E5E7EB"
    readonly property color selection: "#FFF1EC"
    readonly property color selectionHover: "#FFF7F4"
    readonly property color warningSurface: "#FFF5F1"

    // Type
    readonly property int fontSizeXs: 11
    readonly property int fontSizeSmall: 12
    readonly property int fontSize: 14
    readonly property int fontSizeLg: 18
    readonly property int fontSizeXl: 20
    readonly property int fontWeightMedium: Font.Medium
    readonly property int fontWeightSemibold: Font.DemiBold

    // Dimensions
    readonly property int controlHeight: 40
    readonly property int controlHeightSmall: 34
    readonly property int radiusSmall: 4
    readonly property int radius: 6
    readonly property int radiusLarge: 8
    readonly property int rowHeight: 40
    readonly property int headerHeight: 64
    readonly property int editorWidth: 380

    // Spacing
    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 24
}
