//
//  IPSubnetcalc.swift
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
//  License: GNU General Public License v2.0 (GPL-2.0)
//

import Foundation
import Cocoa

//*********************
//Errors for IP format
//*********************
enum SubnetCalcError: Error {
    case invalidIPv4(_ info: String)
    case invalidIPv4Mask(_ info: String)
    case invalidIPv6(_ info: String)
    case invalidIPv6Mask(_ info: String)
}

class IPSubnetCalc: NSObject {
    //*********
    //Constants
    //*********
    enum Constants {
        //private constants
        static let NETWORK_BITS_MIN_CLASSLESS:Int = 1
        static let NETWORK_BITS_MIN:Int = 8
        static let NETWORK_BITS_MAX:Int = 32

        //IPv6 constants
        static let addr16Full: UInt16 = 0xFFFF
        static let addr16Empty: UInt16 = 0x0000
        static let defaultIPv6to4Mask: Int = 96
        //static let addr128Full: [UInt16] = [addr16Full, addr16Full, addr16Full, addr16Full, addr16Full, addr16Full, addr16Full, addr16Full]
        //static let addr128Empty: [UInt16] = [addr16Empty, addr16Empty, addr16Empty, addr16Empty, addr16Empty, addr16Empty, addr16Empty, addr16Empty]
        //static let addr16Hex1: UInt16 = 0xF000
        //static let addr16Hex2: UInt16 = 0x0F00
        //static let addr16Hex3: UInt16 = 0x00F0
        //static let addr16Hex4: UInt16 = 0x000F
        static let resIPv6Blocks: [String: String] = ["::1/128": "Loopback Address",
                                                      "::/128": "Unspecified Address",
                                                      "::ffff:0:0/96": "IPv4-mapped Address",
                                                      "64:ff9b::/96": "IPv4-IPv6 Translation",
                                                      "64:ff9b:1::/48": "IPv4-IPv6 Translation",
                                                      "100::/64": "Discard-Only Address Block",
                                                      "2001::/23": "IETF Protocol Assignments",
                                                      "2001::/32": "TEREDO",
                                                      "2001:1::1/128": "Port Control Protocol Anycast",
                                                      "2001:1::2/128": "Traversal Using Relays around NAT Anycast",
                                                      "2001:2::/48": "Benchmarking",
                                                      "2001:3::/32": "AMT",
                                                      "2001:4:112::/48": "AS112-v6",
                                                      "2001:10::/28": "Deprecated (previously ORCHID)",
                                                      "2001:20::/28": "ORCHIDv2",
                                                      "2001:db8::/32": "Documentation",
                                                      "2002::/16": "6to4",
                                                      "2620:4f:8000::/48": "Direct Delegation AS112 Service",
                                                      "fc00::/7": "Unique-Local",
                                                      "fe80::/10": "Link-Local Unicast",
                                                      "ff00::/8": "Multicast (RFC 4291)"
        ]

        //IPv4 constants
        static let classAbits: Int = 8
        static let classBbits: Int = 16
        static let classCbits: Int = 24
        static let addr32Full: UInt32 = 0xFFFFFFFF
        static let addr32Empty: UInt32 = 0x00000000
        static let addr32Digit1: UInt32 = 0xFF000000
        static let addr32Digit2: UInt32 = 0x00FF0000
        static let addr32Digit3: UInt32 = 0x0000FF00
        static let addr32Digit4: UInt32 = 0x000000FF
        static let netIdClassA: UInt32 = 0x01000000
        static let maskClassA: UInt32 = 0xFF000000
        static let netIdClassB: UInt32 = 0x80000000
        static let maskClassB: UInt32 = 0xFFFF0000
        static let netIdClassC: UInt32 = 0xC0000000
        static let maskClassC: UInt32 = 0xFFFFFF00
        static let netIdClassD: UInt32 = 0xE0000000
        static let maskClassD: UInt32 = 0xF0000000
        static let netIdClassE: UInt32 = 0xF0000000
        static let maskClassE: UInt32 = 0xF0000000
    }

    //****************
    //Class Properties
    //****************
    var ipv4Address: String
    var maskBits: Int
    var ipv6Address: String
    var ipv6MaskBits: Int


    //*************
    //IPv4 SECTION
    //*************
    /**
     Convert an IP address in its binary representation

     - Parameters:
        - ipAddress: IP address in dotted decimal format like 192.168.1.42
        - space:  add a space to each decimal
        - dotted: add a dot to each decimal

     - Returns:
     the binary representation of the given IP address

     */
    static func binarize(ipAddress: String, space: Bool = false, dotted: Bool = true) -> String? {
        var ipAddressBin = [String]()
        var binStr = String()
        var ipDigits = [String]()

        ipDigits = ipAddress.components(separatedBy: ".")

        if ipDigits.count != 4 {
            return nil
        }
        for index in 0...3 {
            if let ipDigit = Int(ipDigits[index]) {
                ipAddressBin.append(String(ipDigit, radix: 2))
            }
            else {
                return nil
            }
            while (ipAddressBin[index].count < 8) {
                ipAddressBin[index].insert("0", at: ipAddressBin[index].startIndex)
            }

            var digitBin = ipAddressBin[index]
            if (space == true) {
                digitBin.insert(" ", at: ipAddressBin[index].index(ipAddressBin[index].startIndex, offsetBy: 4))
            }
            if (index < 3) {
                if (dotted == true) {
                    binStr += digitBin + "."
                }
                else {
                    binStr += digitBin
                }
            }
            else {
                binStr += digitBin
            }
        }
        return (binStr)
    }

    /**
     Convert the current IPv4 address to its binary representation

     - Parameter dotted: add dot to each decimal

     - Returns:
     the binary representation of the current IP address

     */
    func binaryMap(dotted: Bool = true) -> String {
        return (IPSubnetCalc.binarize(ipAddress: ipv4Address, space: false, dotted: dotted) ?? "")
    }

    /**
     Convert an IP address in its hexadecimal representation

     - Parameters:
        - ipAddress: IP address in dotted decimal format like 192.168.1.42
        - dotted: add a dot to each decimal

     - Returns:
     the hexadecimal representation of the given IP address

     */
    static func hexarize(ipAddress: String, dotted: Bool = true) -> String? {
        var ipDigits = [String]()
        var hexIP = String()
        var hex4: String

        ipDigits = ipAddress.components(separatedBy: ".")
        if ipDigits.count != 4 {
            return nil
        }
        for index in 0...3 {
            if let ipDigit = Int(ipDigits[index]) {
            hex4 = String(format: "%X", ipDigit)
            }
            else {
                return nil
            }
            if (hex4.count == 1) {
                hex4 = "0" + hex4
            }
            hexIP += hex4
            if (index < 3) {
                if (dotted == true) {
                    hexIP += "."
                }
            }
        }
        return (hexIP)
    }

    /**
     Convert the current IPv4 address to its hexadecimal representation

     - Parameter dotted: add dot to each decimal

     - Returns:
     the hexadecimal representation of the current IP address

     */
    func hexaMap(dotted: Bool = true) -> String {
        return (IPSubnetCalc.hexarize(ipAddress: ipv4Address, dotted: dotted) ?? "")
    }

