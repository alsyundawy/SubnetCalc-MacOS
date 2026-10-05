# Changelog

All notable changes to **SubnetCalc for macOS** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v2.6.2] - 2026-10-06

### Added

- **Modern Dark Glassmorphic Theme & AppKit Appearance Overhaul (`ThemeManager.swift`)**:
  - Engineered native macOS Dark Aqua theme matching modern enterprise dark dashboards (midnight `#080c16`, slate `#0f172a`, and subtle border cards).
  - High-craft typographic and color-coded bit visualizer formatting: Neon Cyan (`#00e5ff` for network bits `n`), Royal Purple (`#a855f7` for subnet bits `s`), Emerald Green (`#10b981` for host bits `h`), and muted grey for dot separators.
  - Window styling helper automatically configuring dark background vibrancy on startup while preserving manual dark mode toggling.
- **Multi-Cloud Subnet Reservation Profiles (`CloudProfile`)**:
  - Implemented reservation calculation engine supporting **Standard RFC 1918**, **AWS VPC** (5 reserved addresses: `.0` Network, `.1` VPC Router/Default Gateway, `.2` Amazon DNS, `.3` Reserved, `.last` Broadcast; min prefix `/28`), **Azure VNet** (5 reserved addresses: `.0` Network, `.1` Default Gateway, `.2` Primary DNS, `.3` Secondary DNS, `.last` Broadcast; min prefix `/29`), **Google Cloud (GCP) VPC** (4 reserved addresses: `.0` Network, `.1` Default Gateway, `.last-1` Reserved, `.last` Broadcast; min prefix `/29`), and **Oracle Cloud (OCI)** (3 reserved addresses: `.0` Network, `.1` Default Gateway, `.last` Broadcast; min prefix `/30`).
  - Added interactive Cloud Profile popup selector dynamically updating usable IP ranges, host counts, and role mappings without altering standard RFC calculations.
- **Authoritative Real-Time RFC 1918 & IP Address Range Classifier**:
  - Added real-time classification badge dynamically categorizing input IPv4 addresses: RFC 1918 Private (Class A `10.0.0.0/8`, Class B `172.16.0.0/12`, Class C `192.168.0.0/16`), RFC 6598 CGNAT / Shared Space (`100.64.0.0/10`), RFC 1122 Loopback (`127.0.0.0/8`), RFC 3927 Link-Local APIPA (`169.254.0.0/16`), RFC 5771 Multicast Class D (`224.0.0.0/4`), RFC 1122 Reserved Class E (`240.0.0.0/4`), and Public Routable IPv4.
  - Real-time pill badge with tailored color schemes (emerald green for private, sky blue for public, amber for CGNAT, teal for loopback, purple for reserved).
- **VLSM Capacity & Host Efficiency Analytics**:
  - Added real-time host utilization analytics to the VLSM tab computing total requested hosts vs. allocated block capacity, wasted host overhead, and efficiency percentage.
  - Interactive progress indicator and monospace analytics label providing immediate feedback on subnet address space optimization.
- **RFC 4193 Unique Local IPv6 Address (ULA) Generator**:
  - Implemented cryptographically secure ULA generator utilizing macOS `SecRandomCopyBytes` for 40-bit pseudo-random Global IDs.
  - One-click "Generate ULA (RFC 4193)" button creating canonical `fdXX:XXXX:XXXX::/48` prefixes and default `/64` subnets.
- **Spreadsheet-Safe Data Portability Engine (`DataPortability`)**:
  - Implemented defense-in-depth protection against Spreadsheet Formula Injection (CWE-1236) by automatically prefixing dangerous leading execution characters (`=`, `+`, `-`, `@`) with `'`.
  - Re-engineered CSV exports (`exportSubnetsHosts`, `exportFLSM`, `exportVLSM`) adhering strictly to RFC 4180 quotation escaping, standard comma `,` delimiters, and UTF-8 encoding.
  - Added Plain Text ASCII table formatter (`exportPlainTextTable` / `exportAsciiTable`) with dynamic column alignment.
- **Automated Verification Test Suite (`SubnetCalcTests/main.swift`)**:
  - Added 76 automated test assertions covering multi-cloud ranges, bounds checking, address classifications, ULA entropy and canonical formatting, CSV escaping, and zero-regression parity.

### Changed

- Updated version numbers across project bundle: `MARKETING_VERSION = 2.6.2`, `CURRENT_PROJECT_VERSION = 14`, and about panel fallback to `2.6.2 (Build 14)`.
- Replaced non-standard semicolon `;` in CSV export outputs with standard RFC 4180 comma delimiters.
- Completely preserved the exact 6-tab architecture (`IPv4`, `Subnets/Hosts`, `CIDR`, `FLSM`, `VLSM`, `IPv6`) with zero breaking changes to existing calculations.

