//
//  Ordering.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// The precise ordering between two values `left` and `right`.
public enum Ordering : Int {

    /// The ordering where `left < right`.
    case LT = -1

    /// The ordering where `left == right`.
    case EQ = 0

    /// The ordering where `left > right`.
    case GT = 1
    
    /// Construct an `Ordering` from any `rawValue`. Negative values coerce to
    /// `.LT`, zero to `.EQ` and positive values to `.GT`.
    public init(rawValue: Int) {
        self = rawValue < 0 ? .LT : rawValue == 0 ? .EQ : .GT
    }
    
    /// Compute the `Ordering` between the `Comparable`\ s `left` and `right` by
    /// using the `<` operator and, if not less-than, the `==` operator.
    public static func compare<T : Comparable>(left: T, _ right: T) -> Ordering {
        return left < right ? .LT : left == right ? .EQ : .GT
    }

}

/// Evaluate the lexicographic ordering of two comparison expressions. If `left`
/// evaluates not-equal, return its result. Else, evaluate and return `right`.
public func || (left: Ordering, right: @autoclosure () -> Ordering) -> Ordering {
    switch left {
    case .LT: return .LT
    case .EQ: return right()
    case .GT: return .GT
    }
}
