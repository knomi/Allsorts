//
//  HeapTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation
import XCTest
import Allsorts

class HeapTests : XCTestCase {

    func testHeap() {
        func test(input: [Int]) {
            let heap = buildHeap(input)
            let output = heapSorted(heap)
            XCTAssertEqual(output, sorted(input), "Given input: \(input)")
        }
        test([1, 4, 4, 1, 3, 0, 4, 3])
        for _ in 0 ..< 100 {
            test(randomArray(count: random(0 ... 50), value: 0 ... 30))
        }
    }
    
    func testNSmallestPerformance() {
        let input = perfInput
        let top100 = Array(sorted(input)[0 ..< 100])
        measureBlock {
            var heap = buildHeap(input)
            var output = [Int]()
            output.reserveCapacity(100)
            for _ in 0 ..< 100 {
                output.append(popHeap(&heap))
            }
            XCTAssertEqual(output, top100)
        }
    }

    func testNSmallestSortedPerformance() {
        let input = perfInput
        var heap = buildHeap(input)
        var top100 = [Int]()
        top100.reserveCapacity(100)
        for _ in 0 ..< 100 {
            top100.append(popHeap(&heap))
        }
        measureBlock {
            let output = Array(sorted(input)[0 ..< 100])
            XCTAssertEqual(output, top100)
        }
    }

}

private let perfInput = randomArray(count: 20000, value: 0 ... 1000)

// MARK: - Random numbers

private func bitwiseCeil<T : UnsignedIntegerType>(x: T) -> T {
    var i = ~T(0)
    while ~i < x {
        i = T.multiplyWithOverflow(i, 2).0
    }
    return ~i
}

private func randomMax<T : UnsignedIntegerType>(max: T) -> T {
    let m = bitwiseCeil(max)
    var buf = T(0)
    do {
        arc4random_buf(&buf, sizeof(UInt.self))
        buf &= m
    } while buf > max
    return buf
}

private func random<T : UnsignedIntegerType>(interval: ClosedInterval<T>) -> T {
    let a = interval.start
    let b = interval.end
    return a + randomMax(b - a)
}

private func random(interval: ClosedInterval<Int>) -> Int {
    let a = UInt(bitPattern: interval.start)
    let b = UInt(bitPattern: interval.end)
    let n = b - a
    return Int(bitPattern: UInt.addWithOverflow(a, randomMax(n)).0)
}

private func randomArray(#count: Int,
                         #value: ClosedInterval<Int>) -> [Int]
{
    var ints = [Int]()
    for _ in 0 ..< count {
        ints.append(random(value))
    }
    return ints
}

private func buildHeap(ints: [Int]) -> [Int] {
    var heap = [Int]()
    heap.reserveCapacity(ints.count)
    for i in ints {
        pushHeap(&heap, i)
    }
    return heap
}

private func heapSorted(var heap: [Int]) -> [Int] {
    var ints = [Int]()
    while !heap.isEmpty {
        ints.append(popHeap(&heap))
    }
    return ints
}
