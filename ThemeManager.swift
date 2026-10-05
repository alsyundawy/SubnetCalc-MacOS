//
//  ThemeManager.swift
//  SubnetCalc
//
//  Modern Multi-Theme Engine & Appearance Helpers
//  Comprehensive integration of ALL palettes from ActuallyTaylor/Swift-Themes:
//  https://github.com/ActuallyTaylor/Swift-Themes
//  (Catppuccin Mocha/Macchiato/Frappé/Latte, Dracula, Gruvbox Dark/Light,
//   Solarized Dark/Light, Tomorrow Night Blue/Night/Eighties/Bright/Day)
//

import Cocoa

#if canImport(AppKit)
public typealias BridgeColor = NSColor
#endif

// MARK: - Hex Color Extension (ActuallyTaylor/Swift-Themes Pattern)
public extension NSColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(calibratedRed: 0, green: 0, blue: 0, alpha: alpha)
            return
        }
        let length = hexSanitized.count
        if length == 6 {
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(calibratedRed: r, green: g, blue: b, alpha: alpha)
        } else if length == 8 {
            let r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            let g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            let b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            let a = CGFloat(rgb & 0x000000FF) / 255.0
            self.init(calibratedRed: r, green: g, blue: b, alpha: a)
        } else {
            self.init(calibratedRed: 0, green: 0, blue: 0, alpha: alpha)
        }
    }
}

// MARK: - App Theme Identifier Enum
public enum AppThemeID: String, CaseIterable {
    // Catppuccin Family
    case catppuccinMocha = "Catppuccin Mocha"
    case catppuccinMacchiato = "Catppuccin Macchiato"
    case catppuccinFrappe = "Catppuccin Frappé"
    case catppuccinLatte = "Catppuccin Latte"

    // Dracula Family
    case dracula = "Dracula"

    // Gruvbox Family
    case gruvboxDark = "Gruvbox Dark"
    case gruvboxLight = "Gruvbox Light"

    // Solarized Family
    case solarizedDark = "Solarized Dark"
    case solarizedLight = "Solarized Light"

    // Tomorrow Family
    case tomorrowNightBlue = "Tomorrow Night Blue"
    case tomorrowNight = "Tomorrow Night"
    case tomorrowNightEighties = "Tomorrow Night Eighties"
    case tomorrowNightBright = "Tomorrow Night Bright"
    case tomorrowDay = "Tomorrow Day"

    public var groupName: String {
        switch self {
        case .catppuccinMocha, .catppuccinMacchiato, .catppuccinFrappe, .catppuccinLatte:
            return "Catppuccin"
        case .dracula:
            return "Dracula"
        case .gruvboxDark, .gruvboxLight:
            return "Gruvbox"
        case .solarizedDark, .solarizedLight:
            return "Solarized"
        case .tomorrowNightBlue, .tomorrowNight, .tomorrowNightEighties, .tomorrowNightBright, .tomorrowDay:
            return "Tomorrow"
        }
    }
}

// MARK: - Theme Palette Structure
public struct ThemePalette {
    public let id: AppThemeID
    public let displayName: String
    public let isDark: Bool

    // Canvas & Containers
    public let windowBackground: NSColor
    public let cardBackground: NSColor
    public let cardBorder: NSColor

    // Tables & Rows
    public let tableBackground: NSColor
    public let tableRowAlt: NSColor
    public let tableGridColor: NSColor
    public let tableHeaderColor: NSColor
    public let tableTextPrimary: NSColor
    public let tableTextSecondary: NSColor

    // Accents & Bit Visualizer
    public let accentCyan: NSColor
    public let accentBlue: NSColor
    public let networkBitColor: NSColor
    public let subnetBitColor: NSColor
    public let hostBitColor: NSColor
    public let separatorBitColor: NSColor

    // Pill Badges
    public let rfc1918Bg: NSColor
    public let rfc1918Fg: NSColor
    public let publicBg: NSColor
    public let publicFg: NSColor
    public let cgnatBg: NSColor
    public let cgnatFg: NSColor
    public let loopbackBg: NSColor
    public let loopbackFg: NSColor
    public let reservedBg: NSColor
    public let reservedFg: NSColor
}

