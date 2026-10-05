//
//  ThemeManager.swift
//  SubnetCalc
//
//  Modern Dark Theme Design Tokens & Appearance Helpers
//  Color palettes derived from ActuallyTaylor/Swift-Themes
//  (Catppuccin Mocha, Dracula, Tomorrow Night Blue)
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

// MARK: - SwiftThemes Standard Palettes (https://github.com/ActuallyTaylor/Swift-Themes)
public struct SwiftThemes {
    public struct CatppuccinMocha {
        public static let base = NSColor(hex: "#1e1e2e")
        public static let mantle = NSColor(hex: "#181825")
        public static let crust = NSColor(hex: "#11111b")
        public static let surface0 = NSColor(hex: "#313244")
        public static let surface1 = NSColor(hex: "#45475a")
        public static let surface2 = NSColor(hex: "#585b70")
        public static let overlay0 = NSColor(hex: "#6c7086")
        public static let text = NSColor(hex: "#cdd6f4")
        public static let subtext0 = NSColor(hex: "#a6adc8")
        public static let subtext1 = NSColor(hex: "#bac2de")
        public static let sapphire = NSColor(hex: "#74c7ec")
        public static let blue = NSColor(hex: "#89b4fa")
        public static let green = NSColor(hex: "#a6e3a1")
        public static let teal = NSColor(hex: "#94e2d5")
        public static let peach = NSColor(hex: "#fab387")
        public static let mauve = NSColor(hex: "#cba6f7")
        public static let red = NSColor(hex: "#f38ba8")
        public static let yellow = NSColor(hex: "#f9e2af")
    }

    public struct Dracula {
        public static let background = NSColor(hex: "#282a36")
        public static let currentLine = NSColor(hex: "#44475a")
        public static let foreground = NSColor(hex: "#f8f8f2")
        public static let comment = NSColor(hex: "#6272a4")
        public static let cyan = NSColor(hex: "#8be9fd")
        public static let green = NSColor(hex: "#50fa7b")
        public static let orange = NSColor(hex: "#ffb86c")
        public static let pink = NSColor(hex: "#ff79c6")
        public static let purple = NSColor(hex: "#bd93f9")
        public static let red = NSColor(hex: "#ff5555")
        public static let yellow = NSColor(hex: "#f1fa8c")
    }

    public struct TomorrowNightBlue {
        public static let background = NSColor(hex: "#002451")
        public static let currentLine = NSColor(hex: "#00346e")
        public static let foreground = NSColor(hex: "#ffffff")
        public static let selection = NSColor(hex: "#003f8e")
        public static let comment = NSColor(hex: "#7285b7")
        public static let blue = NSColor(hex: "#bbdaff")
        public static let green = NSColor(hex: "#d1f1a9")
        public static let orange = NSColor(hex: "#ffc58f")
        public static let purple = NSColor(hex: "#ebbbff")
    }
}

public struct ThemeManager {
    // MARK: - Canvas & Card Backgrounds (Anchored to Swift-Themes Catppuccin Mocha)
    public static let midnightBackground = SwiftThemes.CatppuccinMocha.crust
    public static let cardBackground = SwiftThemes.CatppuccinMocha.base
    public static let cardBorder = SwiftThemes.CatppuccinMocha.surface0

    // MARK: - Vibrant Accents
    public static let accentCyan = SwiftThemes.CatppuccinMocha.sapphire
    public static let accentBlue = SwiftThemes.CatppuccinMocha.blue

    // MARK: - Bit Visualizer Semantic Colors
    public static let networkBitColor = SwiftThemes.CatppuccinMocha.sapphire // Sapphire Cyan (n)
    public static let subnetBitColor = SwiftThemes.CatppuccinMocha.mauve     // Mauve Purple (s)
    public static let hostBitColor = SwiftThemes.CatppuccinMocha.green       // Emerald Green (h)
    public static let separatorBitColor = SwiftThemes.CatppuccinMocha.overlay0 // Muted Dot (.)

    // MARK: - Dynamic Status Badges (Pills)
    public static let rfc1918GreenBg = NSColor(calibratedRed: 26/255, green: 56/255, blue: 45/255, alpha: 0.90)
    public static let rfc1918GreenFg = SwiftThemes.CatppuccinMocha.green

    public static let publicBlueBg = NSColor(calibratedRed: 28/255, green: 45/255, blue: 82/255, alpha: 0.90)
    public static let publicBlueFg = SwiftThemes.CatppuccinMocha.blue

    public static let cgnatAmberBg = NSColor(calibratedRed: 74/255, green: 44/255, blue: 23/255, alpha: 0.90)
    public static let cgnatAmberFg = SwiftThemes.CatppuccinMocha.peach