    /**
     Convert an IP address in dotted decimal format to an UInt32 value

     - Parameter ipAddress: an IP address in dotted decimal format like 192.168.1.42

     - Returns:
     a digital IP address in UInt32 format

     */
    static func digitize(ipAddress: String) -> UInt32? {
        var ipAddressNum: UInt32 = 0
        var ipDigits = [String]()
        //var ipDigit: Unit32

        ipDigits = ipAddress.components(separatedBy: ".")
        if ipDigits.count != 4 {
            return nil
        }
        for index in 0...3 {
            if let ipDigit = UInt32(ipDigits[index]) {
                ipAddressNum += ipDigit << (32 - 8 * (index + 1))
            }
            else {
                return nil
            }
        }
        return (ipAddressNum & Constants.addr32Full)
    }



    /**
     Convert a mask value in bits to an UInt32 value

     - Parameter maskbits: subnet mask bits as in /XX notation

     - Returns:
     a digital subnet mask in UInt32 format

     */
    static func digitize(maskbits: Int) -> UInt32? {
        if (maskbits <= Constants.NETWORK_BITS_MAX && maskbits >= Constants.NETWORK_BITS_MIN_CLASSLESS) {
            return ((Constants.addr32Full << (32 - maskbits)) & Constants.addr32Full)
        }
        return nil
    }

    /**
     Convert an IP address in digital format to dotted decimal format

     - Parameter ipAddress: IP address in its digital format

     - Returns:
     a String reprensenting the dotted decimal format of the given IP address

     */
    static func dottedDecimal(ipAddress: UInt32) -> String {
        var ipDigits = String()

        ipDigits.append(String(((ipAddress & Constants.addr32Digit1) >> Constants.classCbits)) + ".")
        ipDigits.append(String(((ipAddress & Constants.addr32Digit2) >> Constants.classBbits)) + ".")
        ipDigits.append(String(((ipAddress & Constants.addr32Digit3) >> Constants.classAbits)) + ".")
        ipDigits.append(String(((ipAddress & Constants.addr32Digit4))))
        return (ipDigits)
    }

    /**
     Check if the IP address is a valid IPv4 address

     - Parameters:
        - ipAddress: IP address in dotted decimal format like 192.168.1.42
        - mask: Optionnal subnet mask
        - classless: enable class less checks of the given IP address/mask

     - Throws: an invalid IP or invalid mask error with a message explaining the reason

     */
    static func validateIPv4(ipAddress: String, mask: String?, classless: Bool = false) throws {
        var ip4Digits = [String]()

        ip4Digits = ipAddress.components(separatedBy: ".")
        if (ip4Digits.count == 4) {
            for item in ip4Digits {
                if let digit = Int(item, radix: 10) {
                    if (digit < 0 || digit > 255) {
                        print("bad IPv4 digit \(digit)")
                        throw SubnetCalcError.invalidIPv4("IPv4 digit \(digit) must be between 0 and 255")
                    }
                    if item.hasPrefix("+") || item.contains(" ") {
                        throw SubnetCalcError.invalidIPv4("IPv4 digit \(item) contains invalid characters")
                    }
                }
                else {
                    print("not digit: \(item)")
                    throw SubnetCalcError.invalidIPv4("not digit: \(item)")
                }
            }
        }
        else {
            print("bad IPv4 format \(ip4Digits)")
            throw SubnetCalcError.invalidIPv4("\(ipAddress) too short or too long")
            //return false
        }
        if let maskStr = mask {
            if let maskNum = Int(maskStr) {
                if classless {
                    if maskNum < Constants.NETWORK_BITS_MIN_CLASSLESS || maskNum > Constants.NETWORK_BITS_MAX {
                        print("IPv4 classless mask \(maskNum) invalid")
                        throw SubnetCalcError.invalidIPv4Mask("IPv4 classless mask \(maskNum) should be between \(Constants.NETWORK_BITS_MIN_CLASSLESS) and \(Constants.NETWORK_BITS_MAX)")
                    }
                } else if maskNum < Constants.NETWORK_BITS_MIN || maskNum > Constants.NETWORK_BITS_MAX {
                    print("IPv4 mask \(maskNum) invalid")
                    throw SubnetCalcError.invalidIPv4Mask("IPv4 mask \(maskNum) should be between \(Constants.NETWORK_BITS_MIN) and \(Constants.NETWORK_BITS_MAX)")
                }
            } else {
                print("IPv4 mask \(maskStr) is not digit")
                throw SubnetCalcError.invalidIPv4Mask("IPv4 mask \(maskStr) is not a digit")
            }
        }
        //return true
    }

    /**
     Returns current Subnet ID address

     - Returns:
     the dotted decimal representation of the Subnet ID of the current IP address/mask

     */
    func subnetId() -> String {
        var subnetId: UInt32 = 0
        let ipBits = IPSubnetCalc.digitize(ipAddress: self.ipv4Address) ?? 0
        let maskBits = IPSubnetCalc.digitize(maskbits: self.maskBits) ?? 0

        subnetId = ipBits & maskBits
        return (IPSubnetCalc.dottedDecimal(ipAddress: subnetId))
    }

    /**
     Returns current broadcast address

     - Returns:
     the dotted decimal representation of the broadcast address of the current IP address/mask

     */
    func subnetBroadcast() -> String {
        var broadcast: UInt32 = 0
        let ipBits = IPSubnetCalc.digitize(ipAddress: self.ipv4Address) ?? 0
        let maskBits = IPSubnetCalc.digitize(maskbits: self.maskBits) ?? 0

        let hostBits = (self.maskBits >= 0 && self.maskBits <= 32) ? (Constants.addr32Full >> self.maskBits) : 0
        broadcast = (ipBits & maskBits) | hostBits
        return (IPSubnetCalc.dottedDecimal(ipAddress: broadcast))
    }

    /**
     Returns current Subnet Mask

     - Returns:
    String of the current subnet mask as in /XX notation

     */
    func subnetMask() -> String {
        var subnetMask: UInt32 = 0

        subnetMask = Constants.addr32Full << (32 - self.maskBits)
        return (IPSubnetCalc.dottedDecimal(ipAddress: subnetMask))
    }

    /**
     Returns current Wildcard Subnet Mask

     - Returns:
     the dotted decimal representation of the wildcard subnet mask of the current IP address/mask

     */
    func wildcardMask() -> String {
        var wildcardMask: UInt32 = 0

        wildcardMask = ~(Constants.addr32Full << (32 - self.maskBits))
        return (IPSubnetCalc.dottedDecimal(ipAddress: wildcardMask))
    }

    /**
     Returns the maximum hosts in the current subnet

     - Returns:
     maximum hosts for the current mask

     */
    func maxHosts() -> Int {
        if (self.maskBits == 31) {
            // RFC 3021: 31-Bit Prefixes on IPv4 Point-to-Point Links (2 usable host addresses)
            return (2)
        }
        if (self.maskBits == 32) {
            return (0)
        }
        let maxHosts = (Constants.addr32Full >> self.maskBits) - 1
        return (Int(maxHosts))
    }

