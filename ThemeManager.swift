//
//  ThemeManager.swift
//  SubnetCalc
//
//  Modern Dark Theme Design Tokens & Appearance Helpers
//  Inspired by Visual Subnet Calculator & KusumaVision NMS V2
//

import Cocoa

public struct ThemeManager {
    // MARK: - Canvas & Card Backgrounds
    public static let midnightBackground = NSColor(calibratedRed: 8/255, green: 12/255, blue: 22/255, alpha: 1.0)
    public static let cardBackground = NSColor(calibratedRed: 15/255, green: 23/255, blue: 42/255, alpha: 0.90)
    public static let cardBorder = NSColor(calibratedWhite: 1.0, alpha: 0.08)

    // MARK: - Vibrant Accents
    public static let accentCyan = NSColor(calibratedRed: 0/255, green: 229/255, blue: 255/255, alpha: 1.0)
    public static let accentBlue = NSColor(calibratedRed: 2/255, green: 132/255, blue: 199/255, alpha: 1.0)

    // MARK: - Bit Visualizer Semantic Colors
    public static let networkBitColor = NSColor(calibratedRed: 0/255, green: 229/255, blue: 255/255, alpha: 1.0) // Neon Cyan (n)
    public static let subnetBitColor = NSColor(calibratedRed: 168/255, green: 85/255, blue: 247/255, alpha: 1.0) // Royal Purple (s)
    public static let hostBitColor = NSColor(calibratedRed: 16/255, green: 185/255, blue: 129/255, alpha: 1.0)   // Emerald Green (h)
    public static let separatorBitColor = NSColor(calibratedWhite: 0.45, alpha: 1.0)                              // Muted Dot (.)

    // MARK: - Dynamic Status Badges (Pills)
    public static let rfc1918GreenBg = NSColor(calibratedRed: 6/255, green: 95/255, blue: 70/255, alpha: 0.85)
    public static let rfc1918GreenFg = NSColor(calibratedRed: 52/255, green: 211/255, blue: 153/255, alpha: 1.0)

    public static let publicBlueBg = NSColor(calibratedRed: 30/255, green: 58/255, blue: 138/255, alpha: 0.85)
    public static let publicBlueFg = NSColor(calibratedRed: 56/255, green: 189/255, blue: 248/255, alpha: 1.0)

    public static let cgnatAmberBg = NSColor(calibratedRed: 120/255, green: 53/255, blue: 15/255, alpha: 0.85)
    public static let cgnatAmberFg = NSColor(calibratedRed: 251/255, green: 191/255, blue: 36/255, alpha: 1.0)

    public static let loopbackCyanBg = NSColor(calibratedRed: 19/255, green: 78/255, blue: 74/255, alpha: 0.85)
    public static let loopbackCyanFg = NSColor(calibratedRed: 45/255, green: 212/255, blue: 191/255, alpha: 1.0)

    public static let reservedPurpleBg = NSColor(calibratedRed: 88/255, green: 28/255, blue: 135/255, alpha: 0.85)
    public static let reservedPurpleFg = NSColor(calibratedRed: 192/255, green: 132/255, blue: 252/255, alpha: 1.0)

    // MARK: - Table View Design Tokens (Deep Navy / Sleek Slate - Zero Brown)
    public static let tableBackground = NSColor(calibratedRed: 15/255, green: 23/255, blue: 42/255, alpha: 1.0)     // #0f172a
    public static let tableRowAlt = NSColor(calibratedRed: 20/255, green: 30/255, blue: 55/255, alpha: 1.0)         // #141e37
    public static let tableGridColor = NSColor(calibratedWhite: 1.0, alpha: 0.08)
    public static let tableHeaderColor = NSColor(calibratedRed: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)    // #1e293b
    public static let tableTextPrimary = NSColor(calibratedRed: 241/255, green: 245/255, blue: 249/255, alpha: 1.0) // Slate 100
    public static let tableTextSecondary = NSColor(calibratedRed: 148/255, green: 163/255, blue: 184/255, alpha: 1.0)// Slate 400

    // MARK: - AppKit Styling Helpers
    public static func styleWindow(_ window: NSWindow) {
        if #available(OSX 10.14, *) {
            window.appearance = NSAppearance(named: .darkAqua)
        }
        window.backgroundColor = midnightBackground
    }

    public static func styleCard(_ box: NSBox) {
        box.boxType = .custom
        box.isTransparent = false
        box.fillColor = cardBackground
        box.borderColor = cardBorder
        box.borderWidth = 1.0
        box.cornerRadius = 10.0
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