// MARK: - Theme Factory (ActuallyTaylor/Swift-Themes Reference)
public struct SwiftThemes {
    public static func palette(for id: AppThemeID) -> ThemePalette {
        switch id {
        case .catppuccinMocha:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#11111b"), // Crust
                cardBackground: NSColor(hex: "#1e1e2e"),   // Base
                cardBorder: NSColor(hex: "#313244"),       // Surface0
                tableBackground: NSColor(hex: "#1e1e2e"),
                tableRowAlt: NSColor(hex: "#181825"),       // Mantle
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#45475a"),  // Surface1
                tableTextPrimary: NSColor(hex: "#cdd6f4"),  // Text
                tableTextSecondary: NSColor(hex: "#a6adc8"),// Subtext0
                accentCyan: NSColor(hex: "#74c7ec"),        // Sapphire
                accentBlue: NSColor(hex: "#89b4fa"),        // Blue
                networkBitColor: NSColor(hex: "#74c7ec"),   // Sapphire
                subnetBitColor: NSColor(hex: "#cba6f7"),    // Mauve
                hostBitColor: NSColor(hex: "#a6e3a1"),      // Green
                separatorBitColor: NSColor(hex: "#6c7086"), // Overlay0
                rfc1918Bg: NSColor(calibratedRed: 26/255, green: 56/255, blue: 45/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#a6e3a1"),
                publicBg: NSColor(calibratedRed: 28/255, green: 45/255, blue: 82/255, alpha: 0.90),
                publicFg: NSColor(hex: "#89b4fa"),
                cgnatBg: NSColor(calibratedRed: 74/255, green: 44/255, blue: 23/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#fab387"),
                loopbackBg: NSColor(calibratedRed: 22/255, green: 58/255, blue: 64/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#94e2d5"),
                reservedBg: NSColor(calibratedRed: 53/255, green: 32/255, blue: 74/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#cba6f7")
            )

        case .catppuccinMacchiato:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#181926"),
                cardBackground: NSColor(hex: "#24273a"),
                cardBorder: NSColor(hex: "#363a4f"),
                tableBackground: NSColor(hex: "#24273a"),
                tableRowAlt: NSColor(hex: "#1e2030"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#494d64"),
                tableTextPrimary: NSColor(hex: "#cad3f5"),
                tableTextSecondary: NSColor(hex: "#a5adcb"),
                accentCyan: NSColor(hex: "#7dc4e4"),
                accentBlue: NSColor(hex: "#8aadf4"),
                networkBitColor: NSColor(hex: "#7dc4e4"),
                subnetBitColor: NSColor(hex: "#c6a0f6"),
                hostBitColor: NSColor(hex: "#a6da95"),
                separatorBitColor: NSColor(hex: "#6e738d"),
                rfc1918Bg: NSColor(calibratedRed: 26/255, green: 56/255, blue: 45/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#a6da95"),
                publicBg: NSColor(calibratedRed: 28/255, green: 45/255, blue: 82/255, alpha: 0.90),
                publicFg: NSColor(hex: "#8aadf4"),
                cgnatBg: NSColor(calibratedRed: 74/255, green: 44/255, blue: 23/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#f5a97f"),
                loopbackBg: NSColor(calibratedRed: 22/255, green: 58/255, blue: 64/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#8bd5ca"),
                reservedBg: NSColor(calibratedRed: 53/255, green: 32/255, blue: 74/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#c6a0f6")
            )

        case .catppuccinFrappe:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#232634"),
                cardBackground: NSColor(hex: "#303446"),
                cardBorder: NSColor(hex: "#414559"),
                tableBackground: NSColor(hex: "#303446"),
                tableRowAlt: NSColor(hex: "#292c3c"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#51576d"),
                tableTextPrimary: NSColor(hex: "#c6d0f5"),
                tableTextSecondary: NSColor(hex: "#a5adce"),
                accentCyan: NSColor(hex: "#85c1dc"),
                accentBlue: NSColor(hex: "#8caaee"),
                networkBitColor: NSColor(hex: "#85c1dc"),
                subnetBitColor: NSColor(hex: "#ca9ee6"),
                hostBitColor: NSColor(hex: "#a6d189"),
                separatorBitColor: NSColor(hex: "#737994"),
                rfc1918Bg: NSColor(calibratedRed: 26/255, green: 56/255, blue: 45/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#a6d189"),
                publicBg: NSColor(calibratedRed: 28/255, green: 45/255, blue: 82/255, alpha: 0.90),
                publicFg: NSColor(hex: "#8caaee"),
                cgnatBg: NSColor(calibratedRed: 74/255, green: 44/255, blue: 23/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#ef9f76"),
                loopbackBg: NSColor(calibratedRed: 22/255, green: 58/255, blue: 64/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#81c8be"),
                reservedBg: NSColor(calibratedRed: 53/255, green: 32/255, blue: 74/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#ca9ee6")
            )

        case .catppuccinLatte:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: false,
                windowBackground: NSColor(hex: "#dce0e8"),
                cardBackground: NSColor(hex: "#eff1f5"),
                cardBorder: NSColor(hex: "#ccd0da"),
                tableBackground: NSColor(hex: "#eff1f5"),
                tableRowAlt: NSColor(hex: "#e6e9ef"),
                tableGridColor: NSColor(calibratedWhite: 0.0, alpha: 0.06),
                tableHeaderColor: NSColor(hex: "#bcc0cc"),
                tableTextPrimary: NSColor(hex: "#4c4f69"),
                tableTextSecondary: NSColor(hex: "#6c6f85"),
                accentCyan: NSColor(hex: "#1e66f5"),
                accentBlue: NSColor(hex: "#1e66f5"),
                networkBitColor: NSColor(hex: "#209fb5"),
                subnetBitColor: NSColor(hex: "#8839ef"),
                hostBitColor: NSColor(hex: "#40a02b"),
                separatorBitColor: NSColor(hex: "#9ca0b0"),
                rfc1918Bg: NSColor(calibratedRed: 220/255, green: 247/255, blue: 225/255, alpha: 1.0),
                rfc1918Fg: NSColor(hex: "#40a02b"),
                publicBg: NSColor(calibratedRed: 225/255, green: 235/255, blue: 255/255, alpha: 1.0),
                publicFg: NSColor(hex: "#1e66f5"),
                cgnatBg: NSColor(calibratedRed: 255/255, green: 240/255, blue: 220/255, alpha: 1.0),
                cgnatFg: NSColor(hex: "#fe640b"),
                loopbackBg: NSColor(calibratedRed: 220/255, green: 245/255, blue: 245/255, alpha: 1.0),
                loopbackFg: NSColor(hex: "#179299"),
                reservedBg: NSColor(calibratedRed: 240/255, green: 230/255, blue: 255/255, alpha: 1.0),
                reservedFg: NSColor(hex: "#8839ef")
            )

        case .dracula:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#1e1f29"),
                cardBackground: NSColor(hex: "#282a36"),
                cardBorder: NSColor(hex: "#44475a"),
                tableBackground: NSColor(hex: "#282a36"),
                tableRowAlt: NSColor(hex: "#21222c"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#44475a"),
                tableTextPrimary: NSColor(hex: "#f8f8f2"),
                tableTextSecondary: NSColor(hex: "#6272a4"),
                accentCyan: NSColor(hex: "#8be9fd"),
                accentBlue: NSColor(hex: "#bd93f9"),
                networkBitColor: NSColor(hex: "#8be9fd"),
                subnetBitColor: NSColor(hex: "#bd93f9"),
                hostBitColor: NSColor(hex: "#50fa7b"),
                separatorBitColor: NSColor(hex: "#6272a4"),
                rfc1918Bg: NSColor(calibratedRed: 20/255, green: 55/255, blue: 30/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#50fa7b"),
                publicBg: NSColor(calibratedRed: 30/255, green: 40/255, blue: 75/255, alpha: 0.90),
                publicFg: NSColor(hex: "#8be9fd"),
                cgnatBg: NSColor(calibratedRed: 70/255, green: 45/255, blue: 20/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#ffb86c"),
                loopbackBg: NSColor(calibratedRed: 20/255, green: 50/255, blue: 60/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#8be9fd"),
                reservedBg: NSColor(calibratedRed: 50/255, green: 30/255, blue: 70/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#ff79c6")
            )

        case .gruvboxDark:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#1d2021"),
                cardBackground: NSColor(hex: "#282828"),
                cardBorder: NSColor(hex: "#3c3836"),
                tableBackground: NSColor(hex: "#282828"),
                tableRowAlt: NSColor(hex: "#32302f"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#504945"),
                tableTextPrimary: NSColor(hex: "#ebdbb2"),
                tableTextSecondary: NSColor(hex: "#a89984"),
                accentCyan: NSColor(hex: "#83a598"),
                accentBlue: NSColor(hex: "#458588"),
                networkBitColor: NSColor(hex: "#8ec07c"),
                subnetBitColor: NSColor(hex: "#d3869b"),
                hostBitColor: NSColor(hex: "#b8bb26"),
                separatorBitColor: NSColor(hex: "#928374"),
                rfc1918Bg: NSColor(calibratedRed: 35/255, green: 50/255, blue: 25/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#b8bb26"),
                publicBg: NSColor(calibratedRed: 25/255, green: 40/255, blue: 55/255, alpha: 0.90),
                publicFg: NSColor(hex: "#83a598"),
                cgnatBg: NSColor(calibratedRed: 65/255, green: 40/255, blue: 20/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#fe8019"),
                loopbackBg: NSColor(calibratedRed: 25/255, green: 50/255, blue: 50/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#8ec07c"),
                reservedBg: NSColor(calibratedRed: 50/255, green: 30/255, blue: 45/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#d3869b")
            )

        case .gruvboxLight:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: false,
                windowBackground: NSColor(hex: "#f2e5bc"),
                cardBackground: NSColor(hex: "#fbf1c7"),
                cardBorder: NSColor(hex: "#ebdbb2"),
                tableBackground: NSColor(hex: "#fbf1c7"),
                tableRowAlt: NSColor(hex: "#f4e8ba"),
                tableGridColor: NSColor(calibratedWhite: 0.0, alpha: 0.06),
                tableHeaderColor: NSColor(hex: "#d5c4a1"),
                tableTextPrimary: NSColor(hex: "#3c3836"),
                tableTextSecondary: NSColor(hex: "#7c6f64"),
                accentCyan: NSColor(hex: "#076678"),
                accentBlue: NSColor(hex: "#458588"),
                networkBitColor: NSColor(hex: "#427b58"),
                subnetBitColor: NSColor(hex: "#8f3f71"),
                hostBitColor: NSColor(hex: "#79740e"),
                separatorBitColor: NSColor(hex: "#928374"),
                rfc1918Bg: NSColor(calibratedRed: 230/255, green: 245/255, blue: 220/255, alpha: 1.0),
                rfc1918Fg: NSColor(hex: "#79740e"),
                publicBg: NSColor(calibratedRed: 225/255, green: 235/255, blue: 245/255, alpha: 1.0),
                publicFg: NSColor(hex: "#076678"),
                cgnatBg: NSColor(calibratedRed: 255/255, green: 235/255, blue: 215/255, alpha: 1.0),
                cgnatFg: NSColor(hex: "#af3a03"),
                loopbackBg: NSColor(calibratedRed: 220/255, green: 245/255, blue: 240/255, alpha: 1.0),
                loopbackFg: NSColor(hex: "#427b58"),
                reservedBg: NSColor(calibratedRed: 245/255, green: 230/255, blue: 245/255, alpha: 1.0),
                reservedFg: NSColor(hex: "#8f3f71")
            )

        case .solarizedDark:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#00212b"),
                cardBackground: NSColor(hex: "#002b36"),
                cardBorder: NSColor(hex: "#073642"),
                tableBackground: NSColor(hex: "#002b36"),
                tableRowAlt: NSColor(hex: "#073642"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#586e75"),
                tableTextPrimary: NSColor(hex: "#839496"),
                tableTextSecondary: NSColor(hex: "#586e75"),
                accentCyan: NSColor(hex: "#268bd2"),
                accentBlue: NSColor(hex: "#268bd2"),
                networkBitColor: NSColor(hex: "#2aa198"),
                subnetBitColor: NSColor(hex: "#6c71c4"),
                hostBitColor: NSColor(hex: "#859900"),
                separatorBitColor: NSColor(hex: "#586e75"),
                rfc1918Bg: NSColor(calibratedRed: 20/255, green: 50/255, blue: 20/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#859900"),
                publicBg: NSColor(calibratedRed: 15/255, green: 40/255, blue: 60/255, alpha: 0.90),
                publicFg: NSColor(hex: "#268bd2"),
                cgnatBg: NSColor(calibratedRed: 60/255, green: 35/255, blue: 15/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#cb4b16"),
                loopbackBg: NSColor(calibratedRed: 15/255, green: 45/255, blue: 45/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#2aa198"),
                reservedBg: NSColor(calibratedRed: 40/255, green: 30/255, blue: 60/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#6c71c4")
            )

        case .solarizedLight:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: false,
                windowBackground: NSColor(hex: "#eee8d5"),
                cardBackground: NSColor(hex: "#fdf6e3"),
                cardBorder: NSColor(hex: "#e0d8c3"),
                tableBackground: NSColor(hex: "#fdf6e3"),
                tableRowAlt: NSColor(hex: "#eee8d5"),
                tableGridColor: NSColor(calibratedWhite: 0.0, alpha: 0.06),
                tableHeaderColor: NSColor(hex: "#93a1a1"),
                tableTextPrimary: NSColor(hex: "#657b83"),
                tableTextSecondary: NSColor(hex: "#93a1a1"),
                accentCyan: NSColor(hex: "#268bd2"),
                accentBlue: NSColor(hex: "#268bd2"),
                networkBitColor: NSColor(hex: "#2aa198"),
                subnetBitColor: NSColor(hex: "#6c71c4"),
                hostBitColor: NSColor(hex: "#859900"),
                separatorBitColor: NSColor(hex: "#93a1a1"),
                rfc1918Bg: NSColor(calibratedRed: 230/255, green: 245/255, blue: 220/255, alpha: 1.0),
                rfc1918Fg: NSColor(hex: "#859900"),
                publicBg: NSColor(calibratedRed: 225/255, green: 235/255, blue: 250/255, alpha: 1.0),
                publicFg: NSColor(hex: "#268bd2"),
                cgnatBg: NSColor(calibratedRed: 255/255, green: 235/255, blue: 220/255, alpha: 1.0),
                cgnatFg: NSColor(hex: "#cb4b16"),
                loopbackBg: NSColor(calibratedRed: 220/255, green: 245/255, blue: 245/255, alpha: 1.0),
                loopbackFg: NSColor(hex: "#2aa198"),
                reservedBg: NSColor(calibratedRed: 240/255, green: 235/255, blue: 250/255, alpha: 1.0),
                reservedFg: NSColor(hex: "#6c71c4")
            )

        case .tomorrowNightBlue:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#001b3d"),
                cardBackground: NSColor(hex: "#002451"),
                cardBorder: NSColor(hex: "#00346e"),
                tableBackground: NSColor(hex: "#002451"),
                tableRowAlt: NSColor(hex: "#001f44"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#003f8e"),
                tableTextPrimary: NSColor(hex: "#ffffff"),
                tableTextSecondary: NSColor(hex: "#7285b7"),
                accentCyan: NSColor(hex: "#99ffff"),
                accentBlue: NSColor(hex: "#bbdaff"),
                networkBitColor: NSColor(hex: "#99ffff"),
                subnetBitColor: NSColor(hex: "#ebbbff"),
                hostBitColor: NSColor(hex: "#d1f1a9"),
                separatorBitColor: NSColor(hex: "#7285b7"),
                rfc1918Bg: NSColor(calibratedRed: 25/255, green: 55/255, blue: 35/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#d1f1a9"),
                publicBg: NSColor(calibratedRed: 20/255, green: 40/255, blue: 75/255, alpha: 0.90),
                publicFg: NSColor(hex: "#bbdaff"),
                cgnatBg: NSColor(calibratedRed: 70/255, green: 45/255, blue: 20/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#ffc58f"),
                loopbackBg: NSColor(calibratedRed: 20/255, green: 50/255, blue: 60/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#99ffff"),
                reservedBg: NSColor(calibratedRed: 50/255, green: 30/255, blue: 70/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#ebbbff")
            )

        case .tomorrowNight:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#151718"),
                cardBackground: NSColor(hex: "#1d1f21"),
                cardBorder: NSColor(hex: "#282a2e"),
                tableBackground: NSColor(hex: "#1d1f21"),
                tableRowAlt: NSColor(hex: "#242629"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#373b41"),
                tableTextPrimary: NSColor(hex: "#c5c8c6"),
                tableTextSecondary: NSColor(hex: "#969896"),
                accentCyan: NSColor(hex: "#8abeb7"),
                accentBlue: NSColor(hex: "#81a2be"),
                networkBitColor: NSColor(hex: "#8abeb7"),
                subnetBitColor: NSColor(hex: "#b294bb"),
                hostBitColor: NSColor(hex: "#b5bd68"),
                separatorBitColor: NSColor(hex: "#969896"),
                rfc1918Bg: NSColor(calibratedRed: 30/255, green: 50/255, blue: 25/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#b5bd68"),
                publicBg: NSColor(calibratedRed: 25/255, green: 40/255, blue: 60/255, alpha: 0.90),
                publicFg: NSColor(hex: "#81a2be"),
                cgnatBg: NSColor(calibratedRed: 65/255, green: 45/255, blue: 20/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#de935f"),
                loopbackBg: NSColor(calibratedRed: 20/255, green: 50/255, blue: 50/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#8abeb7"),
                reservedBg: NSColor(calibratedRed: 45/255, green: 30/255, blue: 55/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#b294bb")
            )

        case .tomorrowNightEighties:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#232323"),
                cardBackground: NSColor(hex: "#2d2d2d"),
                cardBorder: NSColor(hex: "#393939"),
                tableBackground: NSColor(hex: "#2d2d2d"),
                tableRowAlt: NSColor(hex: "#333333"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#515151"),
                tableTextPrimary: NSColor(hex: "#cccccc"),
                tableTextSecondary: NSColor(hex: "#999999"),
                accentCyan: NSColor(hex: "#66cccc"),
                accentBlue: NSColor(hex: "#6699cc"),
                networkBitColor: NSColor(hex: "#66cccc"),
                subnetBitColor: NSColor(hex: "#cc99cc"),
                hostBitColor: NSColor(hex: "#99cc99"),
                separatorBitColor: NSColor(hex: "#999999"),
                rfc1918Bg: NSColor(calibratedRed: 30/255, green: 50/255, blue: 30/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#99cc99"),
                publicBg: NSColor(calibratedRed: 25/255, green: 40/255, blue: 60/255, alpha: 0.90),
                publicFg: NSColor(hex: "#6699cc"),
                cgnatBg: NSColor(calibratedRed: 65/255, green: 45/255, blue: 25/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#f99157"),
                loopbackBg: NSColor(calibratedRed: 25/255, green: 50/255, blue: 50/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#66cccc"),
                reservedBg: NSColor(calibratedRed: 50/255, green: 30/255, blue: 50/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#cc99cc")
            )

        case .tomorrowNightBright:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: true,
                windowBackground: NSColor(hex: "#000000"),
                cardBackground: NSColor(hex: "#101010"),
                cardBorder: NSColor(hex: "#2a2a2a"),
                tableBackground: NSColor(hex: "#101010"),
                tableRowAlt: NSColor(hex: "#1a1a1a"),
                tableGridColor: NSColor(calibratedWhite: 1.0, alpha: 0.05),
                tableHeaderColor: NSColor(hex: "#424242"),
                tableTextPrimary: NSColor(hex: "#eaeaea"),
                tableTextSecondary: NSColor(hex: "#969896"),
                accentCyan: NSColor(hex: "#70c0b1"),
                accentBlue: NSColor(hex: "#7aa6da"),
                networkBitColor: NSColor(hex: "#70c0b1"),
                subnetBitColor: NSColor(hex: "#c397d8"),
                hostBitColor: NSColor(hex: "#b9ca4a"),
                separatorBitColor: NSColor(hex: "#969896"),
                rfc1918Bg: NSColor(calibratedRed: 25/255, green: 45/255, blue: 20/255, alpha: 0.90),
                rfc1918Fg: NSColor(hex: "#b9ca4a"),
                publicBg: NSColor(calibratedRed: 20/255, green: 35/255, blue: 60/255, alpha: 0.90),
                publicFg: NSColor(hex: "#7aa6da"),
                cgnatBg: NSColor(calibratedRed: 60/255, green: 40/255, blue: 20/255, alpha: 0.90),
                cgnatFg: NSColor(hex: "#e78c45"),
                loopbackBg: NSColor(calibratedRed: 20/255, green: 45/255, blue: 45/255, alpha: 0.90),
                loopbackFg: NSColor(hex: "#70c0b1"),
                reservedBg: NSColor(calibratedRed: 45/255, green: 25/255, blue: 55/255, alpha: 0.90),
                reservedFg: NSColor(hex: "#c397d8")
            )

        case .tomorrowDay:
            return ThemePalette(
                id: id,
                displayName: id.rawValue,
                isDark: false,
                windowBackground: NSColor(hex: "#f5f5f5"),
                cardBackground: NSColor(hex: "#ffffff"),
                cardBorder: NSColor(hex: "#d6d6d6"),
                tableBackground: NSColor(hex: "#ffffff"),
                tableRowAlt: NSColor(hex: "#f0f0f0"),
                tableGridColor: NSColor(calibratedWhite: 0.0, alpha: 0.06),
                tableHeaderColor: NSColor(hex: "#efefef"),
                tableTextPrimary: NSColor(hex: "#4d4d4c"),
                tableTextSecondary: NSColor(hex: "#8e908c"),
                accentCyan: NSColor(hex: "#3e999f"),
                accentBlue: NSColor(hex: "#4271ae"),
                networkBitColor: NSColor(hex: "#3e999f"),
                subnetBitColor: NSColor(hex: "#8959a8"),
                hostBitColor: NSColor(hex: "#718c00"),
                separatorBitColor: NSColor(hex: "#8e908c"),
                rfc1918Bg: NSColor(calibratedRed: 230/255, green: 245/255, blue: 220/255, alpha: 1.0),
                rfc1918Fg: NSColor(hex: "#718c00"),
                publicBg: NSColor(calibratedRed: 225/255, green: 235/255, blue: 250/255, alpha: 1.0),
                publicFg: NSColor(hex: "#4271ae"),
                cgnatBg: NSColor(calibratedRed: 255/255, green: 235/255, blue: 220/255, alpha: 1.0),
                cgnatFg: NSColor(hex: "#eab700"),
                loopbackBg: NSColor(calibratedRed: 220/255, green: 245/255, blue: 245/255, alpha: 1.0),
                loopbackFg: NSColor(hex: "#3e999f"),
                reservedBg: NSColor(calibratedRed: 245/255, green: 230/255, blue: 245/255, alpha: 1.0),
                reservedFg: NSColor(hex: "#8959a8")
            )
        }
    }
}

// MARK: - Theme Manager
public struct ThemeManager {
    public static let themeDidChangeNotification = Notification.Name("SubnetCalcThemeDidChangeNotification")
    private static let userDefaultsThemeKey = "SelectedSubnetCalcTheme"

    // Dynamic Active Theme State
    public static var currentThemeID: AppThemeID = {
        if let savedName = UserDefaults.standard.string(forKey: userDefaultsThemeKey),
           let theme = AppThemeID(rawValue: savedName) {
            return theme
        }
        return .catppuccinMocha
    }()

    public static var current: ThemePalette = SwiftThemes.palette(for: currentThemeID)

    public static func setTheme(_ themeID: AppThemeID) {
        currentThemeID = themeID
        current = SwiftThemes.palette(for: themeID)
        UserDefaults.standard.set(themeID.rawValue, forKey: userDefaultsThemeKey)
        NotificationCenter.default.post(name: themeDidChangeNotification, object: currentThemeID)
    }

    // MARK: - Backward-Compatible Forwarding Properties
    public static var midnightBackground: NSColor { current.windowBackground }
    public static var cardBackground: NSColor { current.cardBackground }
    public static var cardBorder: NSColor { current.cardBorder }

    public static var accentCyan: NSColor { current.accentCyan }
    public static var accentBlue: NSColor { current.accentBlue }

    public static var networkBitColor: NSColor { current.networkBitColor }
    public static var subnetBitColor: NSColor { current.subnetBitColor }
    public static var hostBitColor: NSColor { current.hostBitColor }
    public static var separatorBitColor: NSColor { current.separatorBitColor }

    public static var rfc1918GreenBg: NSColor { current.rfc1918Bg }
    public static var rfc1918GreenFg: NSColor { current.rfc1918Fg }
    public static var publicBlueBg: NSColor { current.publicBg }
    public static var publicBlueFg: NSColor { current.publicFg }
    public static var cgnatAmberBg: NSColor { current.cgnatBg }
    public static var cgnatAmberFg: NSColor { current.cgnatFg }
    public static var loopbackCyanBg: NSColor { current.loopbackBg }
    public static var loopbackCyanFg: NSColor { current.loopbackFg }
    public static var reservedPurpleBg: NSColor { current.reservedBg }
    public static var reservedPurpleFg: NSColor { current.reservedFg }

    public static var tableBackground: NSColor { current.tableBackground }
    public static var tableRowAlt: NSColor { current.tableRowAlt }
    public static var tableGridColor: NSColor { current.tableGridColor }
    public static var tableHeaderColor: NSColor { current.tableHeaderColor }
    public static var tableTextPrimary: NSColor { current.tableTextPrimary }
    public static var tableTextSecondary: NSColor { current.tableTextSecondary }

    // MARK: - AppKit Styling Helpers
    public static func styleWindow(_ window: NSWindow) {
        if #available(OSX 10.14, *) {
            window.appearance = NSAppearance(named: current.isDark ? .darkAqua : .aqua)
        }
        window.backgroundColor = current.windowBackground
    }

    public static func styleCard(_ box: NSBox) {
        if box.titlePosition == .noTitle {
            box.boxType = .custom
            box.isTransparent = false
            box.fillColor = current.cardBackground
            box.borderColor = current.cardBorder
            box.borderWidth = 1.0
            box.cornerRadius = 8.0
        }
    }

    public static func styleTableView(_ tableView: NSTableView) {
        if #available(OSX 10.14, *) {
            tableView.appearance = NSAppearance(named: current.isDark ? .darkAqua : .aqua)
        }
        tableView.backgroundColor = current.tableBackground
        tableView.gridColor = current.tableGridColor
        tableView.intercellSpacing = NSSize(width: 4, height: 4)

        for column in tableView.tableColumns {
            if let cell = column.dataCell as? NSTextFieldCell {
                cell.textColor = current.tableTextPrimary
                cell.backgroundColor = current.tableBackground
                cell.drawsBackground = false
                cell.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
            }
            let headerCell = column.headerCell
            headerCell.textColor = current.isDark ? NSColor.white : NSColor.black
            headerCell.font = NSFont.systemFont(ofSize: 11, weight: .semibold)
        }

        if let scrollView = tableView.enclosingScrollView {
            scrollView.drawsBackground = true
            scrollView.backgroundColor = current.tableBackground
            scrollView.contentView.drawsBackground = true
            scrollView.contentView.backgroundColor = current.tableBackground
            scrollView.borderType = .bezelBorder
            scrollView.wantsLayer = true
            scrollView.layer?.cornerRadius = 6.0
            scrollView.layer?.masksToBounds = true
        }
    }

    public static func stylePillBadge(_ label: NSTextField, bg: NSColor, fg: NSColor) {
        label.isBezeled = false
        label.isEditable = false
        label.drawsBackground = true
        label.backgroundColor = bg
        label.textColor = fg
        label.wantsLayer = true
        label.layer?.cornerRadius = 5.0
        label.layer?.masksToBounds = true
        label.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .semibold)
        label.alignment = .center
    }

    public static func formatColorCodedBitMap(_ bitPattern: String) -> NSAttributedString {
        let baseFont = NSFont.monospacedSystemFont(ofSize: 13, weight: .bold)
        let defaultTextColor = current.isDark ? NSColor.white : NSColor.black
        let result = NSMutableAttributedString(string: bitPattern, attributes: [
            .font: baseFont,
            .foregroundColor: defaultTextColor
        ])
        var currentIndex = 0
        for char in bitPattern {
            let color: NSColor
            switch char {
            case "n": color = current.networkBitColor
            case "s": color = current.subnetBitColor
            case "h": color = current.hostBitColor
            case ".": color = current.separatorBitColor
            default:  color = defaultTextColor
            }
            result.addAttribute(.foregroundColor, value: color, range: NSRange(location: currentIndex, length: 1))
            currentIndex += 1
        }
        return result
    }

    public static func updateBadge(for label: NSTextField, classification: String) {
        let bg: NSColor
        let fg: NSColor
        let shortText: String

        if classification.contains("RFC 1918") || classification.contains("ULA") || classification.contains("Unique Local") {
            bg = current.rfc1918Bg
            fg = current.rfc1918Fg
            shortText = (classification.contains("ULA") || classification.contains("Unique Local")) ? "ULA" : "Private"
        } else if classification.contains("Public") || classification.contains("Global Unicast") {
            bg = current.publicBg
            fg = current.publicFg
            shortText = "Public"
        } else if classification.contains("CGNAT") {
            bg = current.cgnatBg
            fg = current.cgnatFg
            shortText = "CGNAT"
        } else if classification.contains("Loopback") {
            bg = current.loopbackBg
            fg = current.loopbackFg
            shortText = "Loopback"
        } else if classification.contains("Link-Local") {
            bg = current.loopbackBg
            fg = current.loopbackFg
            shortText = "Link-Local"
        } else if classification.contains("Multicast") {
            bg = current.reservedBg
            fg = current.reservedFg
            shortText = "Multicast"
        } else if classification.contains("This Host") {
            bg = current.reservedBg
            fg = current.reservedFg
            shortText = "This Host"
        } else {
            bg = current.reservedBg
            fg = current.reservedFg
            shortText = "Reserved"
        }

        label.stringValue = " \(shortText) "
        label.toolTip = classification
        stylePillBadge(label, bg: bg, fg: fg)
    }
}
