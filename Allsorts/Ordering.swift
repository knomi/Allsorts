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
        self.init(rawValue)
    }

    public init(_ value: Int) {
        self = value < 0 ? .LT : value == 0 ? .EQ : .GT
    }
    
    /// Compute the `Ordering` between the `Comparable`\ s `left` and `right` by
    /// using the `<` operator and, if not less-than, the `==` operator.
    public static func compare<T : Comparable>(left: T, _ right: T) -> Ordering {
        return left < right ? .LT : left == right ? .EQ : .GT
    }
}

extension Ordering : Comparable {}

prefix func -(reversed: Ordering) -> Ordering {
    return Ordering(rawValue: -reversed.rawValue)
}

public func == (left: Ordering, right: Ordering) -> Bool {
    return left.rawValue == right.rawValue
}

public func < (left: Ordering, right: Ordering) -> Bool {
    return left.rawValue < right.rawValue
}

extension Ordering : CustomStringConvertible {
    public var description: String {
        switch self {
        case .LT: return "LT"
        case .EQ: return "EQ"
        case .GT: return "GT"
        }
    }
}

extension Ordering : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .LT: return "Ordering.LT"
        case .EQ: return "Ordering.EQ"
        case .GT: return "Ordering.GT"
        }
    }
}
