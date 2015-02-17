//
//  Comparators.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

public extension Ordering {

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

    /// Create a unary comparator against a constant `Orderable` and
    /// `Comparable` value. This function is useful for the various binary
    /// search algorithms in this library:
    ///
    /// ```swift
    /// let index = binarySearch(sortedArray, Ordering.to(value))
    /// ```
    ///
    /// **Remark:** Coding styles differ, but note that the block
    /// `{$0 <=> value}` can be used synonymously in place of
    /// `Ordering.to(value)`.
    ///
    /// **Remark:** This overload only exists to make an unambiguous choice in
    /// the overload resolution for `T`.
    public static func to<T : protocol<Orderable, Comparable>>
        (right: T) -> T -> Ordering
    {
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
            value <=> interval
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
            value <=> interval
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

    /// Create a "by-key" comparator that returns the `Ordering` result of
    /// `key(left) <=> key(right)`. To compose many "by-key" comparators, use
    /// the `<|>` operator as in:
    ///
    /// ```swift
    /// sorted(people, Ordering.by {$0.lastName} <|> Ordering.by {$0.firstName})
    /// ```
    ///
    /// See also: `sorted`, `stableSorted`, `<|>`
    public static func by<T, K : Orderable>(key: T -> K) -> (T, T) -> Ordering {
        return {left, right in
            key(left) <=> key(right)
        }
    }
}

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
