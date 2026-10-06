//
//  ThemeManager.swift
//  SubnetCalc for macOS
//
//  Version: v2.6.2 (Universal 2: Apple Silicon ARM64 & Intel Core x86_64)
//  Date & Time: 2026-10-07 05:25:30 +07:00
//
//  Original Creator & Lead Developer:
//    Julien Mulot
//    Website: https://subnetcalc.mulot.org
//    GitHub:  https://github.com/mulot
//
//  Maintainer, Modernization & Security Engineering:
//    Harry Dertin Sutisna Alsyundawy (@alsyundawy)
//    Company: ALSYUNDAWY IT SOLUTION
//    Website: https://alsyundawy.com
//    Email:   alsyundawy@gmail.com
//    GitHub:  https://github.com/alsyundawy
//
//  Theme Palettes Credit:
//    Taylor Lindsey (ActuallyTaylor/Swift-Themes)
//
//  License: GNU General Public License v2.0 (GPL-2.0)
//

import Cocoa

#if canImport(AppKit)
public typealias BridgeColor = NSColor
#endif

// MARK: - Hex Color Extension
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

// MARK: - App Theme Identifier Enum (25 Iconic Developer Families)
public enum AppThemeID: String, CaseIterable {
    // 1. Catppuccin Family
    case catppuccinMocha = "Catppuccin Mocha"
    case catppuccinMacchiato = "Catppuccin Macchiato"
    case catppuccinFrappe = "Catppuccin Frappé"
    case catppuccinLatte = "Catppuccin Latte"

    // 2. Dracula Family
    case dracula = "Dracula"
    case draculaSoft = "Dracula Soft"
    case draculaAlucard = "Dracula Alucard"
    case draculaLight = "Dracula Light"

    // 3. Tokyo Night Family
    case tokyoNight = "Tokyo Night"
    case tokyoNightStorm = "Tokyo Night Storm"
    case tokyoNightLight = "Tokyo Night Light"

    // 4. Nord Family
    case nordDark = "Nord Dark"
    case nordPolar = "Nord Polar"
    case nordLight = "Nord Light"

    // 5. One Dark Family
    case oneDarkPro = "One Dark Pro"
    case oneDarkVivid = "One Dark Vivid"
    case oneLight = "One Light"

    // 6. Gruvbox Family
    case gruvboxDark = "Gruvbox Dark"
    case gruvboxDarkMedium = "Gruvbox Dark Medium"
    case gruvboxLight = "Gruvbox Light"

    // 7. Solarized Family
    case solarizedDark = "Solarized Dark"
    case solarizedLight = "Solarized Light"

    // 8. GitHub Family
    case gitHubDark = "GitHub Dark"
    case gitHubDarkDimmed = "GitHub Dark Dimmed"
    case gitHubLight = "GitHub Light"
    case gitHubLightHighContrast = "GitHub Light High Contrast"

    // 9. Monokai Family
    case monokaiClassic = "Monokai Classic"
    case monokaiPro = "Monokai Pro"
    case monokaiCharcoal = "Monokai Charcoal"
    case monokaiLight = "Monokai Light"

    // 10. Rosé Pine Family
    case rosePineMain = "Rosé Pine Main"
    case rosePineMoon = "Rosé Pine Moon"
    case rosePineDawn = "Rosé Pine Dawn"

    // 11. Ayu Family
    case ayuDark = "Ayu Dark"
    case ayuMirage = "Ayu Mirage"
    case ayuLight = "Ayu Light"

    // 12. Kanagawa Family
    case kanagawaWave = "Kanagawa Wave"
    case kanagawaDragon = "Kanagawa Dragon"
    case kanagawaLotus = "Kanagawa Lotus"

    // 13. Everforest Family
    case everforestDarkHard = "Everforest Dark Hard"
    case everforestDarkMedium = "Everforest Dark Medium"
    case everforestLight = "Everforest Light"

    // 14. Night Owl Family
    case nightOwlDark = "Night Owl Dark"
    case lightOwl = "Light Owl"

    // 15. Material Family
    case materialPalenight = "Material Palenight"
    case materialDeepOcean = "Material Deep Ocean"
    case materialLighter = "Material Lighter"

    // 16. SynthWave '84 Family
    case synthWave84Glow = "SynthWave '84 Glow"
    case synthWave84Classic = "SynthWave '84 Classic"

    // 17. Cyberpunk Family
    case cyberpunk2077 = "Cyberpunk 2077"
    case cyberpunkScarlet = "Cyberpunk Scarlet"

    // 18. Shades of Purple Family
    case shadesOfPurpleSuperDark = "Shades of Purple Super Dark"
    case shadesOfPurpleClassic = "Shades of Purple Classic"
    case shadesOfPurpleLight = "Shades of Purple Light"

    // 19. Poimandres Family
    case poimandresDark = "Poimandres Dark"
    case poimandresStorm = "Poimandres Storm"
    case poimandresLight = "Poimandres Light"

    // 20. Horizon Family
    case horizonDark = "Horizon Dark"
    case horizonBright = "Horizon Bright"

    // 21. Andromeda Family
    case andromedaDark = "Andromeda Dark"
    case andromedaBordered = "Andromeda Bordered"
    case andromedaLight = "Andromeda Light"

    // 22. Nightfox Family
    case nightfoxDark = "Nightfox Dark"
    case duskfox = "Duskfox"
    case dawnfox = "Dawnfox"

    // 23. Cobalt2 Family
    case cobalt2Classic = "Cobalt2 Classic"
    case cobalt2Bright = "Cobalt2 Bright"
    case cobalt2Light = "Cobalt2 Light"

    // 24. Alabaster Family
    case alabasterDark = "Alabaster Dark"
    case alabasterLight = "Alabaster Light"

    // 25. Tomorrow Family
    case tomorrowNight = "Tomorrow Night"
    case tomorrowNightBlue = "Tomorrow Night Blue"
    case tomorrowNightEighties = "Tomorrow Night Eighties"
    case tomorrowNightBright = "Tomorrow Night Bright"
    case tomorrowDay = "Tomorrow Day"

