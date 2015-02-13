//
//  Compare_Tuple.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Lexicographical three-way comparison between two 2-tuples.
///
/// **Remark:** This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable>
    (lhs: (A, B), rhs: (A, B)) -> Ordering
{
    return lhs.0 <=> rhs.0
        || lhs.1 <=> rhs.1
}

/// Lexicographical three-way comparison between two 3-tuples.
///
/// **Remark:** This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable,
                 C : Orderable>
    (lhs: (A, B, C),
     rhs: (A, B, C)) -> Ordering
{
    return lhs.0 <=> rhs.0
        || lhs.1 <=> rhs.1
        || lhs.2 <=> rhs.2
}

/// Lexicographical three-way comparison between two 4-tuples.
///
/// **Remark:** This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable,
                 C : Orderable,
                 D : Orderable>
    (lhs: (A, B, C, D),
     rhs: (A, B, C, D)) -> Ordering
{
    return lhs.0 <=> rhs.0
        || lhs.1 <=> rhs.1
        || lhs.2 <=> rhs.2
        || lhs.3 <=> rhs.3
}

/// Lexicographical three-way comparison between two 5-tuples.
///
/// **Remark:** This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, in particular as of Swift 1.2,
/// it is impossible to extend a tuple to implement a protocol.
public func <=> <A : Orderable,
                 B : Orderable,
                 C : Orderable,
                 D : Orderable,
                 E : Orderable>
    (lhs: (A, B, C, D, E),
     rhs: (A, B, C, D, E)) -> Ordering
{
    return lhs.0 <=> rhs.0
        || lhs.1 <=> rhs.1
        || lhs.2 <=> rhs.2
        || lhs.3 <=> rhs.3
        || lhs.4 <=> rhs.4
}

// Five shall be enough for now.
