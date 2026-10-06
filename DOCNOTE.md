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

1. **Pillar 1: Complete 25 Developer Theme Families Engine (`ThemeManager.swift`)** covering 25 iconic developer theme suites (2020–2026 Trends): Catppuccin, Dracula, Tokyo Night, Nord, One Dark, Gruvbox, Solarized, GitHub, Monokai, Rosé Pine, Ayu, Kanagawa, Everforest, Night Owl, Material, SynthWave '84, Cyberpunk, Shades of Purple, Poimandres, Horizon, Andromeda, Nightfox, Cobalt2, Alabaster, and Tomorrow with clean hierarchical menu bar switching (`Theme >> Family >> Subthemes`) and persistent `UserDefaults` storage.
2. **Pillar 2: Bespoke Modern & Informative About Window (`AboutWindowController`)** with styled application icon, active theme synchronization, segmented navigation across Capabilities, Themes (25 suites), and Upstream Lineage/Credits.
3. **Pillar 3: Canonical Distribution Packaging Invariant** guaranteeing that inside all `.dmg` disk images and `.zip` archives across Universal 2, ARM64, and Intel architectures, the application bundle is strictly named `SubnetCalc.app` with drag-and-drop `/Applications` installation links.
4. **Pillar 4: Multi-Cloud Subnet Reservation Profiles** supporting AWS VPC, Azure VNet, Google Cloud (GCP) VPC, Oracle Cloud (OCI), and Standard RFC 1918.
5. **Pillar 5: Real-Time RFC 1918 & IP Range Classifier** with color-coded pill status badges.
6. **Pillar 6: VLSM Capacity & Host Efficiency Analytics** calculating real-time host utilization, address space waste overhead, and efficiency percentage.
7. **Pillar 7: RFC 4193 IPv6 ULA Generator** powered by CSPRNG (`SecRandomCopyBytes`) 40-bit Global ID entropy.
8. **Pillar 8: Spreadsheet-Safe Data Portability Engine** defending against CSV Formula Injection (CWE-1236) and producing RFC 4180 CSV and Plain Text ASCII tables.

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
- **Issue 10 (NSTableView Delegate Force-Unwraps & Unchecked Subscript Access)**: In `tableView(_:setObjectValue:for:row:)` and `tableView(_:objectValueFor:tableColumn:row:)`, `tableColumn!` was force-unwrapped across 10 locations, `object as! String` was force-cast, and `subnetsVLSM[row]` lacked bounds protection. When `tableColumn` was nil or row was out of range during full-row draws or dynamic resizing, this triggered immediate traps. Remediated with safe optional bindings (`guard let column = tableColumn`, `if let str = object as? String`, `row >= 0 && row < subnetsVLSM.count`).
- **Issue 11 (Main Thread Calculation Force-Unwraps in AppDelegate)**: In `doAddressMap`, `doSubnet`, `doSubnetHost`, `doFLSM`, and `doCIDR`, `ipsc!` was repeatedly force-unwrapped across dozens of calls following a weak `if ipsc != nil` check. Remediated using `guard let ipsc = self.ipsc else { return }`, guaranteeing deterministic null safety and eliminating potential crash vectors.
- **Issue 12 (Interactive Mask Clobbering & Control Resets in Subnets/Hosts, CIDR, and IPv6 Tabs)**: In previous revisions, `addrField.stringValue` was aggressively overwritten with `IP/mask` strings, causing `splitAddrMask` to parse stale mask suffixes on subsequent slider or combo box adjustments and resetting newly selected mask bits. Furthermore, `changeIPv6MaskBits`, `changeIPv6Subnets`, and `changeIPv6MaxHosts` lacked robust parsing for typed vs selected entries. Remediated by strictly aligning calculation flows with upstream v2.6, preserving pure IP inputs in `addrField`, removing disruptive tab-switching mutations, and hardening combo box handlers with boundary guards (1–128 bits).
- **Issue 13 (Window Canvas Width & Text/Card Truncation Across All Tabs)**: In legacy geometry, window content width was fixed at `670px` (`tabView` at 644px). In the IPv6 tab, the `IPv4 conversion` card was constrained to `188px`. When displaying dynamic long titles such as `"IPv4 conversion (IPv4-Mapped)"` (29 characters, ~210px in system font), AppKit truncated the title to `"IPv4 conversion..."` with trailing ellipsis. Furthermore, two-column cards and table columns were crowded, occasionally clipping long IP ranges. Remediated by expanding native window width from `670px` to `780px` (`minSize = NSSize(width: 780, height: 694)`), widening `tabView` to 754px and all tab root views to 734px, expanding the `IPv4 conversion` box to 270px (providing ~55px of margin clearance so titles never truncate), widening `IPv6 Address` to 446px, expanding two-column grid cards to 340px, and widening table scrollviews to 694px with expanded columns (`rangeCol` 300px). Added runtime geometry enforcement in `setupModernUI()` to prevent cached `NSUserDefaults` from restoring smaller dimensions.

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

