//
//  BinarySearch.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//


// -----------------------------------------------------------------------------
// MARK: - Binary search

/// Arbitrarily find an index `i` within the `range` sorted by `ordering` such
/// that:
///
/// - `ordering(i) == Ordering.EQ` iff `ordering(j) == Ordering.EQ` for some
///   `j`, and
/// - otherwise, `ordering(i) == .GT` and `ordering(j) == .LT` for all `j < i`.
///
/// **Precondition:** The `range` must be sorted by `ordering`.
///
/// **Complexity:** `O(log n)` where `n` is the number of indices in `range`.
///
/// **See also:** `binaryFind`, `equalRange`, `lowerBound`, `upperBound`.
public func binarySearch<Ix : RandomAccessIndexType>
    (range: Range<Ix>, _ ordering: Ix -> Ordering) -> Ix
{
    return forkEqualRange(range, ordering).lower.endIndex
}

/// Convenience function for arbitrarily finding an index `i` within
/// `indices(xs)` such that:
///
/// - `ordering(xs[j]) != Ordering.GT` for all `j` in `xs.beginIndex ..< i`,
/// - `ordering(xs[k]) != Ordering.LT` for all `k` in `i ..< xs.endIndex`.
///
/// **Precondition:** `xs` must be sorted by `ordering`.
///
/// **Remark:** For a sorted array of `Comparable`s, just pass `Ordering.to(x)`
/// as `ordering`.
///
/// **See also:** `binaryFind`, `equalRange`, `lowerBound`, `upperBound`.
public func binarySearch<S : CollectionType where
                         S.Index : RandomAccessIndexType>
    (xs: S, _ ordering: S.Generator.Element -> Ordering) -> S.Index
{
    return binarySearch(xs.indices) {i in ordering(xs[i])}
}

/// Convenience function for arbitrarily finding an index `i` within
/// `indices(xs)` such that `ordering(i) == Ordering.EQ`. If none is found,
/// returns `nil`.
///
/// **Precondition:** `xs` must be sorted by `ordering`.
///
/// **Remark:** For a sorted array of `Comparable`s, just pass `Ordering.to(x)`
/// as `ordering`.
///
/// **See also:** `binarySearch`, `equalRange`, `lowerBound`, `upperBound`.
public func binaryFind<S : CollectionType where S.Index : RandomAccessIndexType>
    (xs: S, _ ordering: S.Generator.Element -> Ordering) -> S.Index?
{
    let forks = forkEqualRange(xs.indices) {i in ordering(xs[i])}
    if forks.lower.startIndex != forks.upper.endIndex {
        return forks.lower.endIndex
    } else {
        return nil
    }
}


// -----------------------------------------------------------------------------
// MARK: - Lower bound

/// Compute the lowest index `i` within `range` for which `ordering(i)` does not
/// return `Ordering.LT`. If there is no such index, return `range.endIndex`.
///
/// Precondition: The `range` must be sorted by `ordering`.
///
/// Complexity: `O(log n)` where `n` is the number of indices in the `range`.
///
/// See also: `equalRange`, `upperBound`, `binarySearch`.
public func lowerBound<Ix : RandomAccessIndexType>
    (range: Range<Ix>, _ ordering: Ix -> Ordering) -> Ix
{
    var (lo, hi) = (range.startIndex, range.endIndex)
    while lo < hi {
        let m = midIndex(lo ..< hi)
        (lo, hi) = ordering(m) == .LT ? (m.successor(), hi) : (lo, m)
    }
    return lo
}

/// Convenience function for finding the lower bound index `i` within
/// `indices(xs)` such that:
///
/// - `ordering(xs[j]) != Ordering.GT` for all `j` in `xs.startIndex ..< i`, and
/// - `ordering(xs[k]) == Ordering.GT` for all `k` in `i ..< xs.endIndex`.
///
/// Precondition: `xs` must be sorted by `ordering`.
///
/// Remark: For a sorted array of `Comparable`s, just pass `Ordering.to(x)`
/// as `ordering`.
public func lowerBound<S : CollectionType where
                       S.Index : RandomAccessIndexType>
    (xs: S, _ ordering: S.Generator.Element -> Ordering) -> S.Index
{
    return lowerBound(xs.indices) {i in ordering(xs[i])}
}


// -----------------------------------------------------------------------------
// MARK: - Upper bound