    public static let loopbackCyanBg = NSColor(calibratedRed: 22/255, green: 58/255, blue: 64/255, alpha: 0.90)
    public static let loopbackCyanFg = SwiftThemes.CatppuccinMocha.teal

    public static let reservedPurpleBg = NSColor(calibratedRed: 53/255, green: 32/255, blue: 74/255, alpha: 0.90)
    public static let reservedPurpleFg = SwiftThemes.CatppuccinMocha.mauve

    // MARK: - Table View Design Tokens (SwiftThemes Catppuccin Mocha - Zero Brown)
    public static let tableBackground = SwiftThemes.CatppuccinMocha.base         // #1e1e2e
    public static let tableRowAlt = SwiftThemes.CatppuccinMocha.mantle           // #181825
    public static let tableGridColor = NSColor(calibratedWhite: 1.0, alpha: 0.05)
    public static let tableHeaderColor = SwiftThemes.CatppuccinMocha.surface1    // #45475a
    public static let tableTextPrimary = SwiftThemes.CatppuccinMocha.text        // #cdd6f4
    public static let tableTextSecondary = SwiftThemes.CatppuccinMocha.subtext0  // #a6adc8

    // MARK: - AppKit Styling Helpers
    public static func styleWindow(_ window: NSWindow) {
        if #available(OSX 10.14, *) {
            window.appearance = NSAppearance(named: .darkAqua)
        }
        window.backgroundColor = midnightBackground
    }

    public static func styleCard(_ box: NSBox) {
        if box.titlePosition == .noTitle {
            box.boxType = .custom
            box.isTransparent = false
            box.fillColor = cardBackground
            box.borderColor = cardBorder
            box.borderWidth = 1.0
            box.cornerRadius = 8.0
        }
    }

    public static func styleTableView(_ tableView: NSTableView) {
        if #available(OSX 10.14, *) {
            tableView.appearance = NSAppearance(named: .darkAqua)
        }
        tableView.backgroundColor = tableBackground
        tableView.gridColor = tableGridColor
        tableView.intercellSpacing = NSSize(width: 4, height: 4)

        for column in tableView.tableColumns {
            if let cell = column.dataCell as? NSTextFieldCell {
                cell.textColor = tableTextPrimary
                cell.backgroundColor = tableBackground
                cell.drawsBackground = false
                cell.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
            }
            let headerCell = column.headerCell
            headerCell.textColor = NSColor.white
            headerCell.font = NSFont.systemFont(ofSize: 11, weight: .semibold)
        }

        if let scrollView = tableView.enclosingScrollView {
            scrollView.drawsBackground = true
            scrollView.backgroundColor = tableBackground
            scrollView.contentView.drawsBackground = true
            scrollView.contentView.backgroundColor = tableBackground
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
        let result = NSMutableAttributedString(string: bitPattern, attributes: [
            .font: baseFont,
            .foregroundColor: NSColor.white
        ])
        var currentIndex = 0
        for char in bitPattern {
            let color: NSColor
            switch char {
            case "n": color = networkBitColor
            case "s": color = subnetBitColor
            case "h": color = hostBitColor
            case ".": color = separatorBitColor
            default:  color = NSColor.white
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
            bg = rfc1918GreenBg
            fg = rfc1918GreenFg
            shortText = (classification.contains("ULA") || classification.contains("Unique Local")) ? "ULA" : "Private"
        } else if classification.contains("Public") || classification.contains("Global Unicast") {
            bg = publicBlueBg
            fg = publicBlueFg
            shortText = "Public"
        } else if classification.contains("CGNAT") {
            bg = cgnatAmberBg
            fg = cgnatAmberFg
            shortText = "CGNAT"
        } else if classification.contains("Loopback") {
            bg = loopbackCyanBg
            fg = loopbackCyanFg
            shortText = "Loopback"
        } else if classification.contains("Link-Local") {
            bg = loopbackCyanBg
            fg = loopbackCyanFg
            shortText = "Link-Local"
        } else if classification.contains("Multicast") {
            bg = reservedPurpleBg
            fg = reservedPurpleFg
            shortText = "Multicast"
        } else if classification.contains("This Host") {
            bg = reservedPurpleBg
            fg = reservedPurpleFg
            shortText = "This Host"
        } else {
            bg = reservedPurpleBg
            fg = reservedPurpleFg
            shortText = "Reserved"
        }

        label.stringValue = " \(shortText) "
        label.toolTip = classification
        stylePillBadge(label, bg: bg, fg: fg)
    }
}
