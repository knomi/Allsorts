//
//  SequenceType+Orderable.swift
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
/// extension protocol<S : SequenceType
///     where S.Generator.Element : Orderable
/// > : Orderable {}
/// ```

public func <=> <S : SequenceType where S.Generator.Element : Orderable>
    (left: S, right: S) -> Ordering
{
    var gl = left.generate()
    var gr = right.generate()
    while true {
        switch (gl.next(), gr.next()) {
        case     (nil, _?):  return .LT
        case     (nil, nil): return .EQ
        case     (_?,  nil): return .GT
        case let (l?,  r?):
            switch l <=> r {
            case .EQ: break
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
/// extension protocol<S : SequenceType
///     where S.Generator.Element : Orderable
/// > : Orderable {}
@warn_unused_result
public func <=> <S : SequenceType where
                 S.Generator.Element : SequenceType,
                 S.Generator.Element.Generator.Element : Orderable>
    (left: S, right: S) -> Ordering
{
    var gl = left.generate()
    var gr = right.generate()
    while true {
        switch (gl.next(), gr.next()) {
        case     (nil, _?):  return .LT
        case     (nil, nil): return .EQ
        case     (_?,  nil): return .GT
        case let (l?,  r?):
            switch l <=> r {
            case .EQ: break
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
/// extension protocol<S : SequenceType
///     where S.Generator.Element : Orderable
/// > : Orderable {}
@warn_unused_result
public func <=> <S : SequenceType where
                 S.Generator.Element : SequenceType,
                 S.Generator.Element.Generator.Element : SequenceType,
                 S.Generator.Element.Generator.Element.Generator.Element : Orderable>
    (left: S, right: S) -> Ordering
{
    var gl = left.generate()
    var gr = right.generate()
    while true {
        switch (gl.next(), gr.next()) {
        case     (nil, _?):  return .LT
        case     (nil, nil): return .EQ
        case     (_?,  nil): return .GT
        case let (l?,  r?):
            switch l <=> r {
            case .EQ: break
            case let ord: return ord
            }
        }
    }
}

// Three shall be enough for now.
