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
    /// - Remark: Coding styles differ, but note that the block
    /// `{$0 <=> value}` can be used synonymously in place of
    /// `Ordering.to(value)`.
    public static func to<T : Comparable>(_ right: T) -> (T) -> Ordering {
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
    /// - Remark: Coding styles differ, but note that the block
    /// `{$0 <=> value}` can be used synonymously in place of
    /// `Ordering.to(value)`.
    public static func to<T : Orderable>(_ right: T) -> (T) -> Ordering {
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
    /// - Remark: Coding styles differ, but note that the block
    /// `{$0 <=> value}` can be used synonymously in place of
    /// `Ordering.to(value)`.
    ///
    /// - Remark: This overload only exists to make an unambiguous choice in
    /// the overload resolution for `T`.
    public static func to<T : Orderable & Comparable>
        (_ right: T) -> (T) -> Ordering
    {
        return {left in left <=> right}
    }
    
    /// Create a unary comparator against a `Range<T>`. Values within
    /// `interval` are considered equal (`Orderable.equal`), and values less than
    /// `interval.start` and greater than or equal to `interval.end` are
    /// considered `Orderable.less` and `Orderable.greater`, respectively.
    public static func within<T>(_ interval: Range<T>)
        -> (T) -> Ordering
    {
        return {value in
            value <=> interval
        }
    }
    
    /// Create a unary comparator against a `ClosedRange<T>`. Values within
    /// `interval` are considered equal (`Orderable.equal`), and values less than
    /// `interval.start` and greater than `interval.end` are considered
    /// `Orderable.less` and `Orderable.greater`, respectively.
    public static func within<T>(_ interval: ClosedRange<T>) -> (T) -> Ordering {
        return {value in
            value <=> interval
        }
    }

    /// Invert the result of the comparator `compare`.
    ///
    /// Note that the `compare` function may have any arity in `Args` as long as
    /// it returns an `Ordering`.
    public static func reverse<Args>(_ compare: @escaping (Args) -> Ordering)
        -> (Args) -> Ordering
    {
        return {args in
            switch compare(args) {
            case .less: return .greater
            case .equal: return .equal
            case .greater: return .less
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
    /// - Seealso: `Array.sortInPlace(ordering:)`,
    ///   `Sequence.sort(ordering:)`, `<|>`
    public static func by<T, K : Orderable>(_ key: @escaping (T) -> K) -> (T, T) -> Ordering {
        return {left, right in
            key(left) <=> key(right)
        }
    }
}

// MARK: Useful `<=>` overloads

/// Compare `left` to an interval of right-hand side values, `rightInterval`.
///
/// Values within `rightInterval` are considered equal (`Orderable.equal`), and
/// values less than `rightInterval.start` and greater than or equal to
/// `rightInterval.end` are considered `Orderable.less` and `Orderable.greater`,
/// respectively.
public func <=> <T>(left: T, rightInterval: Range<T>) -> Ordering {
    return left < rightInterval.lowerBound ? .less
         : left < rightInterval.upperBound ? .equal : .greater
}

/// The reverse of `right <=> leftInterval`.
public func <=> <T>(leftInterval: Range<T>, right: T) -> Ordering {
    return -(right <=> leftInterval)
}

/// Compare `left` to an interval of right-hand side values, `rightInterval`.
///
/// Values within `rightInterval` are considered equal (`Orderable.equal`), and
/// values less than `rightInterval.start` and greater than `rightInterval.end`
/// are considered `Orderable.less` and `Orderable.greater`, respectively.
public func <=> <T>(left: T, rightInterval: ClosedRange<T>) -> Ordering {
    return left < rightInterval.lowerBound ? .less
         : left > rightInterval.upperBound ? .greater : .equal
}

/// The reverse of `right <=> leftInterval`.
public func <=> <T>(leftInterval: ClosedRange<T>, right: T) -> Ordering {
    return -(right <=> leftInterval)
}
