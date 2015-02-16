//
//  HeapTests.swift
//  Allsorts
//
//  Created by Pyry Jahkola on 16.02.2015.
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
//        for _ in 0 ..< 5 {
//            test(randomInput(maxCount: 10, maxValue: 5))
//        }
    }

}

func randomInput(#maxCount: Int, #maxValue: Int) -> [Int] {
    var ints = [Int]()
    let n = arc4random_uniform(UInt32(maxCount))
    for _ in 0 ... n {
        ints.append(Int(arc4random_uniform(UInt32(maxValue + 1))))
    }
    return ints
}

func buildHeap(ints: [Int]) -> [Int] {
    var heap = [Int]()
    for i in ints {
        pushHeap(&heap, i)
    }
    return heap
}

func heapSorted(var heap: [Int]) -> [Int] {
    var ints = [Int]()
    while !heap.isEmpty {
        ints.append(popHeap(&heap))
    }
    return ints
}
