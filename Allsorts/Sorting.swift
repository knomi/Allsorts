//
//  Sorting.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

public func sorted<C : SequenceType>
    (source: C, compare: (C.Generator.Element,
                          C.Generator.Element) -> Ordering)
    -> [C.Generator.Element]
{
    return sorted(source) {a, b in
        compare(a, b) == .LT
    }
}

//func stableSort<T>(inout array: ContiguousArray<T>, compare: (T, T) -> Ordering)

//func stableSort<T>(inout array: [T], compare: (T, T) -> Ordering)

//func stableSort<C : MutableCollectionType
//                where C.Index : RandomAccessIndexType>
//    (inout collection: C, compare: (C.Generator.Element,
//                                    C.Generator.Element) -> Ordering)

///
public func stableSorted<C : SequenceType>
    (source: C, compare: (C.Generator.Element,
                          C.Generator.Element) -> Ordering)
    -> [C.Generator.Element]
{
    return Swift.sorted(enumerate(source)) {a, b in
        let c = compare(a.1, b.1)
        return c == .LT || c == .EQ && a.0 < b.0
    }.map {_, x in x}
}