    /**
     Returns the maximum CIDR subnets

     - Returns:
     maximum CIDR subnets for the current mask

     */
    func maxCIDRSubnets() -> Int {
        var max: Int = 0

        max = Int(truncating: NSDecimalNumber(decimal: pow(2, (32 - self.maskBits))))
        //max = Int(truncating: pow(2, (32 - self.maskBits)) as NSDecimalNumber)
        return (max)
    }

    /**
     Returns the maximum CIDR Supernets

     - Returns:
     maximum CIDR Supernets for the current mask

     */
    func maxCIDRSupernet() -> Int {
        let classType = self.netClass()
        var result: Decimal

        if (classType == "A") {
            if (Constants.classAbits - self.maskBits > 0) {
                result = pow(2, Constants.classAbits - self.maskBits)
                return (Int(truncating: NSDecimalNumber(decimal: result)))
            }
        }
        else if (classType == "B") {
            if (Constants.classBbits - self.maskBits > 0) {
                result = pow(2, Constants.classBbits - self.maskBits)
                return (Int(truncating: NSDecimalNumber(decimal: result)))
            }
        }
        else if (classType == "C") {
            if (Constants.classCbits - self.maskBits > 0) {
                result = pow(2, Constants.classCbits - self.maskBits)
                return (Int(truncating: NSDecimalNumber(decimal: result)))
            }
        }
        return (1)
    }

    /**
     Returns the current subnet IP Range

     - Returns:
     First IP address - Last IP address of the current IP address/mask

     */
    func subnetRange() -> String {
        guard let first = IPSubnetCalc.digitize(ipAddress: subnetId()),
              let last = IPSubnetCalc.digitize(ipAddress: subnetBroadcast()) else {
            return ""
        }
        let firstIP: UInt32
        let lastIP: UInt32
        if maskBits == 31 || maskBits == 32 {
            firstIP = first
            lastIP = last
        } else {
            firstIP = first + 1
            lastIP = (last > 0) ? last - 1 : 0
        }
        return "\(IPSubnetCalc.dottedDecimal(ipAddress: firstIP)) - \(IPSubnetCalc.dottedDecimal(ipAddress: lastIP))"
    }

    /**
     Returns the usable host range according to the selected Cloud Provider reservation profile
     */
    func subnetRange(profile: CloudProfile) -> String {
        if maskBits > profile.minimumPrefix {
            return "Prohibited by \(profile.rawValue) (Minimum: /\(profile.minimumPrefix))"
        }
        guard let net = IPSubnetCalc.digitize(ipAddress: subnetId()),
              let usable = profile.usableRange(network: net, prefix: maskBits) else {
            return subnetRange()
        }
        return "\(IPSubnetCalc.dottedDecimal(ipAddress: usable.start)) - \(IPSubnetCalc.dottedDecimal(ipAddress: usable.end))"
    }

    /**
     Returns the count of usable hosts under the selected Cloud Provider reservation profile
     */
    func maxHosts(profile: CloudProfile) -> String {
        if maskBits > profile.minimumPrefix {
            return "0 (Prohibited)"
        }
        guard let net = IPSubnetCalc.digitize(ipAddress: subnetId()),
              let usable = profile.usableRange(network: net, prefix: maskBits) else {
            return String(maxHosts())
        }
        return String(usable.count)
    }

    /**
     Returns the current CIDR subnet IP Range

     - Returns:
     First IP address - Last IP address of the current CIDR IP address/mask

     */
    func subnetCIDRRange() -> String {
        guard let first = IPSubnetCalc.digitize(ipAddress: subnetId()),
              let last = IPSubnetCalc.digitize(ipAddress: subnetBroadcast()) else {
            return ""
        }
        return "\(IPSubnetCalc.dottedDecimal(ipAddress: first)) - \(IPSubnetCalc.dottedDecimal(ipAddress: last))"
    }

    /**
     Returns the Network Class of an IP address

     - Parameter ipAddress: IPv4 address in dotted decimal format

     - Returns:
     Network Class conforming to RFC 790

     */
    static func netClass(ipAddress: String) -> String? {
        if let ipNum = IPSubnetCalc.digitize(ipAddress: ipAddress) {
        let addr1stByte = (ipNum & Constants.maskClassA) >> 24

        if (addr1stByte <= 127) {
            return ("A")
        }
        if (addr1stByte >= 128 && addr1stByte < 192) {
            return ("B")
        }
        if (addr1stByte >= 192 && addr1stByte < 224) {
            return ("C")
        }
        if (addr1stByte >= 224 && addr1stByte < 240) {
            return ("D")
        }
        return ("E")
        }
        return nil
    }

    /**
     Returns the Network Class of the current IP address

     - Returns:
     Network Class of the current IP address conforming to RFC 790

     */
    func netClass() -> String {
        return IPSubnetCalc.netClass(ipAddress: ipv4Address) ?? "C"
    }

    /**
     Returns the bits dedicated to the Subnet part of the IP Address

     - Returns:
     bits dedicated to the Subnet part of the current IP Address

     */
    func subnetBits() -> Int {
        let classType = self.netClass()
        var bits: Int = 0

        if (classType == "A") {
            if (self.maskBits > Constants.classAbits) {
                bits = self.maskBits - Constants.classAbits
            }
        }
        else if (classType == "B") {
            if (self.maskBits > Constants.classBbits) {
                bits = self.maskBits - Constants.classBbits
            }
        }
        else if (classType == "C") {
            if (self.maskBits > Constants.classCbits) {
                bits = self.maskBits - Constants.classCbits
            }
        }
        return (bits)
    }

    /**
     Returns the bits dedicated to Network Class

     - Returns:
     bits dedicated to the Network Class of the current IP address

     */
    func classBits() -> Int {
        let classType = self.netClass()

        if (classType == "A") {
            return (Constants.classAbits)
        }
        else if (classType == "B") {
            return (Constants.classBbits)
        }
        else if (classType == "C") {
            return (Constants.classCbits)
        }
        return (32)
    }

    /**
     Returns the mask bits for the Network Class

     - Returns:
     mask bits dedicated for the Network Class of the current IP address

     */
    func classMask() -> UInt32 {
        let classType = self.netClass()

        if (classType == "A") {
            return (Constants.maskClassA)
        }
        else if (classType == "B") {
            return (Constants.maskClassB)
        }
        else if (classType == "C") {
            return (Constants.maskClassC)
        }
        else if (classType == "D") {
            return (Constants.maskClassD)
        }
        else if (classType == "E") {
            return (Constants.maskClassE)
        }
        return (Constants.maskClassE)
    }

