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

public protocol Orderable {
    func <=> (lhs: Self, rhs: Self) -> Ordering
}

public func <=> <T : Comparable>(lhs: T, rhs: T) -> Ordering {
    if lhs < rhs { return .LT }
    if rhs < lhs { return .GT }
    assert(lhs == rhs)
    return .EQ
}

public func == <T : Orderable>(lhs: T, rhs: T) -> Bool {
    switch lhs <=> rhs {
    case .EQ: return true
    default:  return false
    }
}

public func != <T : Orderable>(lhs: T, rhs: T) -> Bool {
    switch lhs <=> rhs {
    case .EQ: return false
    default:  return true
    }
}

public func < <T : Orderable>(lhs: T, rhs: T) -> Bool {
    switch lhs <=> rhs {
    case .LT: return true
    default:  return false
    }
}

public func > <T : Orderable>(lhs: T, rhs: T) -> Bool {
    switch lhs <=> rhs {
    case .GT: return true
    default:  return false
    }
}

public func <= <T : Orderable>(lhs: T, rhs: T) -> Bool {
    switch lhs <=> rhs {
    case .GT: return false
    default:  return true
    }
}

public func >= <T : Orderable>(lhs: T, rhs: T) -> Bool {
    switch lhs <=> rhs {
    case .LT: return false
    default:  return true
    }
}
