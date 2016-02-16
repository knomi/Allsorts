//
//  BinarySearch.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

extension CollectionType where Index : RandomAccessIndexType {

    /// Find an index that compares equal as against the given `ordering` of
    /// the sorted collection `self`. If none is found, returns `nil`.
    ///
    /// - Precondition: `self` **must** be sorted by `ordering`, i.e. for all
    ///   index pairs `i < j`, `ordering(self[i]) <= ordering(self[j])`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: For a collection of `Comparable`s sorted by `<`, pass
    ///   `Ordering.to(x)` as `ordering`, or just call `coll.binaryFind(x)`.
    ///
    /// - Seealso: `binarySearch`, `equalRange`, `lowerBound`, `upperBound`.
    @warn_unused_result
    public func binaryFind(@noescape ordering: Generator.Element throws -> Ordering) rethrows -> Index? {
        let (lower: lower, upper: upper) = try indices.forkEqualRange {index in
            try ordering(self[index])
        }
        guard lower.startIndex != upper.endIndex else {
            return nil
        }
        return lower.endIndex
    }

    /// Find an index that splits the sorted collection `self` in
    /// lesser-or-equal and greater-or-equal halves. Additionally, if one or
    /// more equally comparing values exist, then it is guaranteed that the
    /// returned index has value comparing equal.
    ///
    /// Returns an arbitrary index `i` within `startIndex...endIndex` such that:
    ///
    /// * iff there exists `j` such that `ordering(self[j]) == .EQ`, then
    ///   `ordering(self[i]) == .EQ`,
    /// * otherwise, `ordering(self[i]) == .GT` and `ordering(self[j]) == .LT`
    ///   for all `j < i`.
    ///
    /// - Precondition: `self` **must** be sorted by `ordering`, i.e. for all
    ///   index pairs `i < j`, `ordering(self[i]) <= ordering(self[j])`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: For a collection of `Comparable`s sorted by `<`, pass
    ///   `Ordering.to(x)` as `ordering`, or just call `coll.binarySearch(x)`.
    ///
    /// - Seealso: `binaryFind`, `equalRange`, `lowerBound`, `upperBound`.
    @warn_unused_result
    public func binarySearch(@noescape ordering: Generator.Element throws -> Ordering) rethrows -> Index {
        return try indices.forkEqualRange {index in
            try ordering(self[index])
        }.lower.endIndex
    }
    
    /// Find the index that splits the sorted collection `self` in
    /// strictly-lesser and greater-or-equal halves.
    ///
    /// Returns the index `i` within `startIndex...endIndex` for which
    /// `ordering(j) == .LT` iff `j < i`.
    ///
    /// - Precondition: `self` **must** be sorted by `ordering`, i.e. for all
    ///   index pairs `i < j`, `ordering(self[i]) <= ordering(self[j])`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: For a collection of `Comparable`s sorted by `<`, pass
    ///   `Ordering.to(x)` as `ordering`, or just call `coll.lowerBound(x)`.
    ///
    /// - Seealso: `binarySearch`, `binaryFind`, `equalRange`, `upperBound`.
    @warn_unused_result
    public func lowerBound(@noescape ordering: Generator.Element throws -> Ordering) rethrows -> Index {
        var (lo, hi) = (startIndex, endIndex)
        while lo < hi {
            let index = (lo ..< hi).midIndex
            (lo, hi) = try ordering(self[index]) == .LT ? (index.successor(), hi) : (lo, index)
        }
        return lo
    }
    
