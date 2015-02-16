//
//  BinarySearchTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

// -----------------------------------------------------------------------------
// MARK: - Test data

private let empty = [Int]()
private let tens  = [ 0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
private let dupes = [10, 20, 20, 30, 30, 30, 40, 40, 40, 40, 50, 50, 50, 50, 50]

// -----------------------------------------------------------------------------
// MARK: - BinarySearchTests

class BinarySearchTests : XCTestCase {

    func testBinarySearch() {
        XCTAssertEqual(0, binarySearch(empty, comparingTo(0)))
        XCTAssertEqual(0, binarySearch(empty, comparingTo(33)))
        XCTAssertEqual(0, binarySearch(empty, comparingTo(100)))

        for i in 0 ... 10 {
            XCTAssertEqual(i, binarySearch(tens, comparingTo(10 * i)), "where i = \(i)")
            XCTAssertEqual(i, binarySearch(tens, comparingTo(10 * i - 1)), "where i = \(i)")
            XCTAssertEqual(i, binarySearch(tens, comparingTo(10 * i - 9)), "where i = \(i)")
        }

        XCTAssertEqual(0, binarySearch(dupes, comparingTo(0)))
        XCTAssertEqual(dupes.count, binarySearch(dupes, comparingTo(10 * dupes.count + 1)))
        for i in 1 ... 5 {
            let a = i * (i - 1) / 2
            let b = a + i
            AssertContains(a ..< b, binarySearch(dupes, comparingTo(10 * i)), "where i = \(i)")
            XCTAssertEqual(a, binarySearch(dupes, comparingTo(10 * i - 1)), "where i = \(i)")
            XCTAssertEqual(a, binarySearch(dupes, comparingTo(10 * i - 9)), "where i = \(i)")
        }
    }
    
}
