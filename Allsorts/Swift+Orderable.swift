//
//  Swift+Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

// MARK: Numbers

extension Float  : Orderable {}

extension Double : Orderable {}

extension Int    : Orderable {}

extension Int8   : Orderable {}

extension Int16  : Orderable {}

extension Int32  : Orderable {}

extension Int64  : Orderable {}

extension UInt   : Orderable {}

extension UInt8  : Orderable {}

extension UInt16 : Orderable {}

extension UInt32 : Orderable {}

extension UInt64 : Orderable {}

// MARK: Strings

extension Character : Orderable {}

extension UnicodeScalar : Orderable {}

/// Case-sensitive, locale-insensitive three-way comparison between two
/// `String`\ s. Currently uses `String.compare` as an implementation detail.
@warn_unused_result
public func <=> (left: String, right: String) -> Ordering {
    return Ordering(left.compare(right).rawValue)
}

extension String : Orderable {}

// MARK: Other

extension ObjectIdentifier : Orderable {}