    public var groupName: String {
        switch self {
        case .catppuccinMocha, .catppuccinMacchiato, .catppuccinFrappe, .catppuccinLatte:
            return "Catppuccin"
        case .dracula, .draculaSoft, .draculaAlucard, .draculaLight:
            return "Dracula"
        case .tokyoNight, .tokyoNightStorm, .tokyoNightLight:
            return "Tokyo Night"
        case .nordDark, .nordPolar, .nordLight:
            return "Nord"
        case .oneDarkPro, .oneDarkVivid, .oneLight:
            return "One Dark"
        case .gruvboxDark, .gruvboxDarkMedium, .gruvboxLight:
            return "Gruvbox"
        case .solarizedDark, .solarizedLight:
            return "Solarized"
        case .gitHubDark, .gitHubDarkDimmed, .gitHubLight, .gitHubLightHighContrast:
            return "GitHub"
        case .monokaiClassic, .monokaiPro, .monokaiCharcoal, .monokaiLight:
            return "Monokai"
        case .rosePineMain, .rosePineMoon, .rosePineDawn:
            return "Rosé Pine"
        case .ayuDark, .ayuMirage, .ayuLight:
            return "Ayu"
        case .kanagawaWave, .kanagawaDragon, .kanagawaLotus:
            return "Kanagawa"
        case .everforestDarkHard, .everforestDarkMedium, .everforestLight:
            return "Everforest"
        case .nightOwlDark, .lightOwl:
            return "Night Owl"
        case .materialPalenight, .materialDeepOcean, .materialLighter:
            return "Material"
        case .synthWave84Glow, .synthWave84Classic:
            return "SynthWave '84"
        case .cyberpunk2077, .cyberpunkScarlet:
            return "Cyberpunk"
        case .shadesOfPurpleSuperDark, .shadesOfPurpleClassic, .shadesOfPurpleLight:
            return "Shades of Purple"
        case .poimandresDark, .poimandresStorm, .poimandresLight:
            return "Poimandres"
        case .horizonDark, .horizonBright:
            return "Horizon"
        case .andromedaDark, .andromedaBordered, .andromedaLight:
            return "Andromeda"
        case .nightfoxDark, .duskfox, .dawnfox:
            return "Nightfox"
        case .cobalt2Classic, .cobalt2Bright, .cobalt2Light:
            return "Cobalt2"
        case .alabasterDark, .alabasterLight:
            return "Alabaster"
        case .tomorrowNight, .tomorrowNightBlue, .tomorrowNightEighties, .tomorrowNightBright, .tomorrowDay:
            return "Tomorrow"
        }
    }

    public var subthemeName: String {
        switch self {
        case .catppuccinMocha: return "Mocha (Default Dark)"
        case .catppuccinMacchiato: return "Macchiato"
        case .catppuccinFrappe: return "Frappé"
        case .catppuccinLatte: return "Latte (Light)"

        case .dracula: return "Dracula Official"
        case .draculaSoft: return "Dracula Soft"
        case .draculaAlucard: return "Dracula Alucard"
        case .draculaLight: return "Dracula Light"

        case .tokyoNight: return "Tokyo Night (Dark)"
        case .tokyoNightStorm: return "Tokyo Night Storm"
        case .tokyoNightLight: return "Tokyo Night Light"

        case .nordDark: return "Nord Dark"
        case .nordPolar: return "Nord Polar"
        case .nordLight: return "Nord Light"

        case .oneDarkPro: return "One Dark Pro"
        case .oneDarkVivid: return "One Dark Vivid"
        case .oneLight: return "One Light"

        case .gruvboxDark: return "Gruvbox Dark Hard"
        case .gruvboxDarkMedium: return "Gruvbox Dark Medium"
        case .gruvboxLight: return "Gruvbox Light"

        case .solarizedDark: return "Solarized Dark"
        case .solarizedLight: return "Solarized Light"

        case .gitHubDark: return "GitHub Dark"
        case .gitHubDarkDimmed: return "GitHub Dark Dimmed"
        case .gitHubLight: return "GitHub Light"
        case .gitHubLightHighContrast: return "GitHub Light High Contrast (WCAG AAA)"

        case .monokaiClassic: return "Monokai Classic"
        case .monokaiPro: return "Monokai Pro"
        case .monokaiCharcoal: return "Monokai Charcoal"
        case .monokaiLight: return "Monokai Light"

        case .rosePineMain: return "Rosé Pine Main"
        case .rosePineMoon: return "Rosé Pine Moon"
        case .rosePineDawn: return "Rosé Pine Dawn (Light)"

        case .ayuDark: return "Ayu Dark"
        case .ayuMirage: return "Ayu Mirage"
        case .ayuLight: return "Ayu Light"

        case .kanagawaWave: return "Kanagawa Wave"
        case .kanagawaDragon: return "Kanagawa Dragon"
        case .kanagawaLotus: return "Kanagawa Lotus (Light)"

        case .everforestDarkHard: return "Everforest Dark Hard"
        case .everforestDarkMedium: return "Everforest Dark Medium"
        case .everforestLight: return "Everforest Light"

        case .nightOwlDark: return "Night Owl Dark"
        case .lightOwl: return "Light Owl"

        case .materialPalenight: return "Material Palenight"
        case .materialDeepOcean: return "Material Deep Ocean"
        case .materialLighter: return "Material Lighter"

        case .synthWave84Glow: return "SynthWave '84 Glow"
        case .synthWave84Classic: return "SynthWave '84 Classic"

        case .cyberpunk2077: return "Cyberpunk 2077"
        case .cyberpunkScarlet: return "Cyberpunk Scarlet"

        case .shadesOfPurpleSuperDark: return "Shades of Purple Super Dark"
        case .shadesOfPurpleClassic: return "Shades of Purple Classic"
        case .shadesOfPurpleLight: return "Shades of Purple Light"

        case .poimandresDark: return "Poimandres Dark"
        case .poimandresStorm: return "Poimandres Storm"
        case .poimandresLight: return "Poimandres Light (White)"

        case .horizonDark: return "Horizon Dark"
        case .horizonBright: return "Horizon Bright (Light)"

        case .andromedaDark: return "Andromeda Dark"
        case .andromedaBordered: return "Andromeda Bordered"
        case .andromedaLight: return "Andromeda Light"

        case .nightfoxDark: return "Nightfox Dark"
        case .duskfox: return "Duskfox"
        case .dawnfox: return "Dawnfox (Light)"

        case .cobalt2Classic: return "Cobalt2 Classic"
        case .cobalt2Bright: return "Cobalt2 Bright"
        case .cobalt2Light: return "Cobalt2 Light (Blueprint)"

        case .alabasterDark: return "Alabaster Dark"
        case .alabasterLight: return "Alabaster Light"

        case .tomorrowNight: return "Tomorrow Night"
        case .tomorrowNightBlue: return "Tomorrow Night Blue"
        case .tomorrowNightEighties: return "Tomorrow Night Eighties"
        case .tomorrowNightBright: return "Tomorrow Night Bright"
        case .tomorrowDay: return "Tomorrow Day (Light)"
        }
    }

