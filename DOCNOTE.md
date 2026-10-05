# SubnetCalc for macOS — Technical Documentation Notes (DOCNOTE)

> - **Release Version**: `v2.6.2` (Modern Dark Glassmorphic UI, Multi-Cloud Subnetting & Enterprise Hardening)
> - **Original Creator & Lead Developer**: [`Julien Mulot`](https://github.com/mulot) — [`https://subnetcalc.mulot.org`](https://subnetcalc.mulot.org)
> - **Maintainer, CI/CD & Modernization**: [`Harry Dertin Sutisna Alsyundawy (@alsyundawy)`](https://github.com/alsyundawy) — [`ALSYUNDAWY IT SOLUTION`](https://alsyundawy.com)
> - **Repository**: [`https://github.com/alsyundawy/SubnetCalc-MacOS`](https://github.com/alsyundawy/SubnetCalc-MacOS)
> - **Architecture Target**: Apple Universal 2 Binary (Apple Silicon ARM64 & Intel Core x86_64)

---

## 1. Executive Summary & Architectural Overview

**SubnetCalc for macOS** is an ultra-lightweight, 100% native AppKit/Cocoa desktop application engineered for network administrators, systems architects, and DevOps engineers. Unlike heavy web-wrapped or Electron utilities, SubnetCalc compiles down to native machine instructions, delivering sub-millisecond calculation times, instant UI responsiveness, and a baseline RAM footprint of **less than 25 MB RSS**.

Version **2.6.2** delivers a landmark modernization and feature expansion. Drawing inspiration from modern dark enterprise dashboards (Visual Subnet Calculator Web GUI and KusumaVision NMS V2), v2.6.2 integrates:

1. **Pillar 1: Modern Dark Glassmorphic AppKit Overhaul** with high-contrast palette tokens (`#080c16`, `#0f172a`), Dark Aqua appearance, and vivid attributed bit visualizer (Neon Cyan `n`, Royal Purple `s`, Emerald Green `h`, and muted gray `.`).
2. **Pillar 2: Multi-Cloud Subnet Reservation Profiles** supporting AWS VPC, Azure VNet, Google Cloud (GCP) VPC, Oracle Cloud (OCI), and Standard RFC 1918.
3. **Pillar 3: Real-Time RFC 1918 & IP Range Classifier** with color-coded pill status badges.
4. **Pillar 4: VLSM Capacity & Host Efficiency Analytics** calculating real-time host utilization, address space waste overhead, and efficiency percentage.
5. **Pillar 5: RFC 4193 IPv6 ULA Generator** powered by CSPRNG (`SecRandomCopyBytes`) 40-bit Global ID entropy.
6. **Pillar 6: Spreadsheet-Safe Data Portability Engine** defending against CSV Formula Injection (CWE-1236) and producing RFC 4180 CSV and Plain Text ASCII tables.

All additions are 100% additive and non-breaking, strictly preserving the classic 6-tab structure (`IPv4`, `Subnets/Hosts`, `CIDR`, `FLSM`, `VLSM`, `IPv6`) and backwards parity.

### Core Architectural Invariants

1. **Native AppKit Performance Invariant**: All view controllers, data sources, and custom drawing components are built on Apple's native Cocoa framework (`NSWindow`, `NSTabView`, `NSComboBox`, `NSSlider`, `NSTableView`), guaranteeing seamless integration with macOS system appearance (Dark Mode), native typography, and accessibility hooks.
2. **Deterministic Bitwise Computation**: Subnet calculations execute synchronously in compiled Swift 6/5.x using bitwise shifting and mask arithmetic, eliminating network latency and ensuring complete confidentiality with 100% offline execution.
3. **Universal 2 Binary Support**: Compiles simultaneously for Apple Silicon (`arm64` for M1/M2/M3/M4) and Intel (`x86_64`), producing a single "fat" binary that runs at maximum native speed on all hardware without Rosetta 2 translation.
4. **Persistent Session Memory via Core Data**: Calculation history is automatically maintained in an Apple Core Data SQLite persistent store with LRU rotation and safe history purging.
5. **Multi-Arch CI/CD Automation**: Integrated GitHub Actions workflows testing builds on both Apple Silicon (`macos-latest`) and Intel (`macos-15-intel`), with automated DMG disk image synthesis, ZIP packaging, and cryptographic SHA-256 verification.

---

## 2. Comprehensive 13-Pillar Verification & Quality Hardening

Every component across `SubnetCalcAppDelegate.swift`, `IPSubnetcalc.swift`, `AddrHistory`, and `Base.lproj/MainMenu.xib` has been audited against the 13 production engineering pillars:

### 1. Bug Review & Runtime Recovery

- **Issue 1 (Fatal Range Trapping in History Removal)**: In `clearHistory(_ sender: AnyObject)`, the loop previously executed `for _ in (0...addrField.numberOfItems-1)` and `for _ in (0...history.count-1)`. When history was empty (`count == 0`), Swift formed the range `0...(-1)`, immediately trapping with `Fatal error: Can't form Range with upperBound < lowerBound` and terminating the app.
  - **Remediation**: Refactored `clearHistory` to use `addrField.removeAllItems()` and collection iteration (`for item in history`), providing safe, deterministic cleanup on empty collections.
- **Issue 2 (AppKit About Panel Compiler Error on CI Runners)**: In `SubnetCalcAppDelegate.swift`, `orderFrontStandardAboutPanel` passed `.copyright: "..."` in the `[NSApplication.AboutPanelOptionKey: Any]` dictionary. In Apple's AppKit SDK, `AboutPanelOptionKey` only defines `.applicationName`, `.applicationIcon`, `.version`, `.applicationVersion`, and `.credits`. The non-existent `.copyright` key triggered `type 'NSApplication.AboutPanelOptionKey' has no member 'copyright'` on GitHub Actions runners.
  - **Remediation**: Removed `.copyright` from the options dictionary and consolidated copyright information in `creditsString` and `SubnetCalc-Info.plist` (`NSHumanReadableCopyright`).
- **Issue 3 (Negative Octet Validation Bypass)**: In `IPSubnetCalc.validateIPv4`, octet validation checked `if (digit > 255)`, but did not enforce lower bounds (`digit < 0`). Values such as `192.168.-1.1` passed initial validation and caused unexpected downstream `nil` returns in `digitize(ipAddress:)` and fatal force-unwrap traps.
  - **Remediation**: Added explicit range checks `digit < 0 || digit > 255` and verified absence of invalid leading characters (`+` or whitespace).
- **Issue 4 (Force-Unwrap Crash in IPv6-to-IPv4 Translation)**: In `convertIPv6toIPv4`, string parsing used force-unwrapped `UInt32(...)!` which crashed if malformed or embedded dotted-decimal IPv4 was supplied.
  - **Remediation**: Implemented safe `nil`-coalescing fallback and added native support for RFC 4291 §2.5.5.2 embedded dotted notation (`::ffff:192.0.2.1`).
- **Issue 5 (macOS Deployment Target Modernization)**: Updated `MACOSX_DEPLOYMENT_TARGET` across `SubnetCalc` and `SubnetCalcUITests` in `SubnetCalc.xcodeproj/project.pbxproj` from legacy `10.12` to `10.15` (macOS Catalina). Resolves Xcode warning `The macOS deployment target 'MACOSX_DEPLOYMENT_TARGET' is set to 10.12, but the range of supported deployment target versions is 10.13 to 26.5.99`.
- **Issue 6 (IDE SwiftLint Workspace Linting Invocation Error)**: Antigravity IDE / VS Code extension `vknabel.vscode-swiftlint` by default enables `autoLintWorkspace: true`. When executed without an explicit configuration search path, the extension invoked `/usr/local/bin/swiftlint lint --use-script-input-files` passing the workspace directory path to `SCRIPT_INPUT_FILE_0`, which triggered `Error: No lintable files found at paths: '/Users/alsyundawy/Downloads/GitHub/SubnetCalc-MacOS'`. Resolved by configuring `.vscode/settings.json` with `"swiftlint.autoLintWorkspace": false` and `"swiftlint.configSearchPaths": [".swiftlint.yml"]`, restricting SwiftLint to active document files and eliminating the extension crash alert.
- **Issue 7 (Brand-New macOS App Icon & Logo Synchronization)**: Upgraded legacy bitmap icon with modern glassmorphism network squircle branding. Purged solid background with flood-fill transparency and generated full Apple macOS HIG icon sets across 16x16, 32x32, 64x64, 128x128, 256x256, 512x512, and 1024x1024 points, embedding into `Images.xcassets` and root `logo.png`.
- **Issue 8 (IPv6 Runtime Crash Protection & Slicing Safety)**: Hardened `binarizeIPv6`, `digitizeIPv6`, `dottedDecimalIPv6`, `ip6ARPA`, and `fullAddressIPv6` against force-unwrap crashes (`!`) and string index slicing bounds errors when processing short IPv6 notation or malformed segments. Furthermore, mitigated critical force-unwrap crashes in `SubnetCalcAppDelegate.swift` (`doIPSubnetCalc` and `doIPv6SubnetCalc`) by replacing `Int(ipmask!)!` with safe optional binding (`if let maskStr = ipmask, let maskVal = Int(maskStr)`).
- **Issue 9 (Automated Quality Gates via Tailored MegaLinter & Super-Linter)**: Configured dedicated `.github/workflows/super-linter.yml` and `.github/workflows/mega-linter.yml` runners. Tailored linter engines specifically to this Swift / Cocoa AppKit repository with `.mega-linter.yml`, `.markdownlint.json`, and `.yamllint.yml`, explicitly excluding proprietary Xcode project files (`project.pbxproj`), asset catalogs, and build directories to eliminate false positives while enforcing 100% strict SwiftLint and documentation standards.

### 2. Syntax & Compiler Review

- **Verification**: Verified using `swiftc -typecheck` across all Swift files with exit code `0` and 0 compiler warnings.

### 3. Documentation & ADRs

- Detailed architectural documentation provided in `DOCNOTE.md`, updated `README.md`, and formatted `CHANGELOG.md`.

### 4. Performance & Computational Efficiency

- Bitwise mask shift algorithms operate in $\mathcal{O}(1)$ time complexity with zero dynamic memory allocation overhead.

### 5. Architectural Cleanliness & Boundaries

- Logic cleanly segregated: calculation engine (`IPSubnetcalc.swift`), UI presentation & event dispatch (`SubnetCalcAppDelegate.swift`), and persistence (`AddrHistory`).

### 6. Observability & Telemetry

- Zero tracking, telemetry, or external network requests. Completely private and offline.

### 7. Accessibility (WCAG 2.2 AA)

- All text inputs use native `NSTextField` with High Contrast Dark Mode compatibility and macOS VoiceOver screen reader support.

### 8. Testing Strategy & Verification

- Tested with automated multi-architecture GitHub Actions runner testing matrix across Apple Silicon (`macos-latest`) and Intel (`macos-15-intel`) macOS runners, alongside a dedicated standalone RFC compliance test suite.

### 9. Edge-Case Auditing & RFC Standards Compliance

- **RFC 3021 (Using 31-Bit Prefixes on IPv4 Point-to-Point Links)**:
  - _Standard_: Section 2.1 specifies that on /31 subnets, neither address is reserved for broadcast or network identifiers; both endpoints are usable host addresses (2 usable hosts).
  - _Audit Finding_: `maxHosts()` previously calculated `(0xFFFFFFFF >> 31) - 1 = 0`, reporting 0 usable hosts while `subnetRange()` accurately reported both addresses (`firstIP = subnetId()`, `lastIP = subnetBroadcast()`).
  - _Remediation_: Explicitly set `maxHosts()` to return `2` for `maskBits == 31`, resolving the internal contradiction and fully conforming to RFC 3021.
- **RFC 790 & RFC 1122 (IPv4 Classful Routing & Loopback Boundaries)**:
  - _Standard_: RFC 790 assigns network numbers with high-order bit 0 (0–127) to Class A. Network `127.0.0.0/8` is reserved for loopback by RFC 1122 §3.2.1.3, maintaining a Class A default mask of `255.0.0.0`. Class B strictly begins at 128 (high-order bits `10`).
  - _Audit Finding_: `netClass(ipAddress:)` previously used `if (addr1stByte >= 127 && addr1stByte < 192) { return "B" }`, wrongly misclassifying `127.0.0.1` as Class B.
  - _Remediation_: Corrected boundary conditions: `addr1stByte <= 127` returns `"A"` and `addr1stByte >= 128 && addr1stByte < 192` returns `"B"`.
- **RFC 5952 (A Recommendation for IPv6 Address Text Representation)**:
  - _Standard_: §4.2 defines canonical zero-compression:
    - §4.2.1: The longest run of consecutive 16-bit 0 fields must be shortened with `::`.
    - §4.2.2: The `::` must NOT be used to shorten just a single 16-bit 0 field.
    - §4.2.3: When equal lengths occur, the leftmost sequence must be shortened.
  - _Audit Finding_: `compactAddressIPv6` previously compressed the first run encountered regardless of length, occasionally producing malformed trailing colons (e.g. `2001:db8::1:0:0:0:`).
  - _Remediation_: Re-engineered `compactAddressIPv6` into a canonical two-pass scanner adhering to all RFC 5952 rules.
- **RFC 4291 & RFC 3056 (IPv6 Architecture & 6to4 Transition)**:
  - Validated 6to4 synthesis (`2002:V4ADDR::/48`) and IPv4-mapped addresses (`::ffff:d.d.d.d`). Fixed typo in `Constants.resIPv6Blocks` where `::/128` contained an unintended leading whitespace (`" Unspecified Address"` -> `"Unspecified Address"`), and registered `ff00::/8` (Multicast).

### 10. Security & Hardening

- Sandboxed entitlements configured (`com.apple.security.app-sandbox`), strict read-only workflow permissions, ad-hoc code-signing checks, and input sanitization preventing denial-of-service via malformed inputs.

### 11. Code Review & Production Polish

- Standardized Swift conventions, eliminated unused closure parameters, and aligned About dialog credits.

### 12. Deprecation & Modern Platform Readiness

- Modernized `NSSavePanel` file export routines (`exportSubnetsHosts`, `exportFLSM`, `exportVLSM`) to utilize `allowedContentTypes = [.commaSeparatedText]` via `UniformTypeIdentifiers` on macOS 11.0+, while safely retaining `allowedFileTypes` fallback for older systems.

### 13. CI/CD & Infrastructure Automation

- Automated Universal 2 compilation, slice isolation, disk image generation (`hdiutil`), and checksum publishing.

---

## 3. GitHub Actions CI/CD Architecture

Version 2.6.1 introduces three dedicated GitHub Actions automation pipelines:

### 1. Multi-Arch Swift CI Matrix (`.github/workflows/swift.yml`)

- Runs on `push` and `pull_request` to `master`.
- Matrix targets:
  - `macos-latest` (Apple Silicon M-series ARM64 runner)
  - `macos-15-intel` (Intel x86_64 runner)
- Executes native `xcodebuild` with ad-hoc signing bypass for CI environments.
- Verifies binary architecture using `file` and `lipo -info`.

### 2. Universal 2 Builder & Release Automation (`.github/workflows/macos-builder.yml`)

- Compiles a fat **Universal 2 Binary**:

  ```bash
  xcodebuild build \
    -project SubnetCalc.xcodeproj \
    -scheme SubnetCalc \
    -configuration Release \
    ARCHS="arm64 x86_64" \
    ONLY_ACTIVE_ARCH=NO
  ```

- Extracts architecture-specific slices (`arm64` and `x86_64`).
- Ad-hoc signs all bundles using `codesign --force --deep --sign -`.
- Packages distribution assets:
  - `SubnetCalc-Universal.dmg` (compressed UDZO disk image via `hdiutil`)
  - `SubnetCalc-macOS-Universal.zip` (via `ditto --sequesterRsrc --keepParent`)
  - `SubnetCalc-macOS-arm64.zip`
  - `SubnetCalc-macOS-x86_64.zip`
  - `SHA256SUMS.txt` cryptographic checksums
- Automatically creates and publishes a GitHub Release when tags (`v*`) are pushed.

### 3. CodeQL Advanced Security (`.github/workflows/codeql.yml`)

- Continuous AST-based static analysis auditing Swift and C/Objective-C code against CWE vulnerabilities.

---

## 4. Upstream Heritage & Attribution Summary

- **Classic SubnetCalc**: Authored by **Julien Mulot** (`mulot/SubnetCalc`). Original copyright © 2011–2022 Julien Mulot.
- **Modern Maintenance**: Engineered and maintained by **Harry Dertin Sutisna Alsyundawy** (`alsyundawy/SubnetCalc-MacOS`).
- **License**: GNU General Public License v2 (GPL-2.0).