    /**
     Returns the number of bits of the mask

     - Parameter maskAddr: mask in dotted decimal format

     - Returns:
     the number of bits for the given mask

     */
    static func maskBits(maskAddr: String) -> Int? {
        var bits: Int = 0

        if var mask:UInt32 = IPSubnetCalc.digitize(ipAddress: maskAddr) {
        while (mask != 0) {
            bits += 1
            mask <<= 1
        }
        //print("maskBits \(maskAddr) bits: \(bits)")
        return (bits)
        }
        return nil
    }

    /**
     Returns the number of bits of the mask

     - Parameter mask: mask in digitize format

     - Returns:
     the number of bits for the given mask

     */
    static func maskBits(mask: UInt32) -> Int {
        var bits: Int = 0
        var tmpmask = mask

        while (tmpmask != 0) {
            bits += 1
            tmpmask <<= 1
        }
        //print("maskBits \(mask) bits: \(bits)")
        return (bits)
    }

    /**
     Returns the number of bits dedicated to Network

     - Returns:
     number of bits dedicated to the Network of the current IP address

     */
    func netBits() -> Int {
        let classType = self.netClass()
        var bits: Int = 0

        if (classType == "A") {
            if (self.maskBits > Constants.classAbits) {
                bits =  Constants.classAbits
            }
            else {
                bits = self.maskBits
            }
        }
        else if (classType == "B") {
            if (self.maskBits > Constants.classBbits) {
                bits = Constants.classBbits
            }
            else {
                bits = self.maskBits
            }
        }
        else if (classType == "C") {
            if (self.maskBits > Constants.classCbits) {
                bits = Constants.classCbits
            }
            else {
                bits = self.maskBits
            }
        }
        return (bits)
    }

    /**
     Returns the maximum number of subnets

     - Returns:
     maximum number of subnets for the current Subnet bits

     */
    func maxSubnets() -> Int {
        var maxSubnets: Int = 0

        let bits = subnetBits()
        maxSubnets = Int(truncating: NSDecimalNumber(decimal: pow(2, bits)))
        return (maxSubnets)
    }

    /**
     Returns the Bit Map representation

     - Parameter dotted: add dot at each decimal

     - Returns:
     Bit Map reprensenation of the current ip address/mask

     */
    func bitMap(dotted: Bool = true) -> String {
        let netBits = self.netBits()
        let subnetBits = self.subnetBits()
        var bitMap = String()

        for index in 0...31 {
            if (index < netBits) {
                bitMap.append("n")
            }
            else if (index < (netBits + subnetBits)) {
                bitMap.append("s")
            }
            else {
                bitMap.append("h")
            }
            if ((index < 31) && ((index + 1) % 8 == 0)) {
                if (dotted == true) {
                    bitMap.append(".")
                }
            }
        }
        return (bitMap)
    }

    /**
     Returns maskbits and number of max hosts for a requested number of hosts

     - Parameter hosts: number of requested hosts

     - Returns: maskbits and number of max hosts for the requested number of hosts

     */
    static func fittingSubnet(hosts: UInt) -> (Int, UInt) {
        var maxHosts: UInt

        for index in 1...31 {
            maxHosts = UInt(truncating: NSDecimalNumber(decimal: pow(2, index))) - 2
            if (hosts <= maxHosts) {
                return (32 - index, maxHosts)
            }
        }
        return (0, 0)
    }

    /**
     Display IP informations of the current IP address/mask
     */
    func displayIPInfo() {
        print("IP Host : " + self.ipv4Address)
        print("Mask bits : \(self.maskBits)")
        print("Mask : " + self.subnetMask())
        print("Subnet bits : \(self.subnetBits())")
        print("Subnet ID : " + self.subnetId())
        print("Broadcast : " + self.subnetBroadcast())
        print("Max Host : \(self.maxHosts())")
        print("Max Subnet : \(self.maxSubnets())")
        print("Subnet Range : " + self.subnetRange())
        print("IP Class Type : " + self.netClass())
        print("Hexa IP : " + self.hexaMap())
        print("Binary IP : " + self.binaryMap())
        print("BitMap : " + self.bitMap())
        print("CIDR Netmask : " + self.subnetMask())
        print("Wildcard Mask : " + self.wildcardMask())
        print("CIDR Max Subnet : \(self.maxCIDRSubnets())")
        print("CIDR Max Hosts : \(self.maxHosts())")
        print("CIDR Network (Route) : " + self.subnetId())
        print("CIDR Net Notation : " + self.subnetId() + "/" + String(self.maskBits))
        print("CIDR Address Range : " + self.subnetCIDRRange())
        print("IP number in binary : " + String(IPSubnetCalc.digitize(ipAddress: self.ipv4Address) ?? 0, radix: 2))
        print("Mask bin : " + String(IPSubnetCalc.digitize(maskbits: self.maskBits) ?? 0, radix: 2))
        //print("Subnet ID bin : " + String(self.subnetId(), radix: 2))
        //print("Broadcast bin : " + String(self.subnetBroadcast(), radix: 2))
    }

    //*************
    //IPv6 SECTION
    //*************
    /**
     Check if the IP address is a valid IPv6 address

     - Parameters:
        - ipAddress: IPv6 address in hexadecimal format
        - mask: Optionnal subnet mask

     - Returns:
     Boolean if the given IPv6 address is valid or not

     */
    static func validateIPv6(ipAddress: String, mask: Int?) throws {
        if let maskVal = mask {
            if maskVal < 1 || maskVal > 128 {
                print("mask \(maskVal) invalid")
                throw SubnetCalcError.invalidIPv6Mask("mask \(maskVal) must be between 1 and 128")
            }
        }

        let segments = ipAddress.components(separatedBy: ":")
        if segments.count != 8 {
            if ipAddress.contains("::") {
                if ipAddress.components(separatedBy: "::").count > 2 {
                    throw SubnetCalcError.invalidIPv6("too many ::")
                }
            } else {
                throw SubnetCalcError.invalidIPv6("short IPv6 address must contain ::")
            }
        }
        for segment in segments {
            if segment.count > 4 && !segment.isEmpty {
                throw SubnetCalcError.invalidIPv6("\(segment) segment is too large")
            }
            if let hexVal = UInt16(segment, radix: 16) {
                if hexVal > 0xFFFF {
                    throw SubnetCalcError.invalidIPv6("\(hexVal) segment must be between 0 and 0xFFFF")
                }
            } else {
                if !segment.isEmpty {
                    throw SubnetCalcError.invalidIPv6("\(segment) segment is not an integer")
                }
            }
        }
    }

    /**
     Convert an IPv4 address to its IPv6 address

     - Parameters:
        - ipAddress: IPv4 address in dotted decimal format
        - _6to4: Use 6to4 representation

     - Returns:
     translated IPv6 address

     */
    static func convertIPv4toIPv6(ipAddress: String, _6to4: Bool = false) -> String {
        var ipv6str = String()

        if let addr = digitize(ipAddress: ipAddress) {
        ipv6str.append(String((((Constants.addr32Digit1 | Constants.addr32Digit2) & addr) >> 16), radix: 16))
        ipv6str.append(":")
        ipv6str.append(String(((Constants.addr32Digit3 | Constants.addr32Digit4) & addr), radix: 16))
        if (_6to4)
        {
            return ("2002:" + ipv6str + ":0:0:0:0:0")
        }
        return ("0:0:0:0:0:ffff:" + ipv6str)
        }
        else {
            return ""
        }
    }

