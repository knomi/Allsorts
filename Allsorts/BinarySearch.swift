//
//  BinarySearch.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

extension Collection where Index == Int, Indices == CountableRange<Int> {

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
    ///
    /// - FIXME: We wouldn't really need `@escaping` here but there's no way to tell the compiler.
    public func binaryFind(_ ordering: @escaping (Iterator.Element) throws -> Ordering) rethrows -> Index? {
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
    /// * iff there exists `j` such that `ordering(self[j]) == .equal`, then
    ///   `ordering(self[i]) == .equal`,
    /// * otherwise, `ordering(self[i]) == .greater` and `ordering(self[j]) == .less`
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
    public func binarySearch(_ ordering: (Iterator.Element) throws -> Ordering) rethrows -> Index {
        return try indices.forkEqualRange {index in
            try ordering(self[index])
        }.lower.endIndex
    }
    
    /// Find the index that splits the sorted collection `self` in
    /// strictly-lesser and greater-or-equal halves.
    ///
    /// Returns the index `i` within `startIndex...endIndex` for which
    /// `ordering(j) == .less` iff `j < i`.
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
    public func lowerBound(of ordering: (Iterator.Element) throws -> Ordering) rethrows -> Index {
        var (lo, hi) = (startIndex, endIndex)
        while lo != hi {
            let index = (lo ..< hi).midIndex
            (lo, hi) = try ordering(self[index]) == .less ? (index + 1, hi) : (lo, index)
        }
        return lo
    }
    
    /// Find the index that splits the sorted collection `self` in
    /// lesser-or-equal and strictly-greater halves.
    ///
    /// Returns the index `i` within `startIndex...endIndex` for which
    /// `ordering(j) != .greater` iff `j < i`.
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
    public func upperBound(of ordering: (Iterator.Element) throws -> Ordering) rethrows -> Index {
        var (lo, hi) = (startIndex, endIndex)
        while lo != hi {
            let index = (lo ..< hi).midIndex
            (lo, hi) = try ordering(self[index]) == .greater ? (lo, index) : (index + 1, hi)
        }
        return lo
    }

    /// Find the index range of the sorted collection `self` for which all
    /// indices `i` satisfy `ordering(i) == .equal`. If there is no such range,
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
    public func equalRange(of ordering: (Iterator.Element) throws -> Ordering) rethrows -> Range<Index> {
        let (lower, upper) = try indices.forkEqualRange {index in
            try ordering(self[index])
        }
        return try lower.lowerBound {i in try ordering(self[i])}
               ..< upper.upperBound {i in try ordering(self[i])}
    }
}

extension Collection where Index == Int, Indices == CountableRange<Int>, Iterator.Element : Comparable {
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
    public func binaryFind(_ value: Iterator.Element) -> Index? {
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
    public func binarySearch(_ value: Iterator.Element) -> Index {
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
    public func lowerBound(of value: Iterator.Element) -> Index {
        return lowerBound(of: Ordering.to(value))
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
    public func upperBound(of value: Iterator.Element) -> Index {
        return upperBound(of: Ordering.to(value))
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
    public func equalRange(of value: Iterator.Element) -> Range<Index> {
        return equalRange(of: Ordering.to(value))
    }
}

// -----------------------------------------------------------------------------
// MARK: - Private

extension CountableRange where Bound : IntegerArithmetic {
    /// The index at, or just below, the mid-point from `start` to `end`.
    internal var midIndex: Bound {
        let fullDistance = lowerBound.distance(to: upperBound)
        return lowerBound.advanced(by: fullDistance / 2)
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
    internal func forkEqualRange(_ ordering: (Bound) throws -> Ordering) rethrows
            -> (lower: CountableRange, upper: CountableRange)
    {
        var (lo, hi) = (lowerBound, upperBound)
        while lo != hi {
            let m = (lo ..< hi).midIndex
            switch try ordering(m) {
            case .less: lo = m.advanced(by: 1)
            case .equal: return (lo ..< m, m ..< hi)
            case .greater: hi = m
            }
        }
        return (lo ..< lo, lo ..< lo)
    }
}

