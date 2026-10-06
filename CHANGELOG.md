# Changelog

All notable changes to **SubnetCalc for macOS** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v2.6.2] - 2026-10-06

### Added

- **Premier 25 Developer Theme Families Engine (`ThemeManager.swift`)**:
  - Expanded from 14 presets to a comprehensive suite of **25 iconic developer theme families (2020–2026 Trends)** with authentic, calibrated color palettes:
    1. **Catppuccin**: Mocha (Default Dark), Macchiato, Frappé, Latte (Light).
    2. **Dracula**: Official, Soft, Alucard.
    3. **Tokyo Night**: Dark, Storm, Light.
    4. **Nord**: Dark, Polar, Light.
    5. **One Dark**: One Dark Pro, One Dark Vivid, One Light.
    6. **Gruvbox**: Dark Hard, Dark Medium, Light.
    7. **Solarized**: Dark & Light precision scientific palettes.
    8. **GitHub**: Dark, Dark Dimmed, Light.
    9. **Monokai**: Classic, Pro, Charcoal.
    10. **Rosé Pine**: Main, Moon, Dawn (Light).
    11. **Ayu**: Dark, Mirage, Light.
    12. **Kanagawa**: Wave, Dragon, Lotus (Light).
    13. **Everforest**: Dark Hard, Dark Medium, Light.
    14. **Night Owl**: Dark & Light Owl.
    15. **Material**: Palenight, Deep Ocean, Lighter.
    16. **SynthWave '84**: Glow & Classic retro cyberpunk.
    17. **Cyberpunk**: Cyberpunk 2077 & Scarlet.
    18. **Shades of Purple**: Super Dark & Classic.
    19. **Poimandres**: Dark & Storm.
    20. **Horizon**: Dark & Bright.
    21. **Andromeda**: Dark & Bordered.
    22. **Nightfox**: Nightfox Dark, Duskfox, Dawnfox.
    23. **Cobalt2**: Classic & Bright.
    24. **Alabaster**: Dark & Light minimal clarity.
    25. **Tomorrow**: Night, Night Blue, Night Eighties, Night Bright, Day.
  - Implemented clean hierarchical macOS Menu Bar submenu navigation (`Theme >> Family >> Subthemes`) with real-time bidirectional checkmark indicators and persistent `UserDefaults` storage.
- **Bespoke Modern & Informative About Window (`AboutWindowController`)**:
  - Replaced Apple's standard plain dialog with an elegant, modern, and informative native AppKit About Window (540x500).
  - Features styled 68x68 app icon, bold typography, version badges (`v2.6.2 (Build 14)`, `Universal 2`, `macOS 10.15+`, `GPL-2.0`).
  - Interactive segmented control switching between **Capabilities**, **Themes (25 Families)**, and **Credits & Lineage** (honoring original author Julien Mulot, maintainer Harry Dertin Sutisna Alsyundawy, algorithmic oracle Dr. Thomas Dreibholz, and themes author Taylor Lindsey).
  - Direct action buttons opening the GitHub repository, maintainer website (`https://alsyundawy.com`), and dismiss controls.
- **Decoupled CI & Release Runner Workflows (`build.yml` & `release.yml`)**:
  - Separated builder runners into two specialized workflows modeled after [`NotepadNext-MacOS`](https://github.com/alsyundawy/NotepadNext-MacOS):
    - `build.yml` for continuous integration on `master` branch push and pull requests (builds, packages, and uploads Actions artifacts without touching GitHub Releases).
    - `release.yml` exclusively triggered on tag push (`v*`) to build, calculate SHA-256 checksums, and publish release DMGs/ZIPs to GitHub Releases.
  - Eliminated duplicate file generation, double runner executions, and release conflicts.
- **Canonical `SubnetCalc.app` Distribution Invariant**:
  - Re-engineered builder runner workflows so that inside every `.dmg` disk image and `.zip` archive across all architectures (`Universal 2`, `arm64`, and `x86_64`), the application bundle is strictly named **`SubnetCalc.app`**.
  - Added automated `/Applications` drag-and-drop symlinks to all `.dmg` staging folders.
- **High-Definition Desktop Banner Flyer**:
  - Created a crystal-clear, razor-sharp cyberpunk neon banner flyer (`assets/subnetcalc-desktop-banner.jpg`) modeled after the flagship desktop flyer design without hardcoded version numbers, prominently embedded at the top of `README.md`.
- **Enhanced GitHub Repository About Metadata**:
  - Enriched repository description, official homepage, and added comprehensive topic tags (`apple-silicon`, `cidr`, `cocoa`, `dark-mode`, `flsm`, `ipv4`, `ipv6`, `macos`, `network-tools`, `networking`, `subnet-calculator`, `swift`, `universal-binary`, `vlsm`).
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
