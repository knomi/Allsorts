//
//  Heap.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Push `value` into the min-heap `heap`, as defined by the less-than
/// comparison `isOrderedBefore`.
public func pushHeap<T>(inout heap: [T],
                        value: T,
                        isOrderedBefore: (T, T) -> Bool)
{
    heap.append(value)
    siftUp(&heap, heap.startIndex, heap.endIndex, isOrderedBefore, heap.count)
}
 
/// Push `value` into the min-heap `heap`, as defined by `<`.
public func pushHeap<T: Comparable>(inout heap: [T], value: T) {
    pushHeap(&heap, value) {a, b in a < b}
}
 
/// Push `value` into the min-heap `heap`, as defined by the comparator
/// `compare`.
public func pushHeap<T>(inout heap: [T], value: T, compare: (T, T) -> Ordering)
{
    pushHeap(&heap, value) {a, b in compare(a, b) == .LT}
}
 
/// Pop the min-element from the min-heap `heap`, as defined by the
/// less-than comparison `isOrderedBefore`.
public func popHeap<T>(inout heap: [T], isOrderedBefore: (T, T) -> Bool) -> T {
    precondition(!heap.isEmpty, "cannot pop an empty heap")
    swap(&heap[heap.startIndex], &heap[heap.endIndex - 1])
    siftDown(&heap, heap.startIndex, heap.endIndex - 1,
             isOrderedBefore, heap.count - 1, heap.startIndex)
    let result = heap.removeLast()
    return result
}
 
/// Pop the min-element from the min-heap `heap`, as defined by `<`.
public func popHeap<T: Comparable>(inout heap: [T]) -> T {
    return popHeap(&heap) {a, b in a < b}
}

/// Pop the min-element from the min-heap `heap`, as defined by the comparator
/// `compare`.
public func popHeap<T>(inout heap: [T], compare: (T, T) -> Ordering) -> T {
    return popHeap(&heap) {a, b in compare(a, b) == .LT}
}

// -----------------------------------------------------------------------------
// MARK: - Private

// Ported from https://llvm.org/svn/llvm-project/libcxx/trunk/include/algorithm
// (Flipped the comparator though to make `heap` into a min-heap.)
func siftDown<T>(inout heap: [T],
                 var first: Int,
                 var last: Int,
                 isOrderedBefore: (T, T) -> Bool,
                 var len: Int,
                 var start: Int)
{
    // heap array representation:
    //                 0                             i
    //           _____/ \_____                  ____/ \____
    //          /             \                /           \
    //         1               2             2i+1         2i+2
    //       _/ \_           _/ \_          _/ \_         _/ \_
    //      /     \         /     \        /     \       /     \
    //     3       4       5       6     4i+3   4i+4   4i+5   4i+6
    //    / \     / \     / \     / \    ...     ...   ...     ...
    //   7   8   9  10  11  12  13  14
    //
    // left-child of start is at `2 * index + 1`
    // right-child of start is at `2 * index + 2`
    var child = start - first

    if (len < 2 || (len - 2) / 2 < child) {
        return
    }

    child = 2 * child + 1;
    var child_i = first + child

    if child + 1 < len && isOrderedBefore(heap[child_i + 1], heap[child_i]) {
        // right-child exists and is less than left-child
        ++child_i
        ++child
    }

    // check if we are in heap-order
    if isOrderedBefore(heap[start], heap[child_i]) {
        // we are, start is smaller than its smallest child
        return
    }

    let top = heap[start]
    do {
        // we are not in heap-order, swap the parent with its smallest child
        heap[start] = heap[child_i]
        start = child_i;

        if ((len - 2) / 2 < child) {
            break
        }

        // recompute the child based off of the updated parent
        child = 2 * child + 1
        child_i = first + child

        if child + 1 < len && isOrderedBefore(heap[child_i + 1], heap[child_i]) {
            // right-child exists and is less than left-child
            ++child_i
            ++child
        }

        // check if we are in heap-order
    } while (!isOrderedBefore(top, heap[child_i]))
    heap[start] = top
}


// Ported from https://llvm.org/svn/llvm-project/libcxx/trunk/include/algorithm
// (Flipped the comparator though to make `heap` into a min-heap.)
private func siftUp<T>(inout heap: [T],
                       var first: Int,
                       var last: Int,
                       isOrderedBefore: (T, T) -> Bool,
                       var len: Int)
{
    if len <= 1 {
        return
    }
    len = (len - 2) / 2
    var index = first + len
    last -= 1
    if (isOrderedBefore(heap[last], heap[index])) {
        let t = heap[last]
        do {
            heap[last] = heap[index]
            last = index
            if len == 0 {
                break
            }
            len = (len - 1) / 2
            index = first + len
        } while (isOrderedBefore(t, heap[index]))
        heap[last] = t
    }
}
