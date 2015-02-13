//
//  BinarySearch.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//


// -----------------------------------------------------------------------------
// MARK: - Binary search

/// Arbitrarily find an index `i` within the `range` sorted by `ord` such that:
///
/// - `ord(i) == Ordering.EQ` iff `ord(j) == Ordering.EQ` for some `j`, and
/// - otherwise, `ord(i) == .GT` and `ord(j) == .LT` for all `j < i`.
///
/// **Precondition:** The `range` must be sorted by `ord`.
///
/// **Complexity:** `O(log n)` where `n` is the number of indices in `range`.
///
/// **See also:** `binaryFind`, `equalRange`, `lowerBound`, `upperBound`.
public func binarySearch<Ix : RandomAccessIndexType>
    (range: Range<Ix>, ord: Ix -> Ordering) -> Ix
{
    return forkEqualRange(range, ord).lower.endIndex
}

/// Convenience function for arbitrarily finding an index `i` within
/// `indices(xs)` such that:
///
/// - `ord(xs[j]) != Ordering.GT` for all `j` in `xs.beginIndex ..< i`,
/// - `ord(xs[k]) != Ordering.LT` for all `k` in `i ..< xs.endIndex`.
///
/// **Precondition:** `xs` must be sorted by `ord`.
///
/// **Remark:** For a sorted array of `Comparable`s, just pass `comparingTo(x)`
/// as `ord`.
///
/// **See also:** `binaryFind`, `equalRange`, `lowerBound`, `upperBound`.
public func binarySearch<S : CollectionType where
                         S.Index : RandomAccessIndexType>
    (xs: S, ord: S.Generator.Element -> Ordering) -> S.Index
{
    return binarySearch(indices(xs)) {i in ord(xs[i])}
}

/// Convenience function for arbitrarily finding an index `i` within
/// `indices(xs)` such that `ord(i) == Ordering.EQ`. If none is found, returns
/// `nil`.
///
/// **Precondition:** `xs` must be sorted by `ord`.
///
/// **Remark:** For a sorted array of `Comparable`s, just pass `comparingTo(x)`
/// as `ord`.
///
/// **See also:** `binarySearch`, `equalRange`, `lowerBound`, `upperBound`.
public func binaryFind<S : CollectionType where S.Index : RandomAccessIndexType>
    (xs: S, ord: S.Generator.Element -> Ordering) -> S.Index?
{
    let forks = forkEqualRange(indices(xs)) {i in ord(xs[i])}
    if forks.lower.startIndex != forks.upper.endIndex {
        return forks.lower.endIndex
    } else {
        return nil
    }
}


// -----------------------------------------------------------------------------
// MARK: - Lower bound

/// Compute the lowest index `i` within `range` for which `ord(i)` does not
/// return `Ordering.LT`. If there is no such index, return `range.endIndex`.
///
/// Precondition: The `range` must be sorted by `ord`.
///
/// Complexity: `O(log n)` where `n` is the number of indices in the `range`.
///
/// See also: `equalRange`, `upperBound`, `binarySearch`.
public func lowerBound<Ix : RandomAccessIndexType>
    (range: Range<Ix>, ord: Ix -> Ordering) -> Ix
{
    var (lo, hi) = (range.startIndex, range.endIndex)
    while lo < hi {
        let m = midIndex(lo, hi)
        (lo, hi) = ord(m) == .LT ? (m.successor(), hi) : (lo, m)
    }
    return lo
}

/// Convenience function for finding the lower bound index `i` within
/// `indices(xs)` such that:
///
/// - `ord(xs[j]) != Ordering.GT` for all `j` in `xs.startIndex ..< i`, and
/// - `ord(xs[k]) == Ordering.GT` for all `k` in `i ..< xs.endIndex`.
///
/// Precondition: `xs` must be sorted by `ord`.
///
/// Remark: For a sorted array of `Comparable`s, just pass `comparingTo(x)`
/// as `ord`.
public func lowerBound<S : CollectionType where
                       S.Index : RandomAccessIndexType>
    (xs: S, ord: S.Generator.Element -> Ordering) -> S.Index
{
    return lowerBound(indices(xs)) {i in ord(xs[i])}
}


// -----------------------------------------------------------------------------
// MARK: - Upper bound

/// Compute the lowest index `i` within `range` for which `ord(i)` returns
/// `Ordering.GT`. If there is no such index, return `range.endIndex`.
///
/// Precondition: The `range` must be sorted by `ord`.
///
/// Complexity: `O(log n)` where `n` is the number of indices in the `range`.
///
/// See also: `equalRange`, `lowerBound`, `binarySearch`.
public func upperBound<Ix : RandomAccessIndexType>
    (range: Range<Ix>, ord: Ix -> Ordering) -> Ix
{
    var (lo, hi) = (range.startIndex, range.endIndex)
    while lo < hi {
        let m = midIndex(lo, hi)
        (lo, hi) = ord(m) == .GT ? (lo, m) : (m.successor(), hi)
    }
    return lo
}

/// Convenience function for finding the upper bound index `i` within
/// `indices(xs)` such that:
///
/// - `ord(xs[j]) == Ordering.LT` for all `j` in `xs.startIndex ..< i`, and
/// - `ord(xs[k]) != Ordering.LT` for all `k` in `i ..< xs.endIndex`.
///
/// Precondition: `xs` must be sorted by `ord`.
///
/// Remark: For a sorted array of `Comparable`s, just pass `comparingTo(x)`
/// as `ord`.
public func upperBound<S : CollectionType where
                       S.Index : RandomAccessIndexType>
    (xs: S, ord: S.Generator.Element -> Ordering) -> S.Index
{
    return upperBound(indices(xs)) {i in ord(xs[i])}
}


// -----------------------------------------------------------------------------
// MARK: - Equal range

/// Find the subrange or `range` for which all indices `i` satisfy
/// `ord(i) == .EQ`. If there is no such range, return the empty range at the
/// point where those elements would be inserted while preserving the ordering.
///
/// **Precondition:** The `range` must be sorted by `ord`.
///
/// **Complexity:** `O(log n)` where `n` is the number of indices in `range`.
///
/// **Remark:** `equalRange(range, ord)` returns the range
/// `lowerBound(range, ord) ..< upperBound(range, ord)` but performs fewer
/// comparisons than calling `lowerBound` and `upperBound` separately.
///
/// **See also:** `lowerBound`, `upperBound`, `binarySearch`.
public func equalRange<Ix : RandomAccessIndexType>
    (range: Range<Ix>, ord: Ix -> Ordering) -> Range<Ix>
{
    let (lower, upper) = forkEqualRange(range, ord)
    return lowerBound(lower, ord) ..< upperBound(upper, ord)
}

/// Convenience function for finding the subrange `start ..< end` of
/// `indices(xs)` such that:
///
/// - `ord(xs[i]) == Ordering.LT` for all `i` in `xs.beginIndex ..< start`,
/// - `ord(xs[j]) == Ordering.EQ` for all `j` in `start ..< end`, and
/// - `ord(xs[k]) == Ordering.GT` for all `k` in `end ..< xs.endIndex`.
///
/// **Precondition:** `xs` must be sorted by `ord`.
///
/// **Remark:** For a sorted array of `Comparable`s, just pass `comparingTo(x)`
/// as `ord`.
public func equalRange<S : CollectionType where
                       S.Index : RandomAccessIndexType>
    (xs: S, ord: S.Generator.Element -> Ordering) -> Range<S.Index>
{
    return equalRange(indices(xs)) {i in ord(xs[i])}
}
