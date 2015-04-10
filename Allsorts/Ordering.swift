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

    public static func create(value: Int) -> Ordering {
        return value < 0 ? .LT : value == 0 ? .EQ : .GT
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

extension Ordering : Printable {
    public var description: String {
        switch self {
        case .LT: return "LT"
        case .EQ: return "EQ"
        case .GT: return "GT"
        }
    }
}

/// Evaluate the lexicographic ordering of two comparison expressions. If `left`
/// evaluates not-equal, return its result. Else, evaluate and return `right`.
public func || (left: Ordering, @autoclosure right: () -> Ordering) -> Ordering {
    switch left {
    case .LT: return .LT
    case .EQ: return right()
    case .GT: return .GT
    }
}

/// Lexicographical comparator composing operator. Symbol chosen because of its
/// similarity to the OR operator: returns the inequality in the left operand,
/// or else the result of the right-hand side.
infix operator <|> {
    associativity right
    precedence 121 // one higher than `&&`, and lower than `==` etc.
}

/// Compose two comparators lexicographically: the function short-circuits if
/// the `left` comparator evaluates different than `Ordering.EQ`. Otherwise,
/// evaluates and returns the result of the `right` comparator.
///
/// **Remark:** This operator is useful together with the use of `Ordering.by`.
///
/// **See also:** `Ordering.by`. `sorted`, `stableSorted`
public func <|> <Args>(left: Args -> Ordering, right: Args -> Ordering) -> Args -> Ordering {
    return {args in
        left(args) || right(args)
    }
}
