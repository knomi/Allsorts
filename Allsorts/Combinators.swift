//
//  Combinators.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Evaluate the lexicographic ordering of two comparison expressions. If `left`
/// evaluates not-equal, return its result. Else, evaluate and return `right`.
public func || (left: Ordering, right: @autoclosure () -> Ordering) -> Ordering {
    switch left {
    case .less: return .less
    case .equal: return right()
    case .greater: return .greater
    }
}

/// Lexicographical comparator composing operator. Symbol chosen because of its
/// similarity to the OR operator: returns the inequality in the left operand,
/// or else the result of the right-hand side.
infix operator <|> : ComparatorComposingPrecedence
precedencegroup ComparatorComposingPrecedence {
    associativity: right
    higherThan: LogicalConjunctionPrecedence
    lowerThan: ComparisonPrecedence
}

/// Compose two comparators lexicographically: the function short-circuits if
/// the `left` comparator evaluates different than `Ordering.equal`. Otherwise,
/// evaluates and returns the result of the `right` comparator.
///
/// - Remark: This operator is useful together with the use of `Ordering.by`.
///
/// - Seealso: `Ordering.by`. `Array.sortInPlace(ordering:)`,
///   `Sequence.sort(ordering:)`
public func <|> <Args>(left: @escaping (Args) -> Ordering,
                       right: @escaping (Args) -> Ordering)
    -> (Args) -> Ordering
{
    return {args in
        left(args) || right(args)
    }
}
