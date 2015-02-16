//
//  Heap.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation

/// Push `value` into the min-heap `xs`, as defined by the less-than
/// comparison `comp`.
public func pushHeap<T>(inout xs: [T], value: T, comp: (T, T) -> Bool) {
    xs.append(value)
    pushHeapBack(&xs, comp)
}
 
/// Push `value` into the min-heap `xs`, as defined by `<`.
public func pushHeap<T: Comparable>(inout xs: [T], value: T) {
    pushHeap(&xs, value) {$0 < $1}
}
 
/// Pop the min-element from the min-heap `xs`, as defined by the
/// less-than comparison `comp`.
public func popHeap<T>(inout xs: [T], comp: (T, T) -> Bool) -> T {
    precondition(!xs.isEmpty, "cannot pop an empty heap")
    swap(&xs[0], &xs[xs.endIndex - 1])
    let result = xs.removeLast()
    pushHeapFront(&xs, comp)
    return result
}
 
/// Pop the min-element from the min-heap `xs`, as defined by `<`.
public func popHeap<T: Comparable>(inout xs: [T]) -> T {
    return popHeap(&xs) {$0 < $1}
}


// -----------------------------------------------------------------------------
// MARK: - Private

// Ported from https://llvm.org/svn/llvm-project/libcxx/trunk/include/algorithm
// (Flipped `comp` though to make `xs` into a min-heap.)
private func pushHeapFront<T>(inout xs: [T], comp: (T, T) -> Bool) {
    let n = xs.count
    if n <= 1 {
        return
    }
    var p = 0
    var pp = 0
    var c = 2
    var cp = pp + c
    if c == n || comp(xs[cp - 1], xs[cp]) {
        --c
        --cp
    }
    if comp(xs[cp], xs[pp]) {
        let t = xs[pp]
        do {
            xs[pp] = xs[cp]
            pp = cp
            p = c
            c = 2 * (p + 1)
            if c > n {
                break
            }
            cp = c
            if c == n || comp(xs[cp - 1], xs[cp]) {
                --c
                --cp
            }
        } while comp(t, xs[cp])
        xs[pp] = t
    }
}
 
// Ported from https://llvm.org/svn/llvm-project/libcxx/trunk/include/algorithm
// (Flipped `comp` though to make `xs` into a min-heap.)
private func pushHeapBack<T>(inout xs: [T], comp: (T, T) -> Bool) {
    var i = xs.count
    if i <= 1 {
        return
    }
    var j = i - 1
    i = (i - 2) / 2
    if comp(xs[j], xs[i]) {
        let t = xs[j]
        do {
            xs[j] = xs[i]
            j = i
            if (i == 0) {
                break
            }
            i = (i - 1) / 2
        } while comp(t, xs[i])
        xs[j] = t
    }
}
