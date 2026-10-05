# Changelog

All notable changes to **SubnetCalc for macOS** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v2.6.1] - 2026-10-05

### Added

- **Multi-Architecture CI/CD Automation**:
  - Implemented GitHub Actions Swift CI matrix testing builds on both **Apple Silicon** (`macos-latest` ARM64) and **Intel** (`macos-15-intel` x86_64).
  - Created automated **Universal 2 Builder & Release Workflow** (`macos-builder.yml`) compiling Universal 2 binaries, standalone architecture slices, and dedicated DMG installers (`SubnetCalc-2.6.1-Universal.dmg`, `SubnetCalc-2.6.1-arm64.dmg`, `SubnetCalc-2.6.1-x64.dmg`) and ZIP archives with cryptographic SHA-256 checksums (`SHA256SUMS.txt`).
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
