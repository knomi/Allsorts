//
//  Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Three-way comparison operator of two `Orderable`\ s.
infix operator <=> : ComparisonPrecedence

/// A type that can be efficiently three-way compared with another value of its
/// type using the `<=>` operator.
///
/// Any `Comparable` can be made `Orderable` by simply declaring protocol
/// conformance in an extension, but some types (like `Swift.String`) may have a
/// more efficient implementation for `<=>`.
///
/// Axioms:
/// ```
/// (i) ∀x: x <=> x == Ordering.equal (reflexivity)
/// (ii) ∀x,y: if (x <=> y).rawValue == i
///            then (y <=> x).rawValue == -i (antisymmetry)
/// (iii) ∀x,y,z: if   (x <=> y).rawValue == i
///               and  (y <=> z).rawValue == i
///               then (x <=> z).rawValue == i (transitivity)
/// ```
public protocol Orderable {
    static func <=> (left: Self, right: Self) -> Ordering
}

/// Default implementation for making `Comparable` types `Orderable`.
public func <=> <T : Comparable>(left: T, right: T) -> Ordering {
    return Ordering.compare(left, right)
}

/// Default implementation for making `Orderable` types `Equatable`. Override
/// if needed.
public func == <T : Orderable & Comparable>(left: T, right: T) -> Bool {
    switch left <=> right {
    case .equal: return true
    default:  return false
    }
}

/// Default implementation for making `Orderable` types `Comparable`. Override
/// if needed.
public func < <T : Orderable & Comparable>(left: T, right: T) -> Bool {
    switch left <=> right {
    case .less: return true
    default:  return false
    }
}