### 2. Multi-Architecture CI & Release Builder Workflows (`.github/workflows/build.yml` & `.github/workflows/release.yml`)

- Separated into two distinct, decoupled GitHub Actions workflows modeled after [`NotepadNext-MacOS`](https://github.com/alsyundawy/NotepadNext-MacOS):
  - **`build.yml` (macOS CI Builder)**: Triggers on `push` to `master`, PRs, and manual `workflow_dispatch`. Compiles the Universal 2 binary, slices architectures, packages DMGs/ZIPs, computes SHA-256 checksums, and uploads CI artifacts without publishing GitHub Releases.
  - **`release.yml` (macOS Release Builder)**: Triggers strictly on tag push (`v*`) and manual `workflow_dispatch`. Compiles, slices, packages standard `SubnetCalc.app` DMGs with `/Applications` symlinks, computes `SHA256SUMS.txt`, and publishes official release assets via `softprops/action-gh-release@v2`.
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
  - `SubnetCalc-${VERSION}-Universal.dmg` / `.zip` (Universal 2 binary for arm64 + x86_64)
  - `SubnetCalc-${VERSION}-arm64.dmg` / `.zip` (Apple Silicon native)
  - `SubnetCalc-${VERSION}-x64.dmg` / `.zip` (Intel x86_64 native)
  - `SHA256SUMS.txt` cryptographic checksums
- Guarantees zero duplicate file generation and zero release conflicts.

### 3. CodeQL Advanced Security (`.github/workflows/codeql.yml`)

- Continuous AST-based static analysis auditing Swift and C/Objective-C code against CWE vulnerabilities.

---

## 4. Upstream Heritage & Attribution Summary

- **Classic SubnetCalc**: Authored by **Julien Mulot** (`mulot/SubnetCalc`). Original copyright © 2011–2022 Julien Mulot.
- **Modern Maintenance**: Engineered and maintained by **Harry Dertin Sutisna Alsyundawy** (`alsyundawy/SubnetCalc-MacOS`).
- **License**: GNU General Public License v2 (GPL-2.0).

---

## 5. 13-Pillar Production Code Review & Hardening Verification

In conformance with Google Engineering Practices, OWASP Top 10 2025, and CWE Top 25 2025, the v2.6.2 release has been verified against all 13 production pillars:

1. **Bug Review**: Fixed potential integer shift traps on non-positive prefix inputs (`prefix < 1`) in `CloudProfile.usableRange`.
2. **Syntax Review**: Swift compiler parses 100% cleanly (`swiftc -typecheck` exit code 0).
3. **Runtime Review**: Eliminated all force-unwraps (`!`) in `subnetRange`, `subnetCIDRRange`, `netClass`, VLSM host solvers, CSV file handles, and CoreData history.
4. **Logic Review**: Verified cloud reservation math across AWS (5 IPs, min `/28`), Azure (5 IPs, min `/29`), GCP (4 IPs, min `/29`), OCI (3 IPs, min `/30`), and Standard RFC 1918.
5. **Memory Review**: Re-architected `ThemeManager.formatColorCodedBitMap` to use in-place attribute mutations on a single `NSMutableAttributedString`, eliminating 35 intermediate object allocations per keystroke.
6. **Dead Code Review**: Audited unused legacy Objective-C modules (`PrintView.m`) and initialized `subnetsTable`.
7. **Duplicate Code Review**: Unified cloud reservation range formatting across calculation and export pipelines.
8. **Circular Dependency Review**: Verified strict directional dependencies (`ThemeManager` $\to$ `SubnetCalcAppDelegate` $\to$ `IPSubnetCalc`), zero circular imports.
9. **Performance Bottlenecks Review**: Subnet math executes in $<1$ ms synchronously; UI updates remain bounded to the main AppKit runloop.
10. **Security Vulnerability Review**: Hardened CWE-1236 against CSV formula injection by sanitizing `=`, `+`, `-`, `@`, `\t`, and `\r`.
11. **Maintainability Review**: Zero compiler warnings, idiomatic Swift 5/6 syntax, comprehensive documentation comments.
12. **Scalability Review**: Completely stateless bitwise engine handling arbitrary subnet iterations up to `/32`.
13. **Readability Review**: Passed SwiftLint strict with 0 violations across all codebase files.

---

## 6. UI/UX Professional Layout Refinements, Swift-Themes Standard Palettes & Zero-Brown Theme Architecture

Following empirical visual validation, user design feedback, and integration of [`ActuallyTaylor/Swift-Themes`](https://github.com/ActuallyTaylor/Swift-Themes) on v2.6.2:

1. **Premier 25 Developer Theme Families Architecture (`ThemeManager.swift`)**:
   - Integrated a comprehensive suite of **25 developer theme families (2020–2026 Trends)**: Catppuccin (4 variants), Dracula (4 variants including Dracula Light / Alucard Day), Tokyo Night (3 variants), Nord (3 variants), One Dark (3 variants), Gruvbox (3 variants), Solarized (2 variants), GitHub (4 variants including GitHub Light High Contrast WCAG AAA), Monokai (4 variants including Monokai Light), Rosé Pine (3 variants), Ayu (3 variants), Kanagawa (3 variants), Everforest (3 variants), Night Owl (2 variants), Material (3 variants), SynthWave '84 (2 variants), Cyberpunk (2 variants), Shades of Purple (3 variants including Shades of Purple Light), Poimandres (3 variants including Poimandres Light White), Horizon (2 variants), Andromeda (3 variants including Andromeda Light), Nightfox (3 variants), Cobalt2 (3 variants including Cobalt2 Light Blueprint), Alabaster (2 variants), and Tomorrow (5 variants).
   - Designed a clean hierarchical Menu Bar architecture (`Theme >> Family >> Subthemes`) with live checkmark synchronization across parent groups and subitems, coupled with persistent `UserDefaults` storage.
   - Built calibrated palette structures for every suite ensuring optimal contrast (WCAG 2.2 AA and AAA compliance for light modes), accessible typography, color-coded bit pattern visualizers, and RFC status badge tinting.
   - **Complete 100% Force Unwrap Elimination**: Across `IPSubnetcalc.swift`, `SubnetCalcAppDelegate.swift`, and `ThemeManager.swift`, all force unwraps (`!`) in executable calculation paths and UI event handlers were completely eliminated. Hardened `validateIPv6` against malformed inputs and safe segment iteration. Verified 0 SwiftLint violations and 0 compiler errors.

2. **Eradication of Muddy Brown Table Backgrounds & Selection Highlight Polish**:
   - In macOS Dark Aqua appearance, system default `controlBackgroundColor` resolves to a warm sepia dark gray. Contrasted against deep midnight navy backgrounds, it produced an unappealing brown tint.
   - Re-engineered all `NSTableView` instances (`subnetsHostsView`, `viewFLSM`, `viewVLSM`) and enclosing `NSScrollView`/`NSClipView` using `SwiftThemes.CatppuccinMocha` tokens: `tableBackground` (`#1e1e2e`), `tableRowAlt` (`#181825`), and `tableGridColor` (`rgba(255,255,255,0.05)`).
   - Implemented `NSTableViewDelegate.tableView(_:willDisplayCell:for:row:)` ensuring every data cell renders alternating sleek dark rows with crisp `#cdd6f4` text.
   - Polished row selection state: when a row is selected (`isRowSelected(row)`), `drawsBackground` is disabled and text is set to pure `#ffffff`, allowing the macOS native selection highlight to shine through with high contrast.

3. **Horizontal Window Canvas Widening & Anti-Truncation Geometry (`780px`)**:
   - Expanded the main AppKit window content width from `670px` to `780px` (`height: 694px`) and root `tabView` from `644px` to `754px`, establishing generous lateral breathing room (+110px).
   - Symmetrically widened the `IPv4 conversion` card from `188px` to `270px` and text field to `236px`. Long dynamic labels like `"IPv4 conversion (IPv4-Mapped)"` (29 chars) have >50px margin clearance and will never truncate to `"IPv4 conversion..."`.
   - Widened the `IPv6 Address` card to `446px` and address text field to `300px`; anchored "Short" checkbox at `x: 365` and `Generate ULA` button inside the box at `x: 324` with zero collision.
   - Balanced middle row metrics: `Mask Bits` (130px), `Available Subnets` (280px), and `Max Hosts / Subnet` (290px).
   - Widened all 6 full-width cards (`Network`, `Address Range`, `Type`, `Hexadecimal ID`, `Dotted decimal`, `ip6.arpa`) to `722px` with inner labels and text fields expanded to `682–696px`.
   - Rebalanced two-column grid cards in IPv4 and CIDR tabs to `340px` each (20px gutter) and full cards to `700px`.
   - Widened table scrollviews in Subnets/Hosts, FLSM, and VLSM tabs to `694px` and expanded table column widths (`rangeCol` to 300px, `broadcastCol` to 180–210px) preventing table content and cloud reservation tags from clipping.
   - Enforced runtime geometry safety (`window.minSize = NSSize(width: 780, height: 694)` and `window.frame.size.width < 780` correction) in `setupModernUI()` to prevent cached `NSUserDefaults` from clipping the interface.

4. **Standard Form Defaults & Strict Upstream State Integrity Across All Tabs**:
   - Configured initial form inputs across all IPv4 tabs (`IPv4`, `Subnets/Hosts`, `FLSM`, `VLSM`) to default to standard classless `/24` (`255.255.255.0`) instead of legacy Class A `/8`. Initialized `IPv6` mask bits to standard `/64`.
   - Populated `addrField` on launch with `10.0.0.0` and automatically performed initial calculation, presenting a fully populated, modern dark UI immediately on application start.
   - **Elimination of Mask Clobbering**: In strict alignment with upstream v2.6, `addrField.stringValue` retains the pure IP address without appending `/mask` suffixes after calculation. This eliminates the mask clobbering bug where moving the Subnets/Hosts slider, selecting CIDR combos, or changing IPv6 dropdowns caused `splitAddrMask` to overwrite newly selected mask bits with stale input values.
   - **Tab State Integrity**: Eliminated disruptive automatic tab-switching overrides, preserving active user inputs, custom IP addresses, and calculation states across all 6 tabs.

5. **Hardened IPv6 Tab Interactivity & Fallback Combos**:
   - Re-engineered `changeIPv6MaskBits`, `changeIPv6Subnets`, and `changeIPv6MaxHosts` to reliably support both dropdown popup item selection and direct manual keyboard entry with strict boundary validation (1–128 bits).
   - Added automatic fallback to combo box `stringValue` when items are selected or calculated, preventing blank combo displays and ensuring the UI remains 100% synchronized with the underlying calculation engine.
   - Preserved `addrField.stringValue` purity when calculating IPv6 from converted IPv4 addresses or native IPv6 entries.

6. **Top Bar Header Alignment & About Window Badge Geometry Polish**:
   - Repositioned the RFC status pill badge directly adjacent to `addrField` (`x: 352`), restoring canonical macOS left-alignment (`x: 88`) for the `"IP Address"` label.
   - Expanded About Window version badge pill width from 110px to 140px, completely resolving badge text truncation (`v2.6.2 (Build 14)`) and establishing symmetrical centering across all four metadata badges.

7. **Intelligent IPv6 RFC Classification**:
   - Expanded `IPSubnetCalc` with `classifyIPv6Address` identifying RFC 4193 ULA (`fc00::/7`), RFC 4291 Link-Local (`fe80::/10`), Loopback (`::1`), Multicast (`ff00::/8`), Documentation (`2001:db8::/32`), and Global Unicast.
   - Upgraded status pill badges to display concise labels (`ULA`, `Private`, `Public`, `CGNAT`, `Loopback`, `Link-Local`, `Multicast`, `Reserved`) with full RFC descriptions in interactive tooltips, resolving the previous bug where IPv6 ULA addresses defaulted to "Public".

8. **Direct Top-Bar About Icon Button (`aboutIconButton`)**:
   - Added a dedicated, native `NSButton` info trigger directly positioned adjacent to the Export button (`x: 682, y: 652, width: 28, height: 25`).
   - Uses native `info.circle` symbol on macOS 11+ with fallback to `NSImage.infoName` and `ⓘ` on macOS 10.15 Catalina.
   - Dynamic tinting synchronizes `contentTintColor` with `ThemeManager.current.accentCyan` across all 25 developer theme families, triggering the custom About Window instantly from the primary user interface.

9. **Standardized Enterprise Script Headers & Author Attribution**:
   - Applied uniform developer and maintainer header comments across every Swift and Objective-C file in the project (`IPSubnetcalc.swift`, `SubnetCalcAppDelegate.swift`, `ThemeManager.swift`, `AddrHistory*`, `PrintView*`).
   - Standardized fields: Target Architecture (Apple Universal 2 Binary), Version (`v2.6.2`), Build Timestamp (`2026-10-07 05:25:30 +07:00`), Original Creator info (Julien Mulot), Maintainer contact (Harry Dertin Sutisna Alsyundawy / ALSYUNDAWY IT SOLUTION), and GPL-2.0 license headers.