    public static let all25ThemeGroups: [String] = [
        "Catppuccin", "Dracula", "Tokyo Night", "Nord", "One Dark",
        "Gruvbox", "Solarized", "GitHub", "Monokai", "Rosé Pine",
        "Ayu", "Kanagawa", "Everforest", "Night Owl", "Material",
        "SynthWave '84", "Cyberpunk", "Shades of Purple", "Poimandres", "Horizon",
        "Andromeda", "Nightfox", "Cobalt2", "Alabaster", "Tomorrow"
    ]
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

// MARK: - Theme Factory & Color Definitions
public struct SwiftThemes {
    // swiftlint:disable:next function_parameter_count
    private static func create(
        id: AppThemeID,
        isDark: Bool,
        win: String,
        card: String,
        border: String,
        tbl: String,
        tblAlt: String,
        hdr: String,
        txtPri: String,
        txtSec: String,
        cyan: String,
        blue: String,
        net: String,
        sub: String,
        host: String,
        sep: String,
        rfcFg: String? = nil,
        pubFg: String? = nil,
        cgnFg: String? = nil,
        lopFg: String? = nil,
        resFg: String? = nil
    ) -> ThemePalette {
        let actualRfcFg = NSColor(hex: rfcFg ?? host)
        let actualPubFg = NSColor(hex: pubFg ?? blue)
        let actualCgnFg = NSColor(hex: cgnFg ?? "#fe8019")
        let actualLopFg = NSColor(hex: lopFg ?? cyan)
        let actualResFg = NSColor(hex: resFg ?? sub)

        let gridColor = isDark ? NSColor(calibratedWhite: 1.0, alpha: 0.05) : NSColor(calibratedWhite: 0.0, alpha: 0.06)

        let rfcBg = isDark
            ? NSColor(calibratedRed: 26/255, green: 56/255, blue: 45/255, alpha: 0.90)
            : NSColor(calibratedRed: 220/255, green: 247/255, blue: 225/255, alpha: 1.0)
        let pubBg = isDark
            ? NSColor(calibratedRed: 28/255, green: 45/255, blue: 82/255, alpha: 0.90)
            : NSColor(calibratedRed: 225/255, green: 235/255, blue: 255/255, alpha: 1.0)
        let cgnBg = isDark
            ? NSColor(calibratedRed: 74/255, green: 44/255, blue: 23/255, alpha: 0.90)
            : NSColor(calibratedRed: 255/255, green: 240/255, blue: 220/255, alpha: 1.0)
        let lopBg = isDark
            ? NSColor(calibratedRed: 22/255, green: 58/255, blue: 64/255, alpha: 0.90)
            : NSColor(calibratedRed: 220/255, green: 245/255, blue: 245/255, alpha: 1.0)
        let resBg = isDark
            ? NSColor(calibratedRed: 53/255, green: 32/255, blue: 74/255, alpha: 0.90)
            : NSColor(calibratedRed: 240/255, green: 230/255, blue: 255/255, alpha: 1.0)

        return ThemePalette(
            id: id,
            displayName: id.rawValue,
            isDark: isDark,
            windowBackground: NSColor(hex: win),
            cardBackground: NSColor(hex: card),
            cardBorder: NSColor(hex: border),
            tableBackground: NSColor(hex: tbl),
            tableRowAlt: NSColor(hex: tblAlt),
            tableGridColor: gridColor,
            tableHeaderColor: NSColor(hex: hdr),
            tableTextPrimary: NSColor(hex: txtPri),
            tableTextSecondary: NSColor(hex: txtSec),
            accentCyan: NSColor(hex: cyan),
            accentBlue: NSColor(hex: blue),
            networkBitColor: NSColor(hex: net),
            subnetBitColor: NSColor(hex: sub),
            hostBitColor: NSColor(hex: host),
            separatorBitColor: NSColor(hex: sep),
            rfc1918Bg: rfcBg,
            rfc1918Fg: actualRfcFg,
            publicBg: pubBg,
            publicFg: actualPubFg,
            cgnatBg: cgnBg,
            cgnatFg: actualCgnFg,
            loopbackBg: lopBg,
            loopbackFg: actualLopFg,
            reservedBg: resBg,
            reservedFg: actualResFg
        )
    }