    /**
     Convert an IPv6 address to its IPv4 address

     - Parameter ipAddress: IPv6 address in hexadecimal format

     - Returns:
     translated IPv4 address and detected translation method (6to4 or IPv4-Mapped)

     */
    static func convertIPv6toIPv4(ipAddress: String) -> (String, String) {
        // Handle RFC 4291 section 2.5.5.2 embedded dotted IPv4 format (e.g. ::ffff:192.0.2.1)
        if ipAddress.contains(".") {
            if let lastColon = ipAddress.lastIndex(of: ":") {
                let candidate = String(ipAddress[ipAddress.index(after: lastColon)...])
                if candidate.components(separatedBy: ".").count == 4 {
                    let method = ipAddress.hasPrefix("2002") ? "6to4" : "IPv4-Mapped"
                    return (candidate, method)
                }
            }
        }

        let ip4Hex = ipAddress.components(separatedBy: ":")
        let index = ip4Hex.count
        if ip4Hex.first == "2002" {
            var ipv4str = ""
            if index > 2 {
                let hex1 = UInt32(ip4Hex[1], radix: 16) ?? 0
                let hex2 = UInt32(ip4Hex[2], radix: 16) ?? 0
                let byte1 = (hex1 & Constants.addr32Digit3) >> 8
                let byte2 = hex1 & Constants.addr32Digit4
                let byte3 = (hex2 & Constants.addr32Digit3) >> 8
                let byte4 = hex2 & Constants.addr32Digit4
                ipv4str = "\(byte1).\(byte2).\(byte3).\(byte4)"
            }
            return (ipv4str.isEmpty ? "0.0.0.0" : ipv4str, "6to4")
        }
        else {
            var ipv4str = ""
            if index >= 2 {
                let hex1 = UInt32(ip4Hex[index - 2], radix: 16) ?? 0
                let hex2 = UInt32(ip4Hex[index - 1], radix: 16) ?? 0
                let byte1 = (hex1 & Constants.addr32Digit3) >> 8
                let byte2 = hex1 & Constants.addr32Digit4
                let byte3 = (hex2 & Constants.addr32Digit3) >> 8
                let byte4 = hex2 & Constants.addr32Digit4
                ipv4str = "\(byte1).\(byte2).\(byte3).\(byte4)"
            }
            else {
                ipv4str = "0.0.0.0"
            }
            return (ipv4str, "IPv4-Mapped")
        }
    }

    /**
     Convert an IPv6 address in hexadecimal format to its digital format

     - Parameter ipAddress: an IPv6 address in hexadecimal format. Must be in full format.

     - Returns:
     UInt16 array of each digitized IPv6 address hexa segments

     */
    static func digitizeIPv6(ipAddress: String) -> [UInt16] {
        var ipAddressNum: [UInt16] = Array(repeating: 0, count: 8)
        let fullAddr = IPSubnetCalc.fullAddressIPv6(ipAddress: ipAddress)
        let ip4Hex = fullAddr.components(separatedBy: ":")
        for index in 0..<min(8, ip4Hex.count) {
            ipAddressNum[index] = UInt16(ip4Hex[index], radix: 16) ?? 0
        }
        return (ipAddressNum)
    }

    /**
     Convert an IPv6 address in its binary representation

     - Parameters:
        - ipAddress: IPv6 address in hexadecimal format
        - delimiter: add ':' to each hexa segment

     - Returns:
     the binary representation of the given IPv6 address
     */
    static func binarizeIPv6(ipAddress: String, delimiter: Bool = false) -> String {
        let fullAddr = IPSubnetCalc.fullAddressIPv6(ipAddress: ipAddress)
        let ip4Hex = fullAddr.components(separatedBy: ":")
        guard ip4Hex.count == 8 else { return "" }
        var binStr = ""
        for index in 0...7 {
            let val = UInt16(ip4Hex[index], radix: 16) ?? 0
            var binary = String(val, radix: 2)
            while binary.count < 16 {
                binary.insert("0", at: binary.startIndex)
            }
            binStr.append(binary)
            if delimiter && index < 7 {
                binStr.append(":")
            }
        }
        return binStr
    }

    /**
     Convert an IPv6 mask value in bits to its digitized UInt16 array value

     - Parameter maskbits: subnet mask bits as in /XX notation

     - Returns:
     a digital subnet mask in [UInt16] format

     */
    static func digitizeMaskIPv6(maskbits: Int) -> [UInt16] {
        var maskNum: [UInt16] = Array(repeating: 0, count: 8)

        for i in 0...7 {
            //print("Index : \(i), mask bits : \(maskbits - (16 * (i + 1)) >= 0 ? 16 : (maskbits % (16 * i)) < maskbits ? (maskbits % (16 * i)) : 0) Div : \(maskbits / (16 * (i + 1))) Mod : \(maskbits % (16 * (i + 1)))")
            if ((maskbits - (16 * i)) < 16) {
                if ((maskbits - (16 * i)) > 0) {
                    maskNum[i] = UInt16(Constants.addr16Full & (Constants.addr16Full << (16 - (maskbits - (16 * i)))))
                }
                else {
                    //print("Index : \(i), ZERO mask  : \(maskNum[i])")
                }
            }
            else {
                maskNum[i] = Constants.addr16Full
            }
        }
        return (maskNum)
    }

    /**
     Convert a digitized IPv6 address in its hexadecimal representation

     - Parameters:
        - num: IPv6 address in its digitized format
        - full: return a full representation (non compact) of the IPv6 address
        - column: add ':' at each hexa segment

     - Returns:
     the hexadecimal representation of the given IPv6 address

     */
    static func hexarizeIPv6(num: [UInt16], full: Bool = true, column: Bool = false) -> String {
        var hex: String
        var hexStr = String()

        for index in 0...(num.count - 1) {
            hex = String(num[index], radix: 16)
            while (hex.count < 4 && full) {
                hex.insert("0", at: hex.startIndex)
            }
            hexStr.append(hex)
            if (column && index < (num.count - 1)) {
                hexStr.append(":")
            }
        }
        return (hexStr)
    }

    /**
     Returns the Hexadecimal ID of IPv6 address

     - Returns:
     the hexadecimal ID of the current IPv6 address

     */
    func hexaIDIPv6() -> String {
        var hexID: String = IPSubnetCalc.fullAddressIPv6(ipAddress: self.ipv6Address)
        let delimiter: Set<Character> = [":"]
        hexID.removeAll(where: { delimiter.contains($0) })
        return("0x\(hexID)")
    }

    /**
     Returns the binary representation of IPv6 address

     - Returns:
     the binary representation of the current IPv6 address

     */
    func binaryIDIPv6() -> String {
        return (IPSubnetCalc.binarizeIPv6(ipAddress: self.ipv6Address))
    }

