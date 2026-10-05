# Changelog

All notable changes to **SubnetCalc for macOS** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v2.6.1] - 2026-10-05

### Added
- **Multi-Architecture CI/CD Automation**:
  - Implemented GitHub Actions Swift CI matrix testing builds on both **Apple Silicon** (`macos-latest` ARM64) and **Intel** (`macos-15-intel` x86_64).
  - Created automated **Universal 2 Builder & Release Workflow** (`macos-builder.yml`) compiling Universal 2 binaries, standalone architecture slices, and compressed DMG/ZIP packages with cryptographic SHA-256 checksums (`SHA256SUMS.txt`).
- **About Panel with Maintainer & Creator Credits**:
  - Implemented custom `orderFrontStandardAboutPanel(_:)` in `SubnetCalcAppDelegate.swift` displaying formatted credits honoring original creator **Julien Mulot** and maintainer **Harry Dertin Sutisna Alsyundawy (@alsyundawy)**.
  - Added `Credits.rtf` rich text bundle asset and synchronized `NSHumanReadableCopyright` in `SubnetCalc-Info.plist`.
- **Comprehensive Documentation**:
  - Overhauled `README.md` following modern professional standards with architecture diagrams, Gatekeeper removal guides, developer build commands, and verified donation channels.
  - Authored comprehensive Technical Documentation Notes (`DOCNOTE.md`) detailing the 13-pillar code quality audit and architectural invariants.
  - Created structured `CHANGELOG.md` capturing complete upstream version history.

### Fixed
- **Fatal Trapping Crash in History Purge**:
  - Resolved `Fatal error: Can't form Range with upperBound < lowerBound` in `clearHistory(_:)` by replacing `0...(-1)` range construction with safe `addrField.removeAllItems()` and collection iteration.
- **Negative IPv4 Octet Bypass**:
  - Enforced lower boundary validation (`digit >= 0 && digit <= 255`) in `IPSubnetCalc.validateIPv4` preventing negative octets (e.g. `-1.0.0.1`) from bypassing syntax gates.
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