    /// Find the index that splits the sorted collection `self` in
    /// lesser-or-equal and strictly-greater halves.
    ///
    /// Returns the index `i` within `startIndex...endIndex` for which
    /// `ordering(j) != .GT` iff `j < i`.
    ///
    /// - Precondition: `self` **must** be sorted by `ordering`, i.e. for all
    ///   index pairs `i < j`, `ordering(self[i]) <= ordering(self[j])`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: For a collection of `Comparable`s sorted by `<`, pass
    ///   `Ordering.to(x)` as `ordering`, or just call `coll.upperBound(x)`.
    ///
    /// - Seealso: `binarySearch`, `binaryFind`, `equalRange`, `lowerBound`.
    @warn_unused_result
    public func upperBound(@noescape ordering: Generator.Element throws -> Ordering) rethrows -> Index {
        var (lo, hi) = (startIndex, endIndex)
        while lo < hi {
            let index = (lo ..< hi).midIndex
            (lo, hi) = try ordering(self[index]) == .GT ? (lo, index) : (index.successor(), hi)
        }
        return lo
    }

    /// Find the index range of the sorted collection `self` for which all
    /// indices `i` satisfy `ordering(i) == .EQ`. If there is no such range,
    /// return the empty range at the point where those elements would be
    /// inserted while preserving the ordering.
    ///
    /// - Precondition: `self` **must** be sorted by `ordering`, i.e. for all
    ///   index pairs `i < j`, `ordering(self[i]) <= ordering(self[j])`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: `coll.equalRange(ord)` returns the range
    ///   `coll.lowerBound(ord) ..< coll.upperBound(ord)` but
    ///   performs fewer comparisons than calling `lowerBound` and `upperBound`
    ///   separately.
    ///
    /// - Remark: For a collection of `Comparable`s sorted by `<`, pass
    ///   `Ordering.to(x)` as `ordering`, or just call `coll.equalRange(x)`.
    ///
    /// - Seealso: `binarySearch`, `binaryFind`, `lowerBound`, `upperBound`.
    @warn_unused_result
    public func equalRange(@noescape ordering: Generator.Element throws -> Ordering) rethrows -> Range<Index> {
        let (lower, upper) = try indices.forkEqualRange {index in
            try ordering(self[index])
        }
        return try lower.lowerBound {i in try ordering(self[i])}
               ..< upper.upperBound {i in try ordering(self[i])}
    }
}

extension CollectionType where Index : RandomAccessIndexType, Generator.Element : Comparable {
    /// Find an index that compares equal to `value` in the sorted collection
    /// `self`. If none is found, returns `nil`.
    ///
    /// - Precondition: `self` **must** be sorted by `<`, i.e. for all
    ///   index pairs `i < j`, `self[i] <= self[j]`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: This is a convenience overload of `binaryFind(_:)` using
    ///   `Ordering.to(value)` as `ordering`.
    ///
    /// - Seealso: `binarySearch`, `equalRange`, `lowerBound`, `upperBound`.
    @warn_unused_result
    public func binaryFind(value: Generator.Element) -> Index? {
        return binaryFind(Ordering.to(value))
    }

    /// Find an index that splits the sorted collection `self` in
    /// lesser-or-equal and greater-or-equal halves compared to `value`.
    /// Additionally, if one or more values equal to `value` exist, then it is
    /// guaranteed that the returned index has value comparing equal to `value`.
    ///
    /// Returns an arbitrary index `i` within `startIndex...endIndex` such that:
    ///
    /// * iff there exists `j` such that `self[j] == value`, then
    ///   `self[i] == value`,
    /// * otherwise, `self[i] > value` and for all `j < i`, `self[j] < value`.
    ///
    /// - Precondition: `self` **must** be sorted by `<`, i.e. for all
    ///   index pairs `i < j`, `self[i] <= self[j]`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: This is a convenience overload of `binarySearch(_:)` using
    ///   `Ordering.to(value)` as `ordering`.
    ///
    /// - Seealso: `binaryFind`, `equalRange`, `lowerBound`, `upperBound`.
    @warn_unused_result
    public func binarySearch(value: Generator.Element) -> Index {
        return binarySearch(Ordering.to(value))
    }

