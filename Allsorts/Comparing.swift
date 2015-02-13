//
//  Comparing.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//


/// Create a unary comparator against a constant `Comparable` value. This
/// function is useful for the various binary search algorithms in this library:
///
/// ```swift
/// let index = binarySearch(sortedArray, comparingTo(value))
/// ```
public func comparingTo<T : Comparable>(right: T) -> T -> Ordering {
    return {left in Ordering.compare(left, right)}
}

/// Create a unary comparator against a constant `Orderable` value. This
/// function is useful for the various binary search algorithms in this library:
///
/// ```swift
/// let index = binarySearch(sortedArray, comparingTo(value))
/// ```
///
/// **Remark:** Coding tastes differ, but note that the block `{$0 <=> value}`
/// can be used synonymously instead of `comparingTo(value)`.
public func comparingTo<T : Orderable>(right: T) -> T -> Ordering {
    return {left in left <=> right}
}

/// Invert the result of the comparator `compare`.
///
/// Note that the `compare` function may have any arity in `Args` as long as it
/// returns an `Ordering`.
public func reversing<Args>(compare: Args -> Ordering) -> Args -> Ordering {
    return {args in
        switch compare(args) {
        case .LT: return .GT
        case .EQ: return .EQ
        case .GT: return .LT
        }
    }
}
