//
//  Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Three-way comparison operator of two `Orderable`\ s.
infix operator <=> {
    associativity none
    precedence 131 // one higher than ==, !=, <, >, <= and >=
}

/// Implementation detail for the `Orderable` protocol.
public protocol _Orderable {
    func <=> (lhs: Self, rhs: Self) -> Ordering
}

/// A type that can be efficiently three-way compared with another value of its
/// type using the `<=>` operator.
///
/// Any `Comparable` can be made `Orderable` by simply declaring protocol
/// conformance in an extension, but some types (like `Swift.String`) may have a
/// more efficient implementation for `<=>`.
public protocol Orderable : _Orderable, Comparable {}

/// Default implementation for making `Comparable` types `Orderable`.
public func <=> <T : Comparable>(left: T, right: T) -> Ordering {
    return Ordering.compare(left, right)
}

/// Default implementation for making `Orderable` types `Equatable`. Override
/// if needed.
public func == <T : Orderable>(left: T, right: T) -> Bool {
    switch left <=> right {
    case .EQ: return true
    default:  return false
    }
}

/// Default implementation for making `Orderable` types `Comparable`. Override
/// if needed.
public func < <T : Orderable>(left: T, right: T) -> Bool {
    switch left <=> right {
    case .LT: return true
    default:  return false
    }
}