    /// Find the index that splits the sorted collection `self` in
    /// strictly-lesser and greater-or-equal halves compared to `value`.
    ///
    /// Returns the index `i` within `startIndex...endIndex` for which
    /// `self[j] < value` iff `j < i`.
    ///
    /// - Precondition: `self` **must** be sorted by `<`, i.e. for all
    ///   index pairs `i < j`, `self[i] <= self[j]`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: This is a convenience overload of `lowerBound(_:)` using
    ///   `Ordering.to(value)` as `ordering`.
    ///
    /// - Seealso: `binarySearch`, `binaryFind`, `equalRange`, `upperBound`.
    @warn_unused_result
    public func lowerBound(value: Generator.Element) -> Index {
        return lowerBound(Ordering.to(value))
    }

    /// Find the index that splits the sorted collection `self` in
    /// lesser-or-equal and strictly-greater halves compared to `value`.
    ///
    /// Returns the index `i` within `startIndex...endIndex` for which
    /// `self[j] <= value` iff `j < i`.
    ///
    /// - Precondition: `self` **must** be sorted by `<`, i.e. for all
    ///   index pairs `i < j`, `self[i] <= self[j]`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: This is a convenience overload of `upperBound(_:)` using
    ///   `Ordering.to(value)` as `ordering`.
    ///
    /// - Seealso: `binarySearch`, `binaryFind`, `equalRange`, `lowerBound`.
    @warn_unused_result
    public func upperBound(value: Generator.Element) -> Index {
        return upperBound(Ordering.to(value))
    }

    /// Find the index range of the sorted collection `self` containing all
    /// indices `i` that compare equal to `value`. If there is no such range,
    /// returns the empty range at the point where those elements would be
    /// inserted while preserving the ordering.
    ///
    /// - Precondition: `self` **must** be sorted by `<`, i.e. for all
    ///   index pairs `i < j`, `self[i] <= self[j]`.
    ///
    /// - Complexity: `O(log n)` where `n` is the number of elements in `self`.
    ///
    /// - Remark: `coll.equalRange(value)` returns the range
    ///   `coll.lowerBound(value) ..< coll.upperBound(value)` but
    ///   performs fewer comparisons than calling `lowerBound` and `upperBound`
    ///   separately.
    ///
    /// - Remark: This is a convenience overload of `equalRange(_:)` using
    ///   `Ordering.to(value)` as `ordering`.
    ///
    /// - Seealso: `binarySearch`, `binaryFind`, `lowerBound`, `upperBound`.
    @warn_unused_result
    public func equalRange(value: Generator.Element) -> Range<Index> {
        return equalRange(Ordering.to(value))
    }
}

// -----------------------------------------------------------------------------
// MARK: - Private

extension Range where Element : RandomAccessIndexType {
    /// The index at, or just below, the mid-point from `start` to `end`.
    internal var midIndex: Element {
        let fullDistance = startIndex.distanceTo(endIndex)
        return startIndex.advancedBy(fullDistance / 2)
    }

    /// Arbitrarily find two subranges `(lower, upper)` of `self` such that:
    ///
    /// * `lower.endIndex == upper.startIndex`,
    /// * `lower.lowerBound(ord) == self.lowerBound(ord)`, and
    /// * `upper.upperBound(ord) == self.upperBound(ord)`.
    ///
    /// - Precondition: `self` **must** be sorted by `ordering`.
    ///
    /// - Complexity: `O(n)` where `n` is the number of indices in the `range`.
    ///
    /// - Remark: Note that the subranges may be empty.
    ///
    /// - Seealso: `binarySearch`, `lowerBound`, `upperBound` and `equalRange`
    @warn_unused_result
    internal func forkEqualRange(@noescape ordering: Element throws -> Ordering) rethrows
            -> (lower: Range, upper: Range)
    {
        var (lo, hi) = (startIndex, endIndex)
        while lo < hi {
            let m = (lo ..< hi).midIndex
            switch try ordering(m) {
            case .LT: lo = m.successor()
            case .EQ: return (lo ..< m, m ..< hi)
            case .GT: hi = m
            }
        }
        return (lo ..< lo, lo ..< lo)
    }
}

