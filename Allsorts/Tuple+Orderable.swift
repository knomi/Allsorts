//
//  Tuple+Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Lexicographical three-way comparison between two 2-tuples.
///
/// - Remark: This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable>
    (left: (A, B), right: (A, B)) -> Ordering
{
    return left.0 <=> right.0
        || left.1 <=> right.1
}

/// Lexicographical three-way comparison between two 3-tuples.
///
/// - Remark: This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable,
                 C : Orderable>
    (left: (A, B, C),
     right: (A, B, C)) -> Ordering
{
    return left.0 <=> right.0
        || left.1 <=> right.1
        || left.2 <=> right.2
}

/// Lexicographical three-way comparison between two 4-tuples.
///
/// - Remark: This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable,
                 C : Orderable,
                 D : Orderable>
    (left: (A, B, C, D),
     right: (A, B, C, D)) -> Ordering
{
    return left.0 <=> right.0
        || left.1 <=> right.1
        || left.2 <=> right.2
        || left.3 <=> right.3
}

/// Lexicographical three-way comparison between two 5-tuples.
///
/// - Remark: This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable,
                 C : Orderable,
                 D : Orderable,
                 E : Orderable>
    (left: (A, B, C, D, E),
     right: (A, B, C, D, E)) -> Ordering
{
    return left.0 <=> right.0
        || left.1 <=> right.1
        || left.2 <=> right.2
        || left.3 <=> right.3
        || left.4 <=> right.4
}

// Five shall be enough for now.
