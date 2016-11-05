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
        func test(_ input: [Int]) {
            let heap = buildHeap(input)
            let output = heapSorted(heap)
            XCTAssertEqual(output, input.sorted(), "Given input: \(input)")
        }
        test([1, 4, 4, 1, 3, 0, 4, 3])
        for _ in 0 ..< 100 {
            test(randomArray(count: random(0 ... 50), value: 0 ... 30))
        }
    }
    
    func testNSmallestPerformance() {
        let input = perfInput
        let top100 = Array(input.sorted()[0 ..< 100])
        measure {
            var heap = buildHeap(input)
            var output = [Int]()
            output.reserveCapacity(100)
            for _ in 0 ..< 100 {
                output.append(heap.popHeap())
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
            top100.append(heap.popHeap())
        }
        measure {
            let output = Array(input.sorted()[0 ..< 100])
            XCTAssertEqual(output, top100)
        }
    }

}

private let perfInput = randomArray(count: 20000, value: 0 ... 1000)

private func buildHeap(_ ints: [Int]) -> [Int] {
    var heap = [Int]()
    heap.reserveCapacity(ints.count)
    for i in ints {
        heap.pushHeap(i)
    }
    return heap
}

private func heapSorted(_ heap: [Int]) -> [Int] {
    var heap = heap
    var ints = [Int]()
    while !heap.isEmpty {
        ints.append(heap.popHeap())
    }
    return ints
}
