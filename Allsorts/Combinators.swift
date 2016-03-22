//
//  Combinators.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Evaluate the lexicographic ordering of two comparison expressions. If `left`
/// evaluates not-equal, return its result. Else, evaluate and return `right`.
@warn_unused_result
public func || (left: Ordering, @autoclosure right: () -> Ordering) -> Ordering {
    switch left {
    case .LT: return .LT
    case .EQ: return right()
    case .GT: return .GT
    }
}

/// Lexicographical comparator composing operator. Symbol chosen because of its
/// similarity to the OR operator: returns the inequality in the left operand,
/// or else the result of the right-hand side.
infix operator <|> {
    associativity right
    precedence 121 // one higher than `&&`, and lower than `==` etc.
}

/// Compose two comparators lexicographically: the function short-circuits if
/// the `left` comparator evaluates different than `Ordering.EQ`. Otherwise,
/// evaluates and returns the result of the `right` comparator.
///
/// - Remark: This operator is useful together with the use of `Ordering.by`.
///
/// - Seealso: `Ordering.by`. `Array.sortInPlace(ordering:)`,
///   `SequenceType.sort(ordering:)`
@warn_unused_result
public func <|> <Args>(left: Args -> Ordering, right: Args -> Ordering) -> Args -> Ordering {
    return {args in
        left(args) || right(args)
    }
}
