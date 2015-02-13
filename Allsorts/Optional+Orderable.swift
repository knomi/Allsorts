//
//  Optional+Orderable.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Three-way compare two `Optional`\ s of `ThreeWayComparable`. By convention,
/// `.None` compares greater than `.Some(x)`.
///
/// (Rationale: We usually are interested in the _existing_ values, not the
/// missing ones, so existing values appear first in an array sorted by `<=>`.)
///
/// **Remark:** This is hopefully a temporary hack to circumvent impossibility
/// of adding protocol conformance conditionally, i.e. as of Swift 1.2, it is
/// impossible to say:
///
/// ```
/// extension Optional<T : Orderable> : Orderable {}
/// ```
public func <=> <T : Orderable>(lhs: T?, rhs: T?) -> Ordering {
    switch (lhs, rhs) {
    case     (.Some,    .None   ): return .LT
    case     (.None,    .None   ): return .EQ
    case     (.None,    .Some   ): return .GT
    case let (.Some(l), .Some(r)): return l <=> r
    }
}
