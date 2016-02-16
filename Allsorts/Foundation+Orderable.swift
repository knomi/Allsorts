//
//  Foundation+Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation

extension NSData          : Orderable {}
extension NSDate          : Orderable {}
extension NSIndexPath     : Orderable {}
extension NSNumber        : Orderable {}
extension NSString        : Orderable {}
extension NSUUID          : Orderable {}

/// Lexicographical three-way comparison between two `NSData` treated as arrays
/// of unsigned bytes.
@warn_unused_result
public func <=>(left: NSData, right: NSData) -> Ordering {
    let c = memcmp(left.bytes, right.bytes, min(left.length, right.length))
    if c < 0 { return .LT }
    if c > 0 { return .GT }
    return Ordering.compare(left.length, right.length)
}

/// Three-way comparison between two `NSDate` values.
@warn_unused_result
public func <=>(left: NSDate, right: NSDate) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

/// Three-way comparison between two `NSDecimalNumber` values.
@warn_unused_result
public func <=>(left: NSDecimalNumber, right: NSDecimalNumber) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

/// Lexicographical three-way comparison between two `NSIndexPath` values.
@warn_unused_result
public func <=>(left: NSIndexPath, right: NSIndexPath) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

/// Three-way comparison between two `NSNumber` values.
@warn_unused_result
public func <=>(left: NSNumber, right: NSNumber) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

/// Lexicographical three-way comparison between two `NSString` values.
@warn_unused_result
public func <=>(left: NSString, right: NSString) -> Ordering {
    return Ordering((left as String).compare(right as String).rawValue)
}

/// Lexicographical three-way comparison between two `NSUUID` values.
@warn_unused_result
public func <=>(left: NSUUID, right: NSUUID) -> Ordering {
    var a = [UInt8](count: 16, repeatedValue: 0)
    var b = [UInt8](count: 16, repeatedValue: 0)
    left.getUUIDBytes(&a)
    right.getUUIDBytes(&b)
    return a <=> b
}