    /**
     Convert a IPv6 address to its long notation

     - Parameter ipAddress: IPv6 address in hexadecimal format

     - Returns:
     the long notation (non compact) of the given IPv6 address

     */
    static func fullAddressIPv6(ipAddress: String) -> String {
        var fullAddr = String()
        var ip4Hex = [String]()
        var prevIsZero = false

        ip4Hex = ipAddress.components(separatedBy: ":")
        for index in 0...(ip4Hex.count - 1) {
            //print("Index : \(index) Hex :  \(ip4Hex[index])")
            if (ip4Hex[index] == "" && !prevIsZero) {
                prevIsZero = true
                //print("Index : \(index + 1) is empty, \(8 - ip4Hex.count  + 1) hex quad are missing")
                while (ip4Hex[index].count < (4 * (8 - ip4Hex.count  + 1))) {
                    ip4Hex[index].insert("0", at: ip4Hex[index].startIndex)
                }
            }
            else {
                while (ip4Hex[index].count < 4) {
                    ip4Hex[index].insert("0", at: ip4Hex[index].startIndex)
                }
            }
            fullAddr.append(ip4Hex[index])
        }
        guard fullAddr.count == 32 else { return ipAddress }
        var offset = fullAddr.index(fullAddr.startIndex, offsetBy: 4)
        for _ in 1...7 {
            fullAddr.insert(":", at: offset)
            offset = fullAddr.index(offset, offsetBy: 5)
        }
        return fullAddr
    }

    /**
     Convert an IPv6 address to its compact/short notation conforming to RFC 5952

     - Parameter ipAddress: IPv6 address in hexadecimal format

     - Returns:
     the canonical compact notation of the given IPv6 address

     */
    static func compactAddressIPv6(ipAddress: String) -> String {
        let full = IPSubnetCalc.fullAddressIPv6(ipAddress: ipAddress)
        let quads = full.components(separatedBy: ":")
        guard quads.count == 8 else { return ipAddress }

        let words: [UInt16] = quads.compactMap { UInt16($0, radix: 16) }
        guard words.count == 8 else { return ipAddress }

        // Find longest run of consecutive zeros (RFC 5952 Section 4.2)
        var bestStart = -1
        var bestLen = 0
        var curStart = -1
        var curLen = 0

        for (index, word) in words.enumerated() {
            if word == 0 {
                if curStart == -1 {
                    curStart = index
                    curLen = 1
                } else {
                    curLen += 1
                }
            } else {
                if curLen > bestLen {
                    bestLen = curLen
                    bestStart = curStart
                }
                curStart = -1
                curLen = 0
            }
        }
        if curLen > bestLen {
            bestLen = curLen
            bestStart = curStart
        }

        // RFC 5952 Section 4.2.2: The symbol "::" MUST NOT be used to shorten just one 16-bit 0 field.
        if bestLen < 2 {
            return words.map { String($0, radix: 16) }.joined(separator: ":")
        }

        if bestLen == 8 {
            return "::"
        }

        var parts = [String]()
        var idx = 0
        while idx < 8 {
            if idx == bestStart {
                parts.append("")
                idx += bestLen
            } else {
                parts.append(String(words[idx], radix: 16))
                idx += 1
            }
        }

        if bestStart == 0 {
            return ":" + parts.joined(separator: ":")
        } else if bestStart + bestLen == 8 {
            return parts.joined(separator: ":") + ":"
        } else {
            return parts.joined(separator: ":")
        }
    }

    /**
     Returns IPv6 Network address

     - Returns:
     the Network address in hexadecimal format of the current IPv6 address

     */
    func networkIPv6() -> String {
        var netID = [UInt16]()
        let numMask = IPSubnetCalc.digitizeMaskIPv6(maskbits: self.ipv6MaskBits)
        let numIP = IPSubnetCalc.digitizeIPv6(ipAddress: self.ipv6Address)

        for index in 0...7 {
            //print("Index: \(index) IP: \(numIP[index]) Mask : \(numMask[index]) Result : \(numIP[index] & (numMask[index])) ")
            netID.append((numIP[index] & numMask[index]))
        }
        return (IPSubnetCalc.hexarizeIPv6(num: netID, full: false, column: true))
    }

    /**
     Returns IPv6 Network Range

     - Returns:
     First IPv6 address - Last IPv6 address of the current IPv6 address/mask

     */
    func networkRangeIPv6() -> String {
        var netID = [UInt16]()
        var netID2 = [UInt16]()
        let numMask = IPSubnetCalc.digitizeMaskIPv6(maskbits: self.ipv6MaskBits)
        let numIP = IPSubnetCalc.digitizeIPv6(ipAddress: self.ipv6Address)

        for index in 0...7 {
            //print("Index: \(index) IP: \(numIP[index]) Mask : \(numMask[index]) Result : \(numIP[index] & (numMask[index])) ")
            netID.append((numIP[index] & numMask[index]))
        }
        for index in 0...7 {
            //print("Index: \(index) IP: \(numIP[index]) Mask : \(numMask[index]) Result : \(numIP[index] & (numMask[index])) ")
            netID2.append((numIP[index] | ~numMask[index]))
        }
        var netIDStr = IPSubnetCalc.hexarizeIPv6(num: netID, full: true, column: true)
        netIDStr.append(" - \(IPSubnetCalc.hexarizeIPv6(num: netID2, full: true, column: true))")
        return (netIDStr)
    }

    /**
     Returns Total IP addresses for IPv6

     - Returns:
     Total IP addresses for the current IPv6 mask

     */
    func totalIPAddrIPv6() -> Decimal {
        var total = Decimal()
        var number: Decimal = 2

        NSDecimalPower(&total, &number , (128 - self.ipv6MaskBits), NSDecimalNumber.RoundingMode.plain)
        return (total)
    }

    /**
     Returns IPv6 address in dotted decimal format

     - Returns:
     IPv6 address in dotted decimal format of the current IPv6 address

     */
    func dottedDecimalIPv6() -> String {
        var ipv4str = String()

        let ip4Hex = IPSubnetCalc.fullAddressIPv6(ipAddress: self.ipv6Address).components(separatedBy: ":")
        for index in 0..<ip4Hex.count {
            if index != 0 {
                ipv4str.append(".")
            }
            if ip4Hex[index].isEmpty {
                ipv4str.append("0.0")
            } else {
                let val = UInt32(ip4Hex[index], radix: 16) ?? 0
                ipv4str.append(String((val & Constants.addr32Digit3) >> 8))
                ipv4str.append("." + String(val & Constants.addr32Digit4))
            }
        }
        return ipv4str
    }

    /**
     Returns IPv6 address in IP6 ARPA notation

     - Returns:
     IPv6 address in IP6 ARPA notation of the current IPv6 address

     */
    func ip6ARPA () -> String {
        var ipARPA = IPSubnetCalc.fullAddressIPv6(ipAddress: self.ipv6Address)
        let delimiter: Set<Character> = [":"]

        ipARPA.removeAll(where: { delimiter.contains($0) })
        guard ipARPA.count == 32 else { return "" }
        ipARPA = String(ipARPA.reversed())

        var offset = ipARPA.index(ipARPA.startIndex, offsetBy: 1)
        for _ in 0...(ipARPA.count - 2) {
            ipARPA.insert(".", at: offset)
            offset = ipARPA.index(offset, offsetBy: 2)
        }
        ipARPA.append(".ip6.arpa")
        return (ipARPA)
    }

