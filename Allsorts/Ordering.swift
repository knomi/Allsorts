//
//  Ordering.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// The precise ordering between two values `left` and `right`.
public enum Ordering : Int {

    /// The ordering where `left < right`.
    case less = -1

    /// The ordering where `left == right`.
    case equal = 0

    /// The ordering where `left > right`.
    case greater = 1
    
    /// Construct an `Ordering` from any `rawValue`. Negative values coerce to
    /// `.less`, zero to `.equal` and positive values to `.greater`.
    public init(rawValue: Int) {
        self = .init(rawValue)
    }

    public init(_ value: Int) {
        self = value < 0 ? .less : value == 0 ? .equal : .greater
    }
    
    /// Compute the `Ordering` between the `Comparable`\ s `left` and `right` by
    /// using the `<` operator and, if not less-than, the `==` operator.
    public static func compare<T : Comparable>(_ left: T, _ right: T) -> Ordering {
        return left < right ? .less : left == right ? .equal : .greater
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
        case .less: return "less"
        case .equal: return "equal"
        case .greater: return "greater"
        }
    }
}

extension Ordering : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .less: return "Ordering.less"
        case .equal: return "Ordering.equal"
        case .greater: return "Ordering.greater"
        }
    }
}
