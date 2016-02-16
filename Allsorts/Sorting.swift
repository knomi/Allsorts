//
//  Sorting.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Convenience function around `Swift.sorted` for sorting the elements in
/// `source` by the three-way comparator `ordering`.
///
/// - Seealso: `stableSorted`, `Ordering.by`
public func sorted<C : SequenceType>
    (source: C, _ ordering: (C.Generator.Element,
                             C.Generator.Element) -> Ordering)
    -> [C.Generator.Element]
{
    return source.sort {a, b in
        ordering(a, b) == .LT
    }
}

//func stableSort<T>(inout array: ContiguousArray<T>, _ ordering: (T, T) -> Ordering)

//func stableSort<T>(inout array: [T], _ ordering: (T, T) -> Ordering)

//func stableSort<C : MutableCollectionType
//                where C.Index : RandomAccessIndexType>
//    (inout collection: C, _ ordering: (C.Generator.Element,
//                                       C.Generator.Element) -> Ordering)

/// Sort the elements in `source` by the three-way comparator `ordering` while
/// keeping the relative ordering of equal (`Ordering.EQ`) elements.
///
/// - Remark: While asymptotically not worse in in memory usage or performance
/// than `Swift.sorted`, the current implementation does some extra work and
/// comparisons, e.g. allocating an array of indices to preserve the order. This
/// implementation is hopefully replaced with a more efficient one in the
/// future.
///
/// - Seealso: `sorted`, `Ordering.by`
public func stableSorted<C : SequenceType>
    (source: C, _ ordering: (C.Generator.Element,
                             C.Generator.Element) -> Ordering)
    -> [C.Generator.Element]
{
    return source.enumerate().sort {a, b in
        let c = ordering(a.1, b.1)
        return c == .LT || c == .EQ && a.0 < b.0
    }.map {_, x in x}
}

