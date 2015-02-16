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

    /// Create a unary comparator against a constant `Comparable` value. This
    /// function is useful for the various binary search algorithms in this library:
    ///
    /// ```swift
    /// let index = binarySearch(sortedArray, Ordering.to(value))
    /// ```
    ///
    /// **Remark:** Coding styles differ, but note that the block
    /// `{$0 <=> value}` can be used synonymously in place of
    /// `Ordering.to(value)`.
    public static func to<T : Comparable>(right: T) -> T -> Ordering {
        return {left in Ordering.compare(left, right)}
    }

    /// Create a unary comparator against a constant `Orderable` value. This
    /// function is useful for the various binary search algorithms in this
    /// library:
    ///
    /// ```swift
    /// let index = binarySearch(sortedArray, Ordering.to(value))
    /// ```
    ///
    /// **Remark:** Coding styles differ, but note that the block
    /// `{$0 <=> value}` can be used synonymously in place of
    /// `Ordering.to(value)`.
    public static func to<T : Orderable>(right: T) -> T -> Ordering {
        return {left in left <=> right}
    }
    
    /// Create a unary comparator against a `HalfOpenInterval<T>`. Values within
    /// `interval` are considered equal (`Orderable.EQ`), and values less than
    /// `interval.start` and greater than or equal to `interval.end` are
    /// considered `Orderable.LT` and `Orderable.GT`, respectively.
    public static func within<T>(interval: HalfOpenInterval<T>)
        -> T -> Ordering
    {
        return {value in
            value < interval.start ? .LT : value < interval.end ? .EQ : .GT
        }
    }
    
    /// Create a unary comparator against a `ClosedInterval<T>`. Values within
    /// `interval` are considered equal (`Orderable.EQ`), and values less than
    /// `interval.start` and greater than `interval.end` are considered
    /// `Orderable.LT` and `Orderable.GT`, respectively.
    public static func within<T>(interval: ClosedInterval<T>)
        -> T -> Ordering
    {
        return {value in
            value < interval.start ? .LT : interval.end < value ? .GT : .EQ
        }
    }

    /// Invert the result of the comparator `compare`.
    ///
    /// Note that the `compare` function may have any arity in `Args` as long as
    /// it returns an `Ordering`.
    public static func reverse<Args>(compare: Args -> Ordering)
        -> Args -> Ordering
    {
        return {args in
            switch compare(args) {
            case .LT: return .GT
            case .EQ: return .EQ
            case .GT: return .LT
            }
        }
    }

    ///
    public static func by<T, A : Orderable>(a: T -> A) -> (T, T) -> Ordering {
        return {x, y in a(x) <=> a(y)}
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

public func || <Args>(left: Args -> Ordering, right: Args -> Ordering) -> Args -> Ordering {
    return {args in
        left(args) || right(args)
    }
}