    /**
     Returns the reserved IPv6 block name if it exists

     - Returns:
      reserved IPv6 block name or nil if it does not exist

     */
    func resBlockIPv6() -> String? {
        var netID = networkIPv6()

        netID = IPSubnetCalc.fullAddressIPv6(ipAddress: netID)
        //print("NetID BEFORE compact : \(netID)")
        netID = IPSubnetCalc.compactAddressIPv6(ipAddress: netID)
        //print("NetID AFTER compact : \(netID)")
        netID.append("/\(self.ipv6MaskBits)")

        for item in Constants.resIPv6Blocks {
            if (item.key == netID) {
                return (item.value + " (\(item.key))")
            }
        }
        return nil
    }

    /**
     Initialize an IPv4 object

     - Parameters:
        - ipAddress: IPv4 address in its dotted decimal format
        - maskbits: number of mask bits as in /XX notation

     - Returns:
     nil if the IPv4 address or mask is not valid

     */
    init?(ipAddress: String, maskbits: Int) {
        do {
        try IPSubnetCalc.validateIPv4(ipAddress: ipAddress, mask: String(maskbits), classless: true)
            self.ipv4Address = ipAddress
            self.maskBits = maskbits
            self.ipv6Address = IPSubnetCalc.convertIPv4toIPv6(ipAddress: ipAddress)
            self.ipv6MaskBits = maskbits + Constants.defaultIPv6to4Mask
        }
        catch {
            print("Init error: \(error)")
            return nil
        }
    }

    /**
     Initialize an IPv4 object with the default mask of its network class

     - Parameters:
        - ipAddress: IPv4 address in its dotted decimal format

     - Returns:
     nil if the IPv4 address is not valid

     */
    convenience init?(_ ipAddress: String) {
        var classbit: Int

        do {
            try IPSubnetCalc.validateIPv4(ipAddress: ipAddress, mask: nil)
            switch (IPSubnetCalc.netClass(ipAddress: ipAddress)) {
            case "A":
                classbit = Constants.classAbits
            case "B":
                classbit = Constants.classBbits
            case "C":
                classbit = Constants.classCbits
            default:
                classbit = Constants.classAbits
            }
            self.init(ipAddress: ipAddress, maskbits: classbit)
        }
        catch {
            print("Init error: \(error)")
            return nil
        }
    }

    /**
     Initialize an IPv6 object

     - Parameters:
        - ipv6: IPv6 address in its hexadecimal format
        - maskbits: number of mask bits as in /XX notation

     - Returns:
     nil if the IPv6 address or mask is not valid

     */
    init?(ipv6: String, maskbits: Int) {
        do {
        try IPSubnetCalc.validateIPv6(ipAddress: ipv6, mask: maskbits)
            (self.ipv4Address, _) = IPSubnetCalc.convertIPv6toIPv4(ipAddress: ipv6)
            if (maskbits >= (Constants.defaultIPv6to4Mask + Constants.classAbits)) {
                self.maskBits = maskbits - Constants.defaultIPv6to4Mask
            }
            else {
                self.maskBits = Constants.classAbits
            }

            // full ? compact ? validated ?
            self.ipv6Address = ipv6
            self.ipv6MaskBits = maskbits
            //print("init IPv6 ipv6 addr: \(self.ipv6Address) ipv4 addr: \(self.ipv4Address)")
        }
        catch {
            print("Init error: \(error)")
            return nil
        }
    }
}

// MARK: - Multi-Cloud Subnet Reservation Profiles
public struct UsableHostRange: Equatable, Codable {
    public let start: UInt32
    public let end: UInt32
    public let count: UInt32

    public init(start: UInt32, end: UInt32, count: UInt32) {
        self.start = start
        self.end = end
        self.count = count
    }
}

public enum CloudProfile: String, CaseIterable, Codable {
    case standard = "Standard (RFC 1918)"
    case aws = "AWS VPC"
    case azure = "Azure VNet"
    case gcp = "Google Cloud (GCP)"
    case oci = "Oracle Cloud (OCI)"

    public var minimumPrefix: Int {
        switch self {
        case .standard: return 32
        case .aws: return 28
        case .azure: return 29
        case .gcp: return 29
        case .oci: return 30
        }
    }

    public func reservedCount(for prefix: Int) -> Int {
        if prefix > self.minimumPrefix { return 0 }
        switch self {
        case .standard:
            return (prefix <= 30) ? 2 : 0
        case .aws:
            return 5
        case .azure:
            return 5
        case .gcp:
            return 4
        case .oci:
            return 3
        }
    }

    public func usableRange(network: UInt32, prefix: Int) -> UsableHostRange? {
        guard prefix >= 1 && prefix <= self.minimumPrefix else { return nil }
        let totalHosts: UInt32 = (prefix == 32) ? 1 : UInt32(1 << (32 - prefix))
        let broadcast = network + totalHosts - 1

        switch self {
        case .standard:
            if prefix == 31 {
                return UsableHostRange(start: network, end: broadcast, count: 2)
            } else if prefix == 32 {
                return UsableHostRange(start: network, end: network, count: 1)
            } else {
                return UsableHostRange(start: network + 1, end: broadcast - 1, count: totalHosts - 2)
            }
        case .aws:
            return UsableHostRange(start: network + 4, end: broadcast - 1, count: totalHosts - 5)
        case .azure:
            return UsableHostRange(start: network + 4, end: broadcast - 1, count: totalHosts - 5)
        case .gcp:
            return UsableHostRange(start: network + 2, end: broadcast - 2, count: totalHosts - 4)
        case .oci:
            return UsableHostRange(start: network + 2, end: broadcast - 1, count: totalHosts - 3)
        }
    }

    public func reservedRoles(network: UInt32, prefix: Int) -> [(ip: UInt32, role: String)] {
        guard prefix >= 1 && prefix <= self.minimumPrefix else { return [] }
        let totalHosts: UInt32 = (prefix == 32) ? 1 : UInt32(1 << (32 - prefix))
        let broadcast = network + totalHosts - 1

        switch self {
        case .standard:
            if prefix <= 30 {
                return [
                    (network, "Network Address"),
                    (broadcast, "Broadcast Address")
                ]
            }
            return []
        case .aws:
            return [
                (network, "Network Address (VPC Block)"),
                (network + 1, "VPC Router (Default Gateway)"),
                (network + 2, "Amazon-Provided DNS"),
                (network + 3, "Future Use (Reserved by AWS)"),
                (broadcast, "Broadcast Address")
            ]
        case .azure:
            return [
                (network, "Network Address"),
                (network + 1, "Default Gateway"),
                (network + 2, "Primary Azure DNS"),
                (network + 3, "Secondary Azure DNS"),
                (broadcast, "Broadcast Address")
            ]
        case .gcp:
            return [
                (network, "Network Address"),
                (network + 1, "Default Gateway"),
                (broadcast - 1, "Future Use (Reserved by GCP)"),
                (broadcast, "Broadcast Address")
            ]
        case .oci:
            return [
                (network, "Network Address"),
                (network + 1, "Default Gateway"),
                (broadcast, "Broadcast Address")
            ]
        }
    }
}