/// Compute the lowest index `i` within `range` for which `ordering(i)` returns
/// `Ordering.GT`. If there is no such index, return `range.endIndex`.
///
/// Precondition: The `range` must be sorted by `ordering`.
///
/// Complexity: `O(log n)` where `n` is the number of indices in the `range`.
///
/// See also: `equalRange`, `lowerBound`, `binarySearch`.
public func upperBound<Ix : RandomAccessIndexType>
    (range: Range<Ix>, _ ordering: Ix -> Ordering) -> Ix
{
    var (lo, hi) = (range.startIndex, range.endIndex)
    while lo < hi {
        let m = midIndex(lo ..< hi)
        (lo, hi) = ordering(m) == .GT ? (lo, m) : (m.successor(), hi)
    }
    return lo
}

/// Convenience function for finding the upper bound index `i` within
/// `indices(xs)` such that:
///
/// - `ordering(xs[j]) == Ordering.LT` for all `j` in `xs.startIndex ..< i`, and
/// - `ordering(xs[k]) != Ordering.LT` for all `k` in `i ..< xs.endIndex`.
///
/// Precondition: `xs` must be sorted by `ordering`.
///
/// Remark: For a sorted array of `Comparable`s, just pass `Ordering.to(x)`
/// as `ordering`.
public func upperBound<S : CollectionType where
                       S.Index : RandomAccessIndexType>
    (xs: S, _ ordering: S.Generator.Element -> Ordering) -> S.Index
{
    return upperBound(xs.indices) {i in ordering(xs[i])}
}


// -----------------------------------------------------------------------------
// MARK: - Equal range

/// Find the subrange or `range` for which all indices `i` satisfy
/// `ordering(i) == .EQ`. If there is no such range, return the empty range at
/// the point where those elements would be inserted while preserving the
/// ordering.
///
/// **Precondition:** The `range` must be sorted by `ordering`.
///
/// **Complexity:** `O(log n)` where `n` is the number of indices in `range`.
///
/// **Remark:** `equalRange(range, ordering: ord)` returns the range
/// `lowerBound(range, ordering: ord) ..< upperBound(range, ordering: ord)` but
/// performs fewer comparisons than calling `lowerBound` and `upperBound`
/// separately.
///
/// **See also:** `lowerBound`, `upperBound`, `binarySearch`.
public func equalRange<Ix : RandomAccessIndexType>
    (range: Range<Ix>, _ ordering: Ix -> Ordering) -> Range<Ix>
{
    let (lower, upper) = forkEqualRange(range, ordering)
    return lowerBound(lower, ordering) ..< upperBound(upper, ordering)
}

/// Convenience function for finding the subrange `start ..< end` of
/// `indices(xs)` such that:
///
/// - `ordering(xs[i]) == Ordering.LT` for all `i` in `xs.beginIndex ..< start`,
/// - `ordering(xs[j]) == Ordering.EQ` for all `j` in `start ..< end`, and
/// - `ordering(xs[k]) == Ordering.GT` for all `k` in `end ..< xs.endIndex`.
///
/// **Precondition:** `xs` must be sorted by `ordering`.
///
/// **Remark:** For a sorted array of `Comparable`s, just pass `Ordering.to(x)`
/// as `ordering`.
public func equalRange<S : CollectionType where
                       S.Index : RandomAccessIndexType>
    (xs: S, _ ordering: S.Generator.Element -> Ordering) -> Range<S.Index>
{
    return equalRange(xs.indices) {i in ordering(xs[i])}
}


// -----------------------------------------------------------------------------
// MARK: - Private

/// Compute the index at, or just below, the mid-point from `start` to `end`.
internal func midIndex<Ix : RandomAccessIndexType>(range: Range<Ix>) -> Ix {
    let fullDistance = range.startIndex.distanceTo(range.endIndex)
    return range.startIndex.advancedBy(fullDistance / 2)
}

/// Arbitrarily find two subranges `(lower, upper)` of `range` such that:
///
/// - `lower.endIndex == upper.startIndex`,
/// - `lowerBound(lower, ordering: ord) == lowerBound(range, ordering: ord)`, and
/// - `upperBound(upper, ordering: ord) == upperBound(range, ordering: ord)`.
///
/// **Precondition:** The `range` must be sorted by `ordering`.
///
/// **Complexity:** `O(n)` where `n` is the number of indices in the `range`.
///
/// **Remark:** Note that the subranges may
///
/// **See also:** `lowerBound`, `upperBound` and `equalRange`
internal func forkEqualRange<Ix : RandomAccessIndexType>
    (range: Range<Ix>, _ ordering: Ix -> Ordering) -> (lower: Range<Ix>,
                                                       upper: Range<Ix>)
{
    var (lo, hi) = (range.startIndex, range.endIndex)
    while lo < hi {
        let m = midIndex(lo ..< hi)
        switch ordering(m) {
        case .LT: lo = m.successor()
        case .EQ: return (lo ..< m, m ..< hi)
        case .GT: hi = m
        }
    }
    return (lo ..< lo, lo ..< lo)
}