    public static func palette(for id: AppThemeID) -> ThemePalette {
        switch id {
        // MARK: 1. Catppuccin
        case .catppuccinMocha:
            return create(
                id: id, isDark: true,
                win: "#11111b", card: "#1e1e2e", border: "#313244",
                tbl: "#1e1e2e", tblAlt: "#181825", hdr: "#45475a",
                txtPri: "#cdd6f4", txtSec: "#a6adc8",
                cyan: "#74c7ec", blue: "#89b4fa",
                net: "#74c7ec", sub: "#cba6f7", host: "#a6e3a1", sep: "#6c7086",
                cgnFg: "#fab387", lopFg: "#94e2d5"
            )
        case .catppuccinMacchiato:
            return create(
                id: id, isDark: true,
                win: "#181926", card: "#24273a", border: "#363a4f",
                tbl: "#24273a", tblAlt: "#1e2030", hdr: "#494d64",
                txtPri: "#cad3f5", txtSec: "#a5adcb",
                cyan: "#7dc4e4", blue: "#8aadf4",
                net: "#7dc4e4", sub: "#c6a0f6", host: "#a6da95", sep: "#6e738d",
                cgnFg: "#f5a97f", lopFg: "#8bd5ca"
            )
        case .catppuccinFrappe:
            return create(
                id: id, isDark: true,
                win: "#232634", card: "#303446", border: "#414559",
                tbl: "#303446", tblAlt: "#292c3c", hdr: "#51576d",
                txtPri: "#c6d0f5", txtSec: "#a5adce",
                cyan: "#85c1dc", blue: "#8caaee",
                net: "#85c1dc", sub: "#ca9ee6", host: "#a6d189", sep: "#737994",
                cgnFg: "#ef9f76", lopFg: "#81c8be"
            )
        case .catppuccinLatte:
            return create(
                id: id, isDark: false,
                win: "#dce0e8", card: "#eff1f5", border: "#ccd0da",
                tbl: "#eff1f5", tblAlt: "#e6e9ef", hdr: "#bcc0cc",
                txtPri: "#4c4f69", txtSec: "#6c6f85",
                cyan: "#1e66f5", blue: "#1e66f5",
                net: "#209fb5", sub: "#8839ef", host: "#40a02b", sep: "#9ca0b0",
                cgnFg: "#fe640b", lopFg: "#179299"
            )

        // MARK: 2. Dracula
        case .dracula:
            return create(
                id: id, isDark: true,
                win: "#1e1f29", card: "#282a36", border: "#44475a",
                tbl: "#282a36", tblAlt: "#21222c", hdr: "#44475a",
                txtPri: "#f8f8f2", txtSec: "#6272a4",
                cyan: "#8be9fd", blue: "#bd93f9",
                net: "#8be9fd", sub: "#bd93f9", host: "#50fa7b", sep: "#6272a4",
                cgnFg: "#ffb86c", resFg: "#ff79c6"
            )
        case .draculaSoft:
            return create(
                id: id, isDark: true,
                win: "#21222d", card: "#282a36", border: "#4d5166",
                tbl: "#282a36", tblAlt: "#22232e", hdr: "#4d5166",
                txtPri: "#f8f8f2", txtSec: "#7887b4",
                cyan: "#94ebfc", blue: "#c39dfc",
                net: "#94ebfc", sub: "#c39dfc", host: "#64fc8b", sep: "#7887b4",
                cgnFg: "#ffc27d", resFg: "#ff8cd1"
            )
        case .draculaAlucard:
            return create(
                id: id, isDark: true,
                win: "#15161e", card: "#1d1e28", border: "#373a4c",
                tbl: "#1d1e28", tblAlt: "#171821", hdr: "#373a4c",
                txtPri: "#eaeaf0", txtSec: "#5a668e",
                cyan: "#7ee5fa", blue: "#b084f4",
                net: "#7ee5fa", sub: "#b084f4", host: "#42f06f", sep: "#5a668e",
                cgnFg: "#f5a75b", resFg: "#f068b5"
            )
        case .draculaLight:
            return create(
                id: id, isDark: false,
                win: "#f8f8f2", card: "#ffffff", border: "#e2e8f0",
                tbl: "#ffffff", tblAlt: "#f4f4f7", hdr: "#e2e8f0",
                txtPri: "#282a36", txtSec: "#6272a4",
                cyan: "#0097a7", blue: "#7c4dff",
                net: "#0097a7", sub: "#7c4dff", host: "#2e7d32", sep: "#6272a4",
                cgnFg: "#e65100", resFg: "#c2185b"
            )

        // MARK: 3. Tokyo Night
        case .tokyoNight:
            return create(
                id: id, isDark: true,
                win: "#16161e", card: "#1a1b26", border: "#2f334d",
                tbl: "#1a1b26", tblAlt: "#16161e", hdr: "#414868",
                txtPri: "#c0caf5", txtSec: "#9aa5ce",
                cyan: "#7dcfff", blue: "#7aa2f7",
                net: "#2ac3de", sub: "#bb9af7", host: "#9ece6a", sep: "#565f89",
                cgnFg: "#ff9e64", resFg: "#bb9af7"
            )
        case .tokyoNightStorm:
            return create(
                id: id, isDark: true,
                win: "#1f2335", card: "#24283b", border: "#3b4261",
                tbl: "#24283b", tblAlt: "#1f2335", hdr: "#414868",
                txtPri: "#c0caf5", txtSec: "#9aa5ce",
                cyan: "#7dcfff", blue: "#7aa2f7",
                net: "#2ac3de", sub: "#bb9af7", host: "#9ece6a", sep: "#565f89",
                cgnFg: "#ff9e64", resFg: "#bb9af7"
            )
        case .tokyoNightLight:
            return create(
                id: id, isDark: false,
                win: "#d5d6db", card: "#e1e2e7", border: "#cfc9c2",
                tbl: "#e1e2e7", tblAlt: "#d5d6db", hdr: "#c4c8d4",
                txtPri: "#343b58", txtSec: "#565a6e",
                cyan: "#0f4b6e", blue: "#2e7de9",
                net: "#007197", sub: "#9854f1", host: "#587539", sep: "#8990b3",
                cgnFg: "#b15c00", resFg: "#9854f1"
            )

        // MARK: 4. Nord
        case .nordDark:
            return create(
                id: id, isDark: true,
                win: "#242933", card: "#2e3440", border: "#3b4252",
                tbl: "#2e3440", tblAlt: "#242933", hdr: "#434c5e",
                txtPri: "#d8dee9", txtSec: "#88c0d0",
                cyan: "#88c0d0", blue: "#81a1c1",
                net: "#8fbcbb", sub: "#b48ead", host: "#a3be8c", sep: "#4c566a",
                cgnFg: "#ebcb8b", resFg: "#b48ead"
            )
        case .nordPolar:
            return create(
                id: id, isDark: true,
                win: "#1d212a", card: "#242933", border: "#3b4252",
                tbl: "#242933", tblAlt: "#1e222b", hdr: "#434c5e",
                txtPri: "#e5e9f0", txtSec: "#81a1c1",
                cyan: "#88c0d0", blue: "#5e81ac",
                net: "#88c0d0", sub: "#b48ead", host: "#a3be8c", sep: "#4c566a",
                cgnFg: "#d08770", resFg: "#bf616a"
            )
        case .nordLight:
            return create(
                id: id, isDark: false,
                win: "#e5e9f0", card: "#eceff4", border: "#d8dee9",
                tbl: "#eceff4", tblAlt: "#e5e9f0", hdr: "#d8dee9",
                txtPri: "#2e3440", txtSec: "#4c566a",
                cyan: "#5e81ac", blue: "#81a1c1",
                net: "#3b626e", sub: "#83587a", host: "#4c704c", sep: "#9da6b8",
                cgnFg: "#bf616a", resFg: "#83587a"
            )

        // MARK: 5. One Dark
        case .oneDarkPro:
            return create(
                id: id, isDark: true,
                win: "#21252b", card: "#282c34", border: "#3e4451",
                tbl: "#282c34", tblAlt: "#21252b", hdr: "#353b45",
                txtPri: "#abb2bf", txtSec: "#5c6370",
                cyan: "#56b6c2", blue: "#61afef",
                net: "#56b6c2", sub: "#c678dd", host: "#98c379", sep: "#4b5263",
                cgnFg: "#e5c07b", resFg: "#e06c75"
            )
        case .oneDarkVivid:
            return create(
                id: id, isDark: true,
                win: "#1e2227", card: "#282c34", border: "#4b5263",
                tbl: "#282c34", tblAlt: "#21252b", hdr: "#3e4451",
                txtPri: "#e5e5e5", txtSec: "#7f848e",
                cyan: "#4dc4d4", blue: "#528bff",
                net: "#4dc4d4", sub: "#d55fde", host: "#98c379", sep: "#5c6370",
                cgnFg: "#e5c07b", resFg: "#ef596f"
            )
        case .oneLight:
            return create(
                id: id, isDark: false,
                win: "#eaeaeb", card: "#fafafa", border: "#dbdbdc",
                tbl: "#fafafa", tblAlt: "#f0f0f1", hdr: "#e5e5e6",
                txtPri: "#383a42", txtSec: "#696c77",
                cyan: "#0184bc", blue: "#4078f2",
                net: "#0184bc", sub: "#a626a4", host: "#50a14f", sep: "#a0a1a7",
                cgnFg: "#c18401", resFg: "#e45649"
            )

        // MARK: 6. Gruvbox
        case .gruvboxDark:
            return create(
                id: id, isDark: true,
                win: "#1d2021", card: "#282828", border: "#3c3836",
                tbl: "#282828", tblAlt: "#32302f", hdr: "#504945",
                txtPri: "#ebdbb2", txtSec: "#a89984",
                cyan: "#83a598", blue: "#458588",
                net: "#8ec07c", sub: "#d3869b", host: "#b8bb26", sep: "#928374",
                cgnFg: "#fe8019", resFg: "#d3869b"
            )
        case .gruvboxDarkMedium:
            return create(
                id: id, isDark: true,
                win: "#282828", card: "#32302f", border: "#504945",
                tbl: "#32302f", tblAlt: "#282828", hdr: "#665c54",
                txtPri: "#ebdbb2", txtSec: "#bdae93",
                cyan: "#83a598", blue: "#458588",
                net: "#8ec07c", sub: "#d3869b", host: "#b8bb26", sep: "#928374",
                cgnFg: "#fe8019", resFg: "#fb4934"
            )
        case .gruvboxLight:
            return create(
                id: id, isDark: false,
                win: "#f2e5bc", card: "#fbf1c7", border: "#ebdbb2",
                tbl: "#fbf1c7", tblAlt: "#f4e8ba", hdr: "#d5c4a1",
                txtPri: "#3c3836", txtSec: "#7c6f64",
                cyan: "#076678", blue: "#458588",
                net: "#427b58", sub: "#8f3f71", host: "#79740e", sep: "#928374",
                cgnFg: "#af3a03", resFg: "#9d0006"
            )

        // MARK: 7. Solarized
        case .solarizedDark:
            return create(
                id: id, isDark: true,
                win: "#00212b", card: "#002b36", border: "#073642",
                tbl: "#002b36", tblAlt: "#073642", hdr: "#586e75",
                txtPri: "#839496", txtSec: "#586e75",
                cyan: "#268bd2", blue: "#268bd2",
                net: "#2aa198", sub: "#6c71c4", host: "#859900", sep: "#586e75",
                cgnFg: "#cb4b16", resFg: "#d33682"
            )
        case .solarizedLight:
            return create(
                id: id, isDark: false,
                win: "#eee8d5", card: "#fdf6e3", border: "#e0d8c3",
                tbl: "#fdf6e3", tblAlt: "#eee8d5", hdr: "#93a1a1",
                txtPri: "#657b83", txtSec: "#93a1a1",
                cyan: "#268bd2", blue: "#268bd2",
                net: "#2aa198", sub: "#6c71c4", host: "#859900", sep: "#93a1a1",
                cgnFg: "#cb4b16", resFg: "#d33682"
            )

        // MARK: 8. GitHub
        case .gitHubDark:
            return create(
                id: id, isDark: true,
                win: "#090d13", card: "#0d1117", border: "#30363d",
                tbl: "#0d1117", tblAlt: "#161b22", hdr: "#21262d",
                txtPri: "#c9d1d9", txtSec: "#8b949e",
                cyan: "#58a6ff", blue: "#1f6feb",
                net: "#39c5cf", sub: "#bc8cff", host: "#3fb950", sep: "#484f58",
                cgnFg: "#d29922", resFg: "#f85149"
            )
        case .gitHubDarkDimmed:
            return create(
                id: id, isDark: true,
                win: "#1c2128", card: "#22272e", border: "#444c56",
                tbl: "#22272e", tblAlt: "#2d333b", hdr: "#373e47",
                txtPri: "#adbac7", txtSec: "#768390",
                cyan: "#539bf5", blue: "#316dca",
                net: "#539bf5", sub: "#ad6ff7", host: "#57ab5a", sep: "#545d68",
                cgnFg: "#c69026", resFg: "#e5534b"
            )
        case .gitHubLight:
            return create(
                id: id, isDark: false,
                win: "#f6f8fa", card: "#ffffff", border: "#d0d7de",
                tbl: "#ffffff", tblAlt: "#f6f8fa", hdr: "#eaeef2",
                txtPri: "#24292f", txtSec: "#57606a",
                cyan: "#0969da", blue: "#0969da",
                net: "#0550ae", sub: "#8250df", host: "#1a7f37", sep: "#8c959f",
                cgnFg: "#9a6700", resFg: "#cf222e"
            )
        case .gitHubLightHighContrast:
            return create(
                id: id, isDark: false,
                win: "#ffffff", card: "#ffffff", border: "#24292f",
                tbl: "#ffffff", tblAlt: "#f6f8fa", hdr: "#24292f",
                txtPri: "#010409", txtSec: "#24292f",
                cyan: "#0550ae", blue: "#0969da",
                net: "#0550ae", sub: "#6639ba", host: "#116329", sep: "#57606a",
                cgnFg: "#9a6700", resFg: "#cf222e"
            )

        // MARK: 9. Monokai
        case .monokaiClassic:
            return create(
                id: id, isDark: true,
                win: "#1e1f1c", card: "#272822", border: "#3e3d32",
                tbl: "#272822", tblAlt: "#1e1f1c", hdr: "#49483e",
                txtPri: "#f8f8f2", txtSec: "#75715e",
                cyan: "#66d9ef", blue: "#66d9ef",
                net: "#66d9ef", sub: "#ae81ff", host: "#a6e22e", sep: "#75715e",
                cgnFg: "#fd971f", resFg: "#f92672"
            )
        case .monokaiPro:
            return create(
                id: id, isDark: true,
                win: "#221f22", card: "#2d2a2e", border: "#403e41",
                tbl: "#2d2a2e", tblAlt: "#221f22", hdr: "#4a474b",
                txtPri: "#fcfcfa", txtSec: "#727072",
                cyan: "#78dce8", blue: "#ab9df2",
                net: "#78dce8", sub: "#ff6188", host: "#a9dc76", sep: "#727072",
                cgnFg: "#fc9867", resFg: "#ab9df2"
            )
        case .monokaiCharcoal:
            return create(
                id: id, isDark: true,
                win: "#19181a", card: "#222124", border: "#333136",
                tbl: "#222124", tblAlt: "#19181a", hdr: "#3d3b40",
                txtPri: "#e3e3e1", txtSec: "#636164",
                cyan: "#62c4d4", blue: "#9788d9",
                net: "#62c4d4", sub: "#ea5077", host: "#92c462", sep: "#636164",
                cgnFg: "#e08554", resFg: "#9788d9"
            )
        case .monokaiLight:
            return create(
                id: id, isDark: false,
                win: "#f7f7f7", card: "#ffffff", border: "#e0e0e0",
                tbl: "#ffffff", tblAlt: "#f0f0f0", hdr: "#e0e0e0",
                txtPri: "#272822", txtSec: "#75715e",
                cyan: "#00897b", blue: "#0d47a1",
                net: "#00897b", sub: "#8e24aa", host: "#2e7d32", sep: "#75715e",
                cgnFg: "#ef6c00", resFg: "#d81b60"
            )

        // MARK: 10. Rosé Pine
        case .rosePineMain:
            return create(
                id: id, isDark: true,
                win: "#14121d", card: "#191724", border: "#26233a",
                tbl: "#191724", tblAlt: "#1f1d2e", hdr: "#2a283e",
                txtPri: "#e0def4", txtSec: "#908caa",
                cyan: "#9ccfd8", blue: "#31748f",
                net: "#9ccfd8", sub: "#c4a7e7", host: "#ebbcba", sep: "#6e6a86",
                cgnFg: "#f6c177", resFg: "#eb6f92"
            )
        case .rosePineMoon:
            return create(
                id: id, isDark: true,
                win: "#1c1a27", card: "#232136", border: "#393552",
                tbl: "#232136", tblAlt: "#2a273f", hdr: "#44415a",
                txtPri: "#e0def4", txtSec: "#908caa",
                cyan: "#9ccfd8", blue: "#3e8fb0",
                net: "#9ccfd8", sub: "#c4a7e7", host: "#ea9a97", sep: "#6e6a86",
                cgnFg: "#f6c177", resFg: "#eb6f92"
            )
        case .rosePineDawn:
            return create(
                id: id, isDark: false,
                win: "#f2e9de", card: "#faf4ed", border: "#cecacd",
                tbl: "#faf4ed", tblAlt: "#fffaf3", hdr: "#dfdad9",
                txtPri: "#575279", txtSec: "#797593",
                cyan: "#56949f", blue: "#286983",
                net: "#56949f", sub: "#907aa9", host: "#d7827e", sep: "#9893a5",
                cgnFg: "#ea9d34", resFg: "#b4637a"
            )

        // MARK: 11. Ayu
        case .ayuDark:
            return create(
                id: id, isDark: true,
                win: "#0b0e14", card: "#0f1419", border: "#1e2530",
                tbl: "#0f1419", tblAlt: "#131721", hdr: "#242d38",
                txtPri: "#e6e1cf", txtSec: "#5c6773",
                cyan: "#36a3d9", blue: "#39bae6",
                net: "#95e6cb", sub: "#d4bfff", host: "#b8cc52", sep: "#4b5666",
                cgnFg: "#ffb454", resFg: "#f07178"
            )
        case .ayuMirage:
            return create(
                id: id, isDark: true,
                win: "#171b24", card: "#1f2430", border: "#2e3646",
                tbl: "#1f2430", tblAlt: "#1a1f2c", hdr: "#333d4e",
                txtPri: "#cbccc6", txtSec: "#707a8c",
                cyan: "#5ccfe6", blue: "#73d0ff",
                net: "#95e6cb", sub: "#d4bfff", host: "#bae67e", sep: "#5c6773",
                cgnFg: "#ffcc66", resFg: "#f28779"
            )
        case .ayuLight:
            return create(
                id: id, isDark: false,
                win: "#f3f4f5", card: "#fafafa", border: "#e1e3e5",
                tbl: "#fafafa", tblAlt: "#f3f4f5", hdr: "#e6e8ea",
                txtPri: "#575f66", txtSec: "#8a9199",
                cyan: "#36a3d9", blue: "#39bae6",
                net: "#4cbf99", sub: "#a37acc", host: "#86b300", sep: "#abb0b6",
                cgnFg: "#fa8d3e", resFg: "#f07178"
            )

        // MARK: 12. Kanagawa
        case .kanagawaWave:
            return create(
                id: id, isDark: true,
                win: "#16161d", card: "#1f1f28", border: "#2a2a37",
                tbl: "#1f1f28", tblAlt: "#223249", hdr: "#363646",
                txtPri: "#dcd7ba", txtSec: "#727169",
                cyan: "#7aa89f", blue: "#7e9cd8",
                net: "#6a9589", sub: "#957fb8", host: "#98bb6c", sep: "#54546d",
                cgnFg: "#ffa066", resFg: "#e46876"
            )
        case .kanagawaDragon:
            return create(
                id: id, isDark: true,
                win: "#121216", card: "#181616", border: "#282727",
                tbl: "#181616", tblAlt: "#1f1d1d", hdr: "#393836",
                txtPri: "#c5c9c5", txtSec: "#625e5a",
                cyan: "#658594", blue: "#8ba4b0",
                net: "#658594", sub: "#8992a7", host: "#8a9a7b", sep: "#504d49",
                cgnFg: "#c4746e", resFg: "#a292a3"
            )
        case .kanagawaLotus:
            return create(
                id: id, isDark: false,
                win: "#ece7dc", card: "#f2ecbc", border: "#d5cea3",
                tbl: "#f2ecbc", tblAlt: "#e7e2c9", hdr: "#ddd6b8",
                txtPri: "#545464", txtSec: "#716e61",
                cyan: "#597b75", blue: "#4d699b",
                net: "#597b75", sub: "#766b90", host: "#6f894e", sep: "#8a8575",
                cgnFg: "#cc6d00", resFg: "#c84053"
            )

        // MARK: 13. Everforest
        case .everforestDarkHard:
            return create(
                id: id, isDark: true,
                win: "#272e33", card: "#2d353b", border: "#3d484d",
                tbl: "#2d353b", tblAlt: "#232a2e", hdr: "#475258",
                txtPri: "#d3c6aa", txtSec: "#859289",
                cyan: "#83c092", blue: "#7fbbb3",
                net: "#7fbbb3", sub: "#d699b6", host: "#a7c080", sep: "#5c6a72",
                cgnFg: "#e69875", resFg: "#e67e80"
            )
        case .everforestDarkMedium:
            return create(
                id: id, isDark: true,
                win: "#2d353b", card: "#343f44", border: "#475258",
                tbl: "#343f44", tblAlt: "#2d353b", hdr: "#4f5b66",
                txtPri: "#d3c6aa", txtSec: "#9da9a0",
                cyan: "#83c092", blue: "#7fbbb3",
                net: "#7fbbb3", sub: "#d699b6", host: "#a7c080", sep: "#5c6a72",
                cgnFg: "#e69875", resFg: "#e67e80"
            )
        case .everforestLight:
            return create(
                id: id, isDark: false,
                win: "#edf0e5", card: "#f8f5e4", border: "#d3c6aa",
                tbl: "#f8f5e4", tblAlt: "#f2efdc", hdr: "#e5dfc5",
                txtPri: "#5c6a72", txtSec: "#829181",
                cyan: "#3a94c5", blue: "#3a94c5",
                net: "#35a77c", sub: "#df69ba", host: "#8da101", sep: "#939f91",
                cgnFg: "#e69875", resFg: "#f85552"
            )

        // MARK: 14. Night Owl
        case .nightOwlDark:
            return create(
                id: id, isDark: true,
                win: "#01111d", card: "#011627", border: "#0b2942",
                tbl: "#011627", tblAlt: "#0b2942", hdr: "#11385b",
                txtPri: "#d6deeb", txtSec: "#5f7e97",
                cyan: "#7fdbca", blue: "#82aaff",
                net: "#21c7a8", sub: "#c792ea", host: "#22da6e", sep: "#5f7e97",
                cgnFg: "#ecc48d", resFg: "#ef5350"
            )
        case .lightOwl:
            return create(
                id: id, isDark: false,
                win: "#eef2f7", card: "#f0f4f8", border: "#d9e2ec",
                tbl: "#f0f4f8", tblAlt: "#e2e8f0", hdr: "#cbd5e1",
                txtPri: "#403f53", txtSec: "#7a819b",
                cyan: "#0c969b", blue: "#288ed7",
                net: "#0c969b", sub: "#7f52ca", host: "#08916a", sep: "#94a3b8",
                cgnFg: "#c97518", resFg: "#e03e3e"
            )

        // MARK: 15. Material
        case .materialPalenight:
            return create(
                id: id, isDark: true,
                win: "#202330", card: "#292d3e", border: "#3b415b",
                tbl: "#292d3e", tblAlt: "#232635", hdr: "#444b6e",
                txtPri: "#bfc7d5", txtSec: "#676e95",
                cyan: "#89ddff", blue: "#82aaff",
                net: "#89ddff", sub: "#c792ea", host: "#c3e88d", sep: "#676e95",
                cgnFg: "#ffcb6b", resFg: "#ff5370"
            )
        case .materialDeepOcean:
            return create(
                id: id, isDark: true,
                win: "#090b10", card: "#0f111a", border: "#1a1c25",
                tbl: "#0f111a", tblAlt: "#12141e", hdr: "#262938",
                txtPri: "#8f93a2", txtSec: "#4b526d",
                cyan: "#80cbc4", blue: "#82aaff",
                net: "#80cbc4", sub: "#c792ea", host: "#c3e88d", sep: "#4b526d",
                cgnFg: "#ffcb6b", resFg: "#ff5370"
            )
        case .materialLighter:
            return create(
                id: id, isDark: false,
                win: "#eceff1", card: "#fafafa", border: "#cfd8dc",
                tbl: "#fafafa", tblAlt: "#eceff1", hdr: "#cfd8dc",
                txtPri: "#546e7a", txtSec: "#90a4ae",
                cyan: "#39adb5", blue: "#6182b8",
                net: "#39adb5", sub: "#7c4dff", host: "#91b859", sep: "#b0bec5",
                cgnFg: "#f76d47", resFg: "#e53935"
            )

        // MARK: 16. SynthWave '84
        case .synthWave84Glow:
            return create(
                id: id, isDark: true,
                win: "#201c2d", card: "#262335", border: "#3b334e",
                tbl: "#262335", tblAlt: "#1e1a29", hdr: "#463d5c",
                txtPri: "#f92aad", txtSec: "#848bbd",
                cyan: "#36f9f6", blue: "#72f1b8",
                net: "#36f9f6", sub: "#fe4450", host: "#72f1b8", sep: "#614d85",
                cgnFg: "#fede5d", resFg: "#ff7edb"
            )
        case .synthWave84Classic:
            return create(
                id: id, isDark: true,
                win: "#241b2f", card: "#2a2139", border: "#463465",
                tbl: "#2a2139", tblAlt: "#241b2f", hdr: "#533f78",
                txtPri: "#ffffff", txtSec: "#8a889d",
                cyan: "#36f9f6", blue: "#fe4450",
                net: "#36f9f6", sub: "#ff7edb", host: "#72f1b8", sep: "#614d85",
                cgnFg: "#fede5d", resFg: "#fe4450"
            )

        // MARK: 17. Cyberpunk
        case .cyberpunk2077:
            return create(
                id: id, isDark: true,
                win: "#000814", card: "#000b1e", border: "#0c2240",
                tbl: "#000b1e", tblAlt: "#031530", hdr: "#10325c",
                txtPri: "#00ff9f", txtSec: "#00b8ff",
                cyan: "#00f0ff", blue: "#00b8ff",
                net: "#00f0ff", sub: "#ff0055", host: "#00ff9f", sep: "#0c4078",
                cgnFg: "#fcee0a", resFg: "#ff0055"
            )
        case .cyberpunkScarlet:
            return create(
                id: id, isDark: true,
                win: "#120914", card: "#1a0f1d", border: "#36163b",
                tbl: "#1a0f1d", tblAlt: "#140a17", hdr: "#4d1a54",
                txtPri: "#fcee0a", txtSec: "#ea448f",
                cyan: "#00f0ff", blue: "#ff0055",
                net: "#fcee0a", sub: "#ff0055", host: "#00ff9f", sep: "#6b2275",
                cgnFg: "#ff7b00", resFg: "#ff0055"
            )

        // MARK: 18. Shades of Purple
        case .shadesOfPurpleSuperDark:
            return create(
                id: id, isDark: true,
                win: "#1e1e38", card: "#222244", border: "#38386a",
                tbl: "#222244", tblAlt: "#1c1c36", hdr: "#454580",
                txtPri: "#e3dfff", txtSec: "#a599e9",
                cyan: "#00e8c6", blue: "#b362ff",
                net: "#00e8c6", sub: "#ff628c", host: "#fad000", sep: "#575796",
                cgnFg: "#ff9d00", resFg: "#b362ff"
            )
        case .shadesOfPurpleClassic:
            return create(
                id: id, isDark: true,
                win: "#222144", card: "#2d2b55", border: "#48447d",
                tbl: "#2d2b55", tblAlt: "#242249", hdr: "#565294",
                txtPri: "#ffffff", txtSec: "#a599e9",
                cyan: "#79c0ff", blue: "#b362ff",
                net: "#79c0ff", sub: "#ff628c", host: "#fad000", sep: "#5d579e",
                cgnFg: "#ff9d00", resFg: "#b362ff"
            )
        case .shadesOfPurpleLight:
            return create(
                id: id, isDark: false,
                win: "#f6f0ff", card: "#ffffff", border: "#e5dbf7",
                tbl: "#ffffff", tblAlt: "#f9f5ff", hdr: "#e5dbf7",
                txtPri: "#2d1354", txtSec: "#6c5ce7",
                cyan: "#00b894", blue: "#4d21fc",
                net: "#0984e3", sub: "#6c5ce7", host: "#00b894", sep: "#a29bfe",
                cgnFg: "#e17055", resFg: "#d63031"
            )

        // MARK: 19. Poimandres
        case .poimandresDark:
            return create(
                id: id, isDark: true,
                win: "#171922", card: "#1b1e28", border: "#272b38",
                tbl: "#1b1e28", tblAlt: "#171922", hdr: "#303647",
                txtPri: "#e4f0fb", txtSec: "#767c9d",
                cyan: "#5de4c7", blue: "#89ddff",
                net: "#add7ff", sub: "#f087bd", host: "#5de4c7", sep: "#505775",
                cgnFg: "#fffac2", resFg: "#d0679d"
            )
        case .poimandresStorm:
            return create(
                id: id, isDark: true,
                win: "#14171f", card: "#1a1d26", border: "#292d3b",
                tbl: "#1a1d26", tblAlt: "#151720", hdr: "#33394a",
                txtPri: "#dbe6f0", txtSec: "#6b718f",
                cyan: "#5de4c7", blue: "#89ddff",
                net: "#89ddff", sub: "#e07aa9", host: "#5de4c7", sep: "#49506b",
                cgnFg: "#fff4aa", resFg: "#e07aa9"
            )
        case .poimandresLight:
            return create(
                id: id, isDark: false,
                win: "#f4f6f8", card: "#ffffff", border: "#e1e4e8",
                tbl: "#ffffff", tblAlt: "#f8fafc", hdr: "#e1e4e8",
                txtPri: "#1b1e28", txtSec: "#506477",
                cyan: "#2188ff", blue: "#3e6ee8",
                net: "#1f6feb", sub: "#8957e5", host: "#2ea043", sep: "#506477",
                cgnFg: "#d29922", resFg: "#f85149"
            )

        // MARK: 20. Horizon
        case .horizonDark:
            return create(
                id: id, isDark: true,
                win: "#16171f", card: "#1c1e26", border: "#2a2c3a",
                tbl: "#1c1e26", tblAlt: "#181a22", hdr: "#36394c",
                txtPri: "#e3e6ee", txtSec: "#6c6f93",
                cyan: "#26bbd9", blue: "#25b0bc",
                net: "#26bbd9", sub: "#ee64ac", host: "#29d398", sep: "#4f5270",
                cgnFg: "#fab795", resFg: "#e95678"
            )
        case .horizonBright:
            return create(
                id: id, isDark: false,
                win: "#ebebed", card: "#f5f5f7", border: "#d2d3d9",
                tbl: "#f5f5f7", tblAlt: "#eaeaf0", hdr: "#d8d9e0",
                txtPri: "#323443", txtSec: "#787b91",
                cyan: "#1d899e", blue: "#1d899e",
                net: "#1d899e", sub: "#b83a78", host: "#1d9c6e", sep: "#9ea1b5",
                cgnFg: "#de6938", resFg: "#d13b63"
            )

        // MARK: 21. Andromeda
        case .andromedaDark:
            return create(
                id: id, isDark: true,
                win: "#21242c", card: "#262a33", border: "#383e4c",
                tbl: "#262a33", tblAlt: "#1e2128", hdr: "#434b5c",
                txtPri: "#e1e3e8", txtSec: "#747d91",
                cyan: "#00e8c6", blue: "#00d4ff",
                net: "#00e8c6", sub: "#c74ded", host: "#98e024", sep: "#565e70",
                cgnFg: "#ffe66d", resFg: "#ff00aa"
            )
        case .andromedaBordered:
            return create(
                id: id, isDark: true,
                win: "#1b1e24", card: "#21252d", border: "#3c4352",
                tbl: "#21252d", tblAlt: "#1a1d23", hdr: "#474f61",
                txtPri: "#d7d9df", txtSec: "#6a7387",
                cyan: "#00e8c6", blue: "#00d4ff",
                net: "#00e8c6", sub: "#ff00aa", host: "#98e024", sep: "#545b6e",
                cgnFg: "#ffe66d", resFg: "#f92672"
            )
        case .andromedaLight:
            return create(
                id: id, isDark: false,
                win: "#f7f7f8", card: "#ffffff", border: "#e0e1e6",
                tbl: "#ffffff", tblAlt: "#f1f2f6", hdr: "#e0e1e6",
                txtPri: "#1e2029", txtSec: "#747785",
                cyan: "#0099b8", blue: "#1e78ff",
                net: "#0099b8", sub: "#8a44c8", host: "#00a854", sep: "#747785",
                cgnFg: "#f08c00", resFg: "#e03131"
            )

        // MARK: 22. Nightfox
        case .nightfoxDark:
            return create(
                id: id, isDark: true,
                win: "#131a24", card: "#192330", border: "#29394f",
                tbl: "#192330", tblAlt: "#151e2a", hdr: "#344863",
                txtPri: "#cdcecf", txtSec: "#71839b",
                cyan: "#719cd6", blue: "#86abdc",
                net: "#63cdcf", sub: "#9d79d6", host: "#81b29a", sep: "#495d7a",
                cgnFg: "#dbc074", resFg: "#c94f6d"
            )
        case .duskfox:
            return create(
                id: id, isDark: true,
                win: "#191726", card: "#232136", border: "#373354",
                tbl: "#232136", tblAlt: "#1c1a2d", hdr: "#433f66",
                txtPri: "#cdcbe0", txtSec: "#7a769a",
                cyan: "#a3be8c", blue: "#86abdc",
                net: "#eb998b", sub: "#b48ead", host: "#a3be8c", sep: "#524d73",
                cgnFg: "#f4a261", resFg: "#e06c75"
            )
        case .dawnfox:
            return create(
                id: id, isDark: false,
                win: "#ebe5df", card: "#f6f2ee", border: "#ded5cd",
                tbl: "#f6f2ee", tblAlt: "#ede6df", hdr: "#ded5cd",
                txtPri: "#575279", txtSec: "#7d758f",
                cyan: "#286983", blue: "#286983",
                net: "#286983", sub: "#89749e", host: "#618774", sep: "#9890a8",
                cgnFg: "#b27938", resFg: "#b84b5f"
            )

        // MARK: 23. Cobalt2
        case .cobalt2Classic:
            return create(
                id: id, isDark: true,
                win: "#15232d", card: "#193549", border: "#244b67",
                tbl: "#193549", tblAlt: "#152736", hdr: "#2d5d80",
                txtPri: "#ffffff", txtSec: "#7ea1b8",
                cyan: "#0088ff", blue: "#0088ff",
                net: "#0088ff", sub: "#ff9d00", host: "#3cd070", sep: "#49718d",
                cgnFg: "#ffc600", resFg: "#ff628c"
            )
        case .cobalt2Bright:
            return create(
                id: id, isDark: true,
                win: "#111d26", card: "#152c3d", border: "#1e3e56",
                tbl: "#152c3d", tblAlt: "#122330", hdr: "#274f6e",
                txtPri: "#e6f1f8", txtSec: "#6f91a8",
                cyan: "#1fa0ff", blue: "#ffc600",
                net: "#1fa0ff", sub: "#ff628c", host: "#3cd070", sep: "#456a85",
                cgnFg: "#ffb800", resFg: "#ff628c"
            )
        case .cobalt2Light:
            return create(
                id: id, isDark: false,
                win: "#edf3fa", card: "#ffffff", border: "#d0e1f5",
                tbl: "#ffffff", tblAlt: "#f4f8fd", hdr: "#d0e1f5",
                txtPri: "#193549", txtSec: "#4f7899",
                cyan: "#0088cc", blue: "#0066cc",
                net: "#0088cc", sub: "#5c39b5", host: "#2b8a3e", sep: "#4f7899",
                cgnFg: "#d97706", resFg: "#dc2626"
            )

        // MARK: 24. Alabaster
        case .alabasterDark:
            return create(
                id: id, isDark: true,
                win: "#0a0e12", card: "#0e1419", border: "#21272e",
                tbl: "#0e1419", tblAlt: "#121920", hdr: "#2b343d",
                txtPri: "#f0f2f4", txtSec: "#6f7a85",
                cyan: "#4eb0e6", blue: "#4eb0e6",
                net: "#4eb0e6", sub: "#cf7ad0", host: "#60b050", sep: "#4a535e",
                cgnFg: "#f59b42", resFg: "#e05555"
            )
        case .alabasterLight:
            return create(
                id: id, isDark: false,
                win: "#ededed", card: "#f7f7f7", border: "#d8d8d8",
                tbl: "#f7f7f7", tblAlt: "#efefef", hdr: "#e0e0e0",
                txtPri: "#202020", txtSec: "#707070",
                cyan: "#325cc0", blue: "#325cc0",
                net: "#325cc0", sub: "#7a3e9d", host: "#438234", sep: "#999999",
                cgnFg: "#aa6700", resFg: "#ba3030"
            )

        // MARK: 25. Tomorrow
        case .tomorrowNight:
            return create(
                id: id, isDark: true,
                win: "#151718", card: "#1d1f21", border: "#282a2e",
                tbl: "#1d1f21", tblAlt: "#242629", hdr: "#373b41",
                txtPri: "#c5c8c6", txtSec: "#969896",
                cyan: "#8abeb7", blue: "#81a2be",
                net: "#8abeb7", sub: "#b294bb", host: "#b5bd68", sep: "#5c5f63",
                cgnFg: "#de935f", resFg: "#cc6666"
            )
        case .tomorrowNightBlue:
            return create(
                id: id, isDark: true,
                win: "#001b3d", card: "#002451", border: "#00346e",
                tbl: "#002451", tblAlt: "#001f44", hdr: "#003f8e",
                txtPri: "#ffffff", txtSec: "#7285b7",
                cyan: "#99ffff", blue: "#bbdaff",
                net: "#99ffff", sub: "#ebbbff", host: "#d1f1a9", sep: "#495a85",
                cgnFg: "#ffc58f", resFg: "#ff9da4"
            )
        case .tomorrowNightEighties:
            return create(
                id: id, isDark: true,
                win: "#232323", card: "#2d2d2d", border: "#393939",
                tbl: "#2d2d2d", tblAlt: "#333333", hdr: "#515151",
                txtPri: "#cccccc", txtSec: "#999999",
                cyan: "#66cccc", blue: "#6699cc",
                net: "#66cccc", sub: "#cc99cc", host: "#99cc99", sep: "#666666",
                cgnFg: "#f99157", resFg: "#f2777a"
            )
        case .tomorrowNightBright:
            return create(
                id: id, isDark: true,
                win: "#000000", card: "#101010", border: "#2a2a2a",
                tbl: "#101010", tblAlt: "#1a1a1a", hdr: "#424242",
                txtPri: "#eaeaea", txtSec: "#969896",
                cyan: "#70c0b1", blue: "#7aa6da",
                net: "#70c0b1", sub: "#c397d8", host: "#b9ca4a", sep: "#555555",
                cgnFg: "#e78c45", resFg: "#d54e53"
            )
        case .tomorrowDay:
            return create(
                id: id, isDark: false,
                win: "#f5f5f5", card: "#ffffff", border: "#d6d6d6",
                tbl: "#ffffff", tblAlt: "#f0f0f0", hdr: "#efefef",
                txtPri: "#4d4d4c", txtSec: "#8e908c",
                cyan: "#3e999f", blue: "#4271ae",
                net: "#3e999f", sub: "#8959a8", host: "#718c00", sep: "#a0a2a0",
                cgnFg: "#eab700", resFg: "#c82829"
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