// MARK: - RFC Standards Extensions & Dynamic Classifier
import Security

extension IPSubnetCalc {
    /**
     Generate an RFC 4193 Unique Local IPv6 Unicast Address (ULA)
     Uses SecRandomCopyBytes for 40-bit cryptographic entropy
     */
    public static func generateIPv6ULA() -> (prefix48: String, defaultSubnet64: String) {
        var randomBytes = [UInt8](repeating: 0, count: 5)
        _ = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)

        let globalID = String(format: "%02x:%02x%02x:%02x%02x",
                              randomBytes[0], randomBytes[1], randomBytes[2], randomBytes[3], randomBytes[4])
        let prefix48 = "fd\(globalID)::/48"
        let defaultSubnet64 = "fd\(globalID):0001::/64"
        return (prefix48, defaultSubnet64)
    }

    /**
     Classify an IPv4 address according to authoritative IETF RFC specifications
     */
    public static func classifyIPv4Address(_ ipAddress: String) -> String {
        guard let num = digitize(ipAddress: ipAddress) else { return "Invalid IP" }
        let b1 = (num >> 24) & 0xFF
        let b2 = (num >> 16) & 0xFF

        if b1 == 0 {
            return "RFC 1122 This Host on This Network"
        }
        if b1 == 10 {
            return "RFC 1918 Private (Class A)"
        }
        if b1 == 172 && (b2 >= 16 && b2 <= 31) {
            return "RFC 1918 Private (Class B)"
        }
        if b1 == 192 && b2 == 168 {
            return "RFC 1918 Private (Class C)"
        }
        if b1 == 100 && (b2 >= 64 && b2 <= 127) {
            return "RFC 6598 CGNAT / Shared Space"
        }
        if b1 == 127 {
            return "RFC 1122 Loopback"
        }
        if b1 == 169 && b2 == 254 {
            return "RFC 3927 Link-Local (APIPA)"
        }
        if b1 >= 224 && b1 <= 239 {
            return "RFC 5771 Multicast (Class D)"
        }
        if b1 >= 240 {
            return "RFC 1122 Reserved / Experimental (Class E)"
        }
        return "Public Routable IPv4"
    }

    /**
     Classify an IPv6 address according to authoritative IETF RFC specifications
     */
    public static func classifyIPv6Address(_ ipAddress: String) -> String {
        let clean = ipAddress.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if clean == "::1" || clean.hasPrefix("::1/") {
            return "RFC 4291 Loopback"
        }
        if clean == "::" || clean.hasPrefix("::/") {
            return "RFC 4291 Unspecified"
        }
        if clean.hasPrefix("fc") || clean.hasPrefix("fd") {
            return "RFC 4193 Unique Local (ULA Private)"
        }
        if clean.hasPrefix("fe8") || clean.hasPrefix("fe9") || clean.hasPrefix("fea") || clean.hasPrefix("feb") {
            return "RFC 4291 Link-Local Unicast"
        }
        if clean.hasPrefix("ff") {
            return "RFC 4291 Multicast"
        }
        if clean.hasPrefix("2001:db8") {
            return "RFC 3849 Documentation"
        }
        if clean.hasPrefix("2") || clean.hasPrefix("3") {
            return "RFC 4291 Global Unicast (Public)"
        }
        if clean.hasPrefix("::ffff:") || clean.hasPrefix("0:0:0:0:0:ffff:") {
            return "RFC 4291 IPv4-Mapped"
        }
        if clean.hasPrefix("64:ff9b:") {
            return "RFC 6052 IPv4-IPv6 Translation"
        }
        return "IPv6"
    }

    /**
     Unified IP address classification (IPv4 or IPv6)
     */
    public static func classifyAnyAddress(_ ipAddress: String) -> String {
        if ipAddress.contains(":") {
            return classifyIPv6Address(ipAddress)
        } else {
            return classifyIPv4Address(ipAddress)
        }
    }
}

// MARK: - Spreadsheet-Safe Data Portability Engine
public struct DataPortability {
    /**
     Mitigate CSV / Spreadsheet Formula Injection (CWE-1236)
     Prefixes dangerous leading execution characters (=, +, -, @) with a single quote
     */
    public static func sanitizeFormulaInjection(_ text: String) -> String {
        guard let firstChar = text.first else { return text }
        if ["=", "+", "-", "@", "\t", "\r"].contains(firstChar) {
            return "'" + text
        }
        return text
    }

    /**
     Generate RFC 4180 compliant CSV text with quote escaping and formula injection protection
     */
    public static func exportSafeCSV(headers: [String], rows: [[String]]) -> String {
        var lines: [String] = []
        let escapedHeaders = headers.map { "\"\($0.replacingOccurrences(of: "\"", with: "\"\""))\"" }
        lines.append(escapedHeaders.joined(separator: ","))

        for row in rows {
            let escapedCells = row.map { cell -> String in
                let sanitized = sanitizeFormulaInjection(cell)
                let escaped = sanitized.replacingOccurrences(of: "\"", with: "\"\"")
                return "\"\(escaped)\""
            }
            lines.append(escapedCells.joined(separator: ","))
        }
        return lines.joined(separator: "\r\n")
    }

    /**
     Generate a formatted Plain Text ASCII table with dynamic column width alignment
     */
    public static func exportPlainTextTable(headers: [String], rows: [[String]]) -> String {
        guard !headers.isEmpty else { return "" }
        var colWidths = headers.map { $0.count }
        for row in rows {
            for (idx, cell) in row.enumerated() where idx < colWidths.count {
                if cell.count > colWidths[idx] {
                    colWidths[idx] = cell.count
                }
            }
        }

        func formatRow(_ cells: [String]) -> String {
            var parts: [String] = []
            for (idx, width) in colWidths.enumerated() {
                let text = (idx < cells.count) ? cells[idx] : ""
                parts.append(text.padding(toLength: width, withPad: " ", startingAt: 0))
            }
            return parts.joined(separator: "  |  ")
        }

        var outputLines: [String] = []
        outputLines.append(formatRow(headers))
        let separator = colWidths.map { String(repeating: "-", count: $0) }.joined(separator: "--+--")
        outputLines.append(separator)

        for row in rows {
            outputLines.append(formatRow(row))
        }
        return outputLines.joined(separator: "\n")
    }

    /**
     Alias for exportPlainTextTable
     */
    public static func exportAsciiTable(headers: [String], rows: [[String]]) -> String {
        return exportPlainTextTable(headers: headers, rows: rows)
    }
}
