//
//  Foundation+Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation

extension NSData          : Orderable {}
extension NSDate          : Orderable {}
extension NSDecimalNumber : Orderable {}
extension NSIndexPath     : Orderable {}
extension NSNumber        : Orderable {}
extension NSString        : Orderable {}
extension NSUUID          : Orderable {}

/// Lexicographical three-way comparison between two `NSData` unsigned byte arrays.
public func <=>(left: NSData, right: NSData) -> Ordering {
        let c = memcmp(left.bytes, right.bytes, UInt(min(left.length, right.length)))
        if c < 0 { return .LT }
        if c > 0 { return .GT }
        return Ordering.compare(left.length, right.length)
}

/// Three-way comparison between two `NSDate` values.
public func <=>(left: NSDate, right: NSDate) -> Ordering {
    return Ordering(left.compare(right))
}

/// Lexicographical three-way comparison between two `NSIndexPath` values.
public func <=>(left: NSIndexPath, right: NSIndexPath) -> Ordering {
    return Ordering(left.compare(right))
}

/// Three-way comparison between two `NSNumber` values.
public func <=>(left: NSNumber, right: NSNumber) -> Ordering {
    return Ordering(left.compare(right))
}

/// Lexicographical three-way comparison between two `NSString` values.
public func <=>(left: NSString, right: NSString) -> Ordering {
    return Ordering(left.compare(right))
}

/// Lexicographical three-way comparison between two `NSUUID` values.
public func <=>(left: NSUUID, right: NSUUID) -> Ordering {
    var a = [UInt8](count: 16, repeatedValue: 0)
    var b = [UInt8](count: 16, repeatedValue: 0)
    left.getUUIDBytes(&a)
    right.getUUIDBytes(&b)
    return a <=> b
}
