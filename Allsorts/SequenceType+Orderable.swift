//
//  Sequence+Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Lexicographical three-way comparison between two sequences of
/// `ThreeWayComparable`\ s.
///
/// - Remark: This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, i.e. as of Swift 1.2, it is
/// impossible to say:
///
/// ```
/// extension protocol<S : Sequence
///     where S.Iterator.Element : Orderable
/// > : Orderable {}
/// ```

public func <=> <S : Sequence>
    (left: S, right: S) -> Ordering where S.Iterator.Element : Orderable
{
    var gl = left.makeIterator()
    var gr = right.makeIterator()
    while true {
        switch (gl.next(), gr.next()) {
        case     (nil, _?):  return .less
        case     (nil, nil): return .equal
        case     (_?,  nil): return .greater
        case let (l?,  r?):
            switch l <=> r {
            case .equal: break
            case let ord: return ord
            }
        }
    }
}

/// Lexicographical three-way comparison between two sequences of sequences of
/// `ThreeWayComparable`\ s.
///
/// - Remark: This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, i.e. as of Swift 1.2, it is
/// impossible to say:
///
/// ```
/// extension protocol<S : Sequence
///     where S.Iterator.Element : Orderable
/// > : Orderable {}
public func <=> <S : Sequence>
    (left: S, right: S) -> Ordering
    where
    S.Iterator.Element : Sequence,
    S.Iterator.Element.Iterator.Element : Orderable
{
    var gl = left.makeIterator()
    var gr = right.makeIterator()
    while true {
        switch (gl.next(), gr.next()) {
        case     (nil, _?):  return .less
        case     (nil, nil): return .equal
        case     (_?,  nil): return .greater
        case let (l?,  r?):
            switch l <=> r {
            case .equal: break
            case let ord: return ord
            }
        }
    }
}

/// Lexicographical three-way comparison between two sequences of sequences of
/// sequences of `ThreeWayComparable`\ s.
///
/// - Remark: This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, i.e. as of Swift 1.2, it is
/// impossible to say:
///
/// ```
/// extension protocol<S : Sequence
///     where S.Iterator.Element : Orderable
/// > : Orderable {}
public func <=> <S : Sequence>
    (left: S, right: S) -> Ordering
    where
    S.Iterator.Element : Sequence,
    S.Iterator.Element.Iterator.Element : Sequence,
    S.Iterator.Element.Iterator.Element.Iterator.Element : Orderable
{
    var gl = left.makeIterator()
    var gr = right.makeIterator()
    while true {
        switch (gl.next(), gr.next()) {
        case     (nil, _?):  return .less
        case     (nil, nil): return .equal
        case     (_?,  nil): return .greater
        case let (l?,  r?):
            switch l <=> r {
            case .equal: break
            case let ord: return ord
            }
        }
    }
}

// Three shall be enough for now.
