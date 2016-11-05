//
//  Sorting.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

extension Sequence {
    /// Make a sorted copy of `self` using a stable sort algorithm and the given
    /// 3-way comparator `ordering`.
    ///
    /// - FIXME: We wouldn't really need `@escaping` here but there's no way to tell the compiler.
    public func sorted(ordering: @escaping (Iterator.Element, Iterator.Element) -> Ordering)
        -> [Iterator.Element]
    {
        var array = Array(self)
        array.sort(ordering: ordering)
        return array
    }
}

extension Array {
    /// Sort `self` in place using a stable sort algorithm and the given 3-way
    /// comparator `ordering`.
    ///
    /// - FIXME: We wouldn't really need `@escaping` here but there's no way to tell the compiler.
    public mutating func sort(ordering: @escaping (Element, Element) -> Ordering) {
        var newIndices = indices.sorted {a, b -> Bool in
            return (ordering(self[a], self[b]) || (a <=> b)) == .less
        }
        self.permute(toIndices: &newIndices)
    }

    /// Reorder `self` into the permutation defined by `indices`.
    ///
    /// This function can be used to reorder multiple arrays according to the
    /// same permutation of `indices`:
    ///
    ///     var xs = ["d", "a", "c", "b"]
    ///     var ys = [10, 20, 30, 40]
    ///     var js = [1, 3, 2, 0]
    ///     xs.permuteInPlace(toIndices: &js)
    ///     print(xs, js) //=> ["a", "b", "c", "d"] [-2, -4, -3, -1]
    ///     ys.permuteInPlace(toIndices: &js)
    ///     print(ys, js) //=> [20, 40, 30, 10] [1, 2, 3, 0]
    ///
    /// - Remark: The bits of each `Int` of `indices` are inverted (i.e. `~i`)
    ///   during the process, but the resulting array of `indices` can be used
    ///   for further passes.
    ///
    /// - Precondition: `indices` must be either:
    ///
    ///   1. a permutation of every number in the range `array.indices`, or
    ///   2. a permutation of every number in `-array.count ..< -1`,
    ///
    ///   and in either case it must hold that `array.count == indices.count`.
    public mutating func permute(toIndices indices: inout [Int]) {
        precondition(count == indices.count)
        if let first = indices.first, first < 0 {
            for i in indices.indices where indices[i] < 0 {
                var j = i
                while ~indices[j] != i {
                    let k = ~indices[j]
                    swap(&self[j], &self[k])
                    (j, indices[j]) = (k, k)
                }
                indices[j] = i
            }
        } else {
            for i in indices.indices where indices[i] >= 0 {
                var j = i
                while indices[j] != i {
                    let k = indices[j]
                    swap(&self[j], &self[k])
                    (j, indices[j]) = (k, ~k)
                }
                indices[j] = ~i
            }
        }
    }
}
