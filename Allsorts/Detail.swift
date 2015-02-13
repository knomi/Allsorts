//
//  Detail.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Compute the index at, or just below, the mid-point from `start` to `end`.
internal func midIndex<Ix : RandomAccessIndexType>(start: Ix, end: Ix) -> Ix {
    return start.advancedBy(start.distanceTo(end) / 2)
}

/// Arbitrarily find two subranges `(lower, upper)` of `range` such that:
///
/// - `lower.endIndex == upper.startIndex`,
/// - `lowerBound(lower, ord) == lowerBound(range, ord)`, and
/// - `upperBound(upper, ord) == upperBound(range, ord)`.
///
/// **Precondition:** The `range` must be sorted by `ord`.
///
/// **Complexity:** `O(n)` where `n` is the number of indices in the `range`.
///
/// **Remark:** Note that the subranges may
///
/// **See also:** `lowerBound`, `upperBound` and `equalRange`
internal func forkEqualRange<Ix : RandomAccessIndexType>
    (range: Range<Ix>, ord: Ix -> Ordering) -> (lower: Range<Ix>,
                                                upper: Range<Ix>)
{
    var (lo, hi) = (range.startIndex, range.endIndex)
    while lo < hi {
        let m = midIndex(lo, hi)
        switch ord(m) {
        case .LT: lo = m.successor()
        case .EQ: return (lo ..< m, m ..< hi)
        case .GT: hi = m
        }
    }
    return (lo ..< lo, lo ..< lo)
}