### Fixed & Hardened (13-Pillar Production Code Review & UI/UX Refinement)

- **`Swift-Themes` Standard Palettes Integration (`ThemeManager.swift`)**:
  - Integrated the open-source color palette architecture from [`ActuallyTaylor/Swift-Themes`](https://github.com/ActuallyTaylor/Swift-Themes) into `ThemeManager.swift`.
  - Added native `BridgeColor` type alias, `NSColor(hex:alpha:)` scanner, and standard palettes: **Catppuccin Mocha** (`base: #1e1e2e`, `mantle: #181825`, `crust: #11111b`, `surface0: #313244`, `text: #cdd6f4`, `sapphire: #74c7ec`, `mauve: #cba6f7`, `green: #a6e3a1`), **Dracula**, and **Tomorrow Night Blue**.
  - Anchored application canvas, containers, alternating table rows, and typography to Catppuccin Mocha, completely replacing macOS Dark Aqua sepia brown tints with an authentic developer-grade palette.
- **Intelligent Tab Switching & Canonical CIDR Synchronization**:
  - Implemented `NSTabViewDelegate` in `SubnetCalcAppDelegate` ensuring when switching between IPv4 tabs and IPv6 tab, the address input smoothly defaults to `/24` (`10.0.0.0/24`) and `/64` (`2001:db8::/64`) without overwriting user-entered custom addresses.
  - Ensured `addrField.stringValue` always synchronizes to canonical CIDR format (`IP/mask`) upon calculation, ensuring history and address displays always retain unambiguous CIDR prefix lengths.
- **Table Selection Highlight Polish**:
  - Refined `tableView(_:willDisplayCell:for:row:)` so that selected rows allow the macOS native vibrant selection accent to shine through with `#ffffff` text, while non-selected rows alternate between Catppuccin Mocha Base (`#1e1e2e`) and Mantle (`#181825`) with Text (`#cdd6f4`).
- **Eliminated Muddy Brown Table Backgrounds**: Replaced system default sepia `controlBackgroundColor` with dedicated dark tokens from `SwiftThemes.CatppuccinMocha` (`tableBackground: #1e1e2e`, `tableRowAlt: #181825`). Implemented `NSTableViewDelegate.tableView(_:willDisplayCell:for:row:)` ensuring every row and cell renders alternating modern dark rows with crisp `#cdd6f4` text and zero sepia tint across Subnets/Hosts, FLSM, and VLSM tables.
- **Resolved IPv6 ULA Button Overlap & Symmetrical Geometry**: Relocated "Generate ULA" button from the top box border (`x: 10, y: 576` which previously collided with the box header label "IPv6 Address") to directly inside the IPv6 Address card adjacent to the address field (`x: 300, y: 11, width: 106, height: 26`). Repositioned the "Short" checkbox to `x: 345, y: 571`, establishing 250px of whitespace separation from the title. Symmetrically widened "IPv6 Address" box to 418px and narrowed "IPv4 conversion" to 188px with uniform 6px margins.
- **Default Form Inputs (`/24` IPv4 and `/64` IPv6)**: Configured all initial form inputs across `IPv4`, `Subnets/Hosts`, `FLSM`, and `VLSM` tabs to default to standard classless `/24` (`255.255.255.0`) instead of legacy Class A `/8`. Initialized IPv6 mask bits to standard `/64`. Populated `addrField` on startup with `10.0.0.0/24` and triggered immediate calculation on launch, presenting a fully populated modern dark interface on first load.
- **Intelligent IPv6 RFC Classification**: Added `IPSubnetCalc.classifyIPv6Address` to detect RFC 4193 ULA (`fc00::/7`), RFC 4291 Link-Local (`fe80::/10`), Loopback (`::1`), Multicast (`ff00::/8`), Documentation (`2001:db8::/32`), and Global Unicast. Upgraded status pill badges to display concise labels (`ULA`, `Private`, `Public`, `CGNAT`, `Loopback`, `Link-Local`, `Multicast`, `Reserved`) with full descriptions in interactive tooltips, resolving the previous bug where IPv6 ULA addresses defaulted to "Public".
- **Prefix Bounds & Integer Overflow Guard**: Added strict `prefix >= 1 && prefix <= minimumPrefix` bounds checking to `usableRange` and `reservedRoles`, eliminating integer bitwise shift traps on invalid inputs.
- **Defensive Unwrapping**: Replaced all remaining force-unwraps (`!`) with safe `guard let` and optional chaining across `subnetRange`, `subnetCIDRRange`, `netClass`, VLSM host solvers (`doVLSM`, `addVLSM`), CSV file handles, and CoreData history persistence.
- **Enhanced CWE-1236 Formula Injection Defense**: Hardened CSV sanitization to cover tab (`\t`) and carriage return (`\r`) in addition to `=`, `+`, `-`, and `@`.
- **Memory & Rendering Optimization**: Re-engineered `ThemeManager.formatColorCodedBitMap` to use in-place attribute mutations on a single `NSMutableAttributedString`, eliminating 35 intermediate object allocations per keystroke.
- **RFC 1122 Compliance**: Added explicit classification for `0.0.0.0/8` ("RFC 1122 This Host on This Network").
- **Legacy Codebase Maintenance**: Initialized unassigned `subnetsTable` instance variable in `PrintView.m`.

---

## [v2.6.1] - 2026-10-05

### Added

- **Multi-Architecture CI/CD Automation**:
  - Implemented GitHub Actions Swift CI matrix testing builds on both **Apple Silicon** (`macos-latest` ARM64) and **Intel** (`macos-15-intel` x86_64).
  - Created automated **Universal 2 Builder & Release Workflow** (`macos-builder.yml`) compiling Universal 2 binaries, standalone architecture slices, and dedicated DMG installers (`SubnetCalc-2.6.1-Universal.dmg`, `SubnetCalc-2.6.1-arm64.dmg`, `SubnetCalc-2.6.1-x64.dmg`) and ZIP archives with cryptographic SHA-256 checksums (`SHA256SUMS.txt`).
- **MegaLinter & Super-Linter Automated Quality Gates**:
  - Implemented `.github/workflows/super-linter.yml` powered by `super-linter/super-linter/slim:v7` scoped specifically to active repository languages (`SwiftLint`, `markdownlint`, `yamllint`, `actionlint`, `shellcheck`, and `gitleaks`) with strict exclusions for proprietary Xcode project bundles and asset catalogs.
  - Implemented `.github/workflows/mega-linter.yml` powered by `oxsecurity/megalinter@v8` and tailored via `.mega-linter.yml`, `.markdownlint.json`, and `.yamllint.yml` for unified multi-engine static analysis and security scanning.
- **Brand-New Application Icon & Logo**:
  - Modernized application branding with transparent background glassmorphic network topology squircle icon (`logo.png`).
  - Generated and synchronized pixel-perfect macOS Human Interface Guidelines icon sets across all scales (16x16, 32x32, 64x64, 128x128, 256x256, 512x512, 1024x1024) across `Images.xcassets/AppIcon.appiconset` and repository root assets.
- **About Panel with Maintainer & Creator Credits**:
  - Implemented custom `orderFrontStandardAboutPanel(_:)` in `SubnetCalcAppDelegate.swift` displaying formatted credits honoring original creator **Julien Mulot** and maintainer **Harry Dertin Sutisna Alsyundawy (@alsyundawy)**.
  - Added `Credits.rtf` rich text bundle asset and synchronized `NSHumanReadableCopyright` in `SubnetCalc-Info.plist`.
- **Comprehensive Documentation**:
  - Overhauled `README.md` following modern professional standards with new logo, architecture diagrams, Gatekeeper removal guides, developer build commands, and verified donation channels.
  - Authored comprehensive Technical Documentation Notes (`DOCNOTE.md`) detailing the 13-pillar code quality audit and architectural invariants.
  - Created structured `CHANGELOG.md` capturing complete upstream version history.

### Fixed

- **GitHub Actions & Xcode Build Failure Remediation**:
  - Resolved compiler build failure on macOS runners in `SubnetCalcAppDelegate.swift:1814` (`type 'NSApplication.AboutPanelOptionKey' has no member 'copyright'`) by removing non-existent `.copyright` key from `orderFrontStandardAboutPanel` options and consolidating copyright in `creditsString` and bundle `Info.plist`.
  - Modernized `NSSavePanel` CSV export methods (`exportSubnetsHosts`, `exportFLSM`, `exportVLSM`) using `allowedContentTypes` on macOS 11.0+ (`.commaSeparatedText`) with backward-compatible fallback, resolving deprecation warnings.
- **IETF RFC Standards Compliance & Algorithmic Hardening**:
  - **RFC 3021 (31-Bit Prefixes on Point-to-Point Links)**: Fixed `maxHosts()` returning `0` for `/31` subnets; now accurately reports `2` usable host addresses, consistent with `subnetRange()`.
  - **RFC 790 & RFC 1122 (IPv4 Classful Network Boundaries)**: Fixed off-by-one boundary bug in `netClass(ipAddress:)` where `127.0.0.0/8` (Loopback) was erroneously classified as Class B. Corrected boundary so `addr1stByte <= 127` is Class A and `addr1stByte >= 128` is Class B.
  - **RFC 5952 (IPv6 Address Text Representation)**: Re-engineered `compactAddressIPv6(ipAddress:)` to follow canonical zero-compression rules: never compress single 0 fields (§4.2.2), compress the longest run (§4.2.1), tie-break to first run (§4.2.3), and prevent trailing colons.
  - **RFC 791 (IPv4 Octet Boundary & Format Validation)**: Hardened `validateIPv4` against negative values (`digit < 0`), leading plus signs, and embedded whitespaces.
  - **RFC 4291 & RFC 3056 (IPv6/IPv4 Transition Robustness)**: Hardened `convertIPv6toIPv4` against force-unwrap crashes with safe nil-coalescing and added support for embedded dotted-decimal IPv4-mapped addresses.
  - **RFC 4291 Reserved Blocks**: Corrected typographic leading space in `Constants.resIPv6Blocks` for `::/128` ("Unspecified Address") and added RFC 4291 Multicast prefix `ff00::/8`.
- **IPv6 Runtime Crash Protection**:
  - Hardened `binarizeIPv6`, `digitizeIPv6`, `dottedDecimalIPv6`, `ip6ARPA`, and `fullAddressIPv6` against force unwraps, non-8-quad inputs, and string slicing bounds errors.
  - Mitigated potential force-unwrap crashes in `doIPSubnetCalc` and `doIPv6SubnetCalc` by implementing safe optional bindings (`if let`) when parsing custom IPv6 transition masks (`Int(ipmask)`).
- **macOS Catalina (10.15) Minimum Deployment Target**:
  - Elevated project and test targets `MACOSX_DEPLOYMENT_TARGET` from legacy `10.12` to `10.15` (macOS Catalina), eliminating Xcode deployment target warnings while guaranteeing native compatibility across Intel and Apple Silicon Macs running macOS Catalina through Sequoia.
- **VS Code & Antigravity IDE SwiftLint Extension Configuration**:
  - Resolved `Command failed: /usr/local/bin/swiftlint lint --use-script-input-files` by configuring `.vscode/settings.json` with `"swiftlint.autoLintWorkspace": false` and explicit `"swiftlint.configSearchPaths": [".swiftlint.yml"]`, preventing the extension from improperly passing directory paths to file-only `--use-script-input-files`.
- **Fatal Trapping Crash in History Purge**:
  - Resolved `Fatal error: Can't form Range with upperBound < lowerBound` in `clearHistory(_:)` by replacing `0...(-1)` range construction with safe `addrField.removeAllItems()` and collection iteration.
- **Workflow Action Version Pinning**:
  - Standardized all GitHub Actions workflows to verified major versions and removed fragile Ruby parsing scripts.

---

## [v2.6.0] - 2024-09-17

### Fixed

- Resolved a crash on macOS 15 Sequoia occurring when changing subnet masks in combo boxes during AppKit runloops.
- Minor UI layout updates for macOS Sequoia appearance.

---

## [v2.5.0] - 2022-03-14

### Added

- Integrated Apple Core Data persistence for recent address history (`AddrHistory` entity).
- Added automatic history loading across application launches and a "Clear History" menu item.

---

## [v2.4.0] - 2021-11-08

### Added

- Variable Length Subnet Mask (VLSM) calculator tab with custom host requirements and subnet labeling.
- Export VLSM subnet design tables to standard CSV format.

---

## [v2.3.0] - 2021-09-19

### Added

- Fixed Length Subnet Mask (FLSM) calculator tab with interactive slider controls.
- Tabular display of partitioned subnets, host capacities, and broadcast boundaries.
- CSV export for FLSM subnet tables.

---

## [v2.2.0] - 2021-08-03

### Added

- Real-time bit visualizer mapping network (`n`), subnet (`s`), and host (`h`) bits across 32 bits.
- Binary map and hexadecimal map views with dotted octet segmentation.

---

## [v2.1.0] - 2021-07-12

### Added

- Classless Inter-Domain Routing (CIDR) supernetting and route summarization tab.
- Maximum supernets, aggregate route mask, and address range calculation.

---

## [v2.0.0] - 2021-02-19

### Changed

- Complete architectural rewrite of SubnetCalc in native **Swift** replacing legacy Objective-C engine.
- Re-architected tab layout combining Address and Subnets into unified high-density views.
- Introduced IPv6 Subnet Calculator tab with 6to4 synthesis, IPv4-mapped translation, and `ip6.arpa` reverse DNS generation.

---

## [v1.6.0] - 2020-11-21

### Changed

- Interface enhancements and stabilization fixes for modern macOS versions.

---

## [v1.5.0] - 2020-11-18

### Added

- Added Buy Me A Coffee support link for original developer Julien Mulot.
