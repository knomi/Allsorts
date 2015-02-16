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
/// `String`\ s. Currently uses `NSString.compare` as an implementation detail.
public func <=> (left: String, right: String) -> Ordering {
    return Ordering(rawValue: left.compare(right).rawValue)
}

extension String : Orderable {}

// MARK: Useful `<=>` overloads

/// Compare `left` to an interval of right-hand side values, `rightInterval`.
///
/// Values within `rightInterval` are considered equal (`Orderable.EQ`), and
/// values less than `rightInterval.start` and greater than or equal to
/// `rightInterval.end` are considered `Orderable.LT` and `Orderable.GT`,
/// respectively.
public func <=> <T>(left: T, rightInterval: HalfOpenInterval<T>) -> Ordering {
    return left < rightInterval.start ? .LT
         : left < rightInterval.end ? .EQ : .GT
}

/// Compare `left` to an interval of right-hand side values, `rightInterval`.
///
/// Values within `rightInterval` are considered equal (`Orderable.EQ`), and
/// values less than `rightInterval.start` and greater than `rightInterval.end`
/// are considered `Orderable.LT` and `Orderable.GT`, respectively.
public func <=> <T>(left: T, rightInterval: ClosedInterval<T>) -> Ordering {
    return left < rightInterval.start ? .LT
         : left > rightInterval.end ? .GT : .EQ
}
