//
//  Heap.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

extension Array {

    /// Push `value` into the min-heap `heap`, as defined by the less-than
    /// comparison `isOrderedBefore`.
    public mutating func pushHeap(_ value: Element, isOrderedBefore: (Element, Element) -> Bool) {
        append(value)
        siftUp(heap: &self, startIndex: startIndex, endIndex: endIndex, isOrderedBefore: isOrderedBefore, len: count)
    }

    /// Push `value` into the min-heap `heap`, as defined by the comparator
    /// `compare`.
    public mutating func pushHeap(_ value: Element, _ ordering: (Element, Element) -> Ordering) {
        pushHeap(value) {a, b in ordering(a, b) == .less}
    }
     
    /// Pop the min-element from the min-heap `heap`, as defined by the
    /// less-than comparison `isOrderedBefore`.
    ///
    /// Requires: The array must not be empty.
    public mutating func popHeap(isOrderedBefore: (Element, Element) -> Bool) -> Element {
        precondition(!isEmpty, "cannot pop an empty heap")
        if count > 1 {
            swap(&self[startIndex], &self[endIndex - 1])
        }
        siftDown(heap: &self, startIndex: startIndex, endIndex: endIndex - 1,
                 isOrderedBefore: isOrderedBefore, len: count - 1, rootIndex: startIndex)
        let result = removeLast()
        return result
    }
     
    /// Pop the min-element from the min-heap `heap`, as defined by the comparator
    /// `compare`.
    ///
    /// Requires: The array must not be empty.
    public mutating func popHeap(ordering: (Element, Element) -> Ordering) -> Element {
        return popHeap {a, b in ordering(a, b) == .less}
    }

}

extension Array where Element : Comparable {

    /// Push `value` into the min-heap `heap`, as defined by `<`.
    public mutating func pushHeap(_ value: Element) {
        pushHeap(value) {a, b in a < b}
    }
     
    /// Pop the min-element from the min-heap `heap`, as defined by `<`.
    ///
    /// Precondition: The array must not be empty.
    public mutating func popHeap() -> Element {
        return popHeap {a, b in a < b}
    }

}

// -----------------------------------------------------------------------------
// MARK: - Private

// Ported from https://llvm.org/svn/llvm-project/libcxx/trunk/include/algorithm
// (Flipped the comparator though to make `heap` into a min-heap.)
func siftDown<T>
    (heap: inout Array<T>,
     startIndex: Array<T>.Index,
     endIndex: Array<T>.Index,
     isOrderedBefore: (Array<T>.Iterator.Element, Array<T>.Iterator.Element) -> Bool,
     len: Array<T>.IndexDistance,
     rootIndex: Array<T>.Index)
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
    // left-child of `index` is at `2 * index + 1`
    // right-child of `index` is at `2 * index + 2`
    var rootIndex = rootIndex
    var child = startIndex.distance(to: rootIndex)
    if (len < 2 || (len - 2) / 2 < child) {
        return
    }
    
    assert((startIndex ..< endIndex).contains(rootIndex))
    assert(rootIndex.advanced(by: len) <= endIndex)

    child = 2 * child + 1;
    var childIndex = startIndex.advanced(by: child)

    if child + 1 < len && isOrderedBefore(heap[childIndex + 1], heap[childIndex]) {
        // right-child exists and is less than left-child
        childIndex += 1
        child += 1
    }

    // check if we are in heap-order
    if isOrderedBefore(heap[rootIndex], heap[childIndex]) {
        // we are, root is smaller than its smallest child
        return
    }

    let top = heap[rootIndex]
    repeat {
        // we are not in heap-order, swap the parent with its smallest child
        heap[rootIndex] = heap[childIndex]
        rootIndex = childIndex;

        if (len - 2) / 2 < child {
            break
        }

        // recompute the child based off of the updated parent
        child = 2 * child + 1
        childIndex = startIndex.advanced(by: child)

        if child + 1 < len && isOrderedBefore(heap[childIndex + 1], heap[childIndex]) {
            // right-child exists and is less than left-child
            childIndex += 1
            child += 1
        }

        // check if we are in heap-order
    } while !isOrderedBefore(top, heap[childIndex])
    heap[rootIndex] = top
}


// Ported from https://llvm.org/svn/llvm-project/libcxx/trunk/include/algorithm
// (Flipped the comparator though to make `heap` into a min-heap.)
private func siftUp<T>
    (heap: inout Array<T>,
     startIndex: Array<T>.Index,
     endIndex: Array<T>.Index,
     isOrderedBefore: (Array<T>.Iterator.Element, Array<T>.Iterator.Element) -> Bool,
     len: Array<T>.IndexDistance)
{
    if len <= 1 {
        return
    }
    var len = (len - 2) / 2
    var index = startIndex.advanced(by: len)
    var lastIndex = endIndex - 1
    if isOrderedBefore(heap[lastIndex], heap[index]) {
        let t = heap[lastIndex]
        repeat {
            heap[lastIndex] = heap[index]
            lastIndex = index
            if len == 0 {
                break
            }
            len = (len - 1) / 2
            index = startIndex.advanced(by: len)
        } while isOrderedBefore(t, heap[index])
        heap[lastIndex] = t
    }
}
