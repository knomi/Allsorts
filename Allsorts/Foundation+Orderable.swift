//
//  Foundation+Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation

extension Data          : Orderable {}
extension Date          : Orderable {}
extension IndexPath     : Orderable {}
extension NSNumber        : Orderable {}
//extension NSString        : Orderable {}
extension UUID          : Orderable {}

/// Lexicographical three-way comparison between two `Data` treated as arrays
/// of unsigned bytes.
public func <=>(left: Data, right: Data) -> Ordering {
    let c = left.withUnsafeBytes { l in right.withUnsafeBytes { r in
        memcmp(l, r, min(left.count, right.count))
    }}
    if c < 0 { return .less }
    if c > 0 { return .greater }
    return Ordering.compare(left.count, right.count)
}

/// Three-way comparison between two `Date` values.
public func <=>(left: Date, right: Date) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

/// Three-way comparison between two `NSDecimalNumber` values.
public func <=>(left: NSDecimalNumber, right: NSDecimalNumber) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

/// Lexicographical three-way comparison between two `IndexPath` values.
public func <=>(left: IndexPath, right: IndexPath) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

/// Three-way comparison between two `NSNumber` values.
public func <=>(left: NSNumber, right: NSNumber) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

///// Lexicographical three-way comparison between two `NSString` values.
//public func <=>(left: NSString, right: NSString) -> Ordering {
//    return Ordering((left as String).compare(right as String).rawValue)
//}

/// Lexicographical three-way comparison between two `UUID` values.
public func <=>(left: UUID, right: UUID) -> Ordering {
    return left.uuidString <=> right.uuidString
}
