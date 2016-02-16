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
        XCTAssertEqual(0, empty.binarySearch(0))
        XCTAssertEqual(0, empty.binarySearch(33))
        XCTAssertEqual(0, empty.binarySearch(100))

        for i in 0 ... 10 {
            XCTAssertEqual(i, tens.binarySearch(10 * i), "where i = \(i)")
            XCTAssertEqual(i, tens.binarySearch(10 * i - 1), "where i = \(i)")
            XCTAssertEqual(i, tens.binarySearch(10 * i - 9), "where i = \(i)")
        }

        XCTAssertEqual(0, dupes.binarySearch(0))
        XCTAssertEqual(dupes.count, dupes.binarySearch(10 * dupes.count + 1))
        for i in 1 ... 5 {
            let a = i * (i - 1) / 2
            let b = a + i
            AssertContains(a ..< b, dupes.binarySearch(10 * i), "where i = \(i)")
            XCTAssertEqual(a, dupes.binarySearch(10 * i - 1), "where i = \(i)")
            XCTAssertEqual(a, dupes.binarySearch(10 * i - 9), "where i = \(i)")
        }
    }

    func testLowerBound() {
        XCTAssertEqual(0, empty.lowerBound(0))
        XCTAssertEqual(0, empty.lowerBound(33))
        XCTAssertEqual(0, empty.lowerBound(100))

        for i in 0 ... 10 {
            XCTAssertEqual(i, tens.lowerBound(10 * i), "where i = \(i)")
            XCTAssertEqual(i, tens.lowerBound(10 * i - 1), "where i = \(i)")
            XCTAssertEqual(i, tens.lowerBound(10 * i - 9), "where i = \(i)")
        }

        XCTAssertEqual(0, dupes.lowerBound(0))
        XCTAssertEqual(dupes.count, dupes.lowerBound(10 * dupes.count + 1))
        for i in 1 ... 5 {
            let a = i * (i - 1) / 2
            XCTAssertEqual(a, dupes.lowerBound(10 * i), "where i = \(i)")
            XCTAssertEqual(a, dupes.lowerBound(10 * i - 1), "where i = \(i)")
            XCTAssertEqual(a, dupes.lowerBound(10 * i - 9), "where i = \(i)")
        }
    }

    func testUpperBound() {
        XCTAssertEqual(0, empty.upperBound(0))
        XCTAssertEqual(0, empty.upperBound(33))
        XCTAssertEqual(0, empty.upperBound(100))

        for i in 0 ... 10 {
            XCTAssertEqual(min(i+1, 10), tens.upperBound(10 * i), "where i = \(i)")
            XCTAssertEqual(i, tens.upperBound(10 * i - 1), "where i = \(i)")
            XCTAssertEqual(i, tens.upperBound(10 * i - 9), "where i = \(i)")
        }

        XCTAssertEqual(0, dupes.upperBound(0))
        XCTAssertEqual(dupes.count, dupes.upperBound(10 * dupes.count + 1))
        for i in 1 ... 5 {
            let a = i * (i - 1) / 2
            let b = a + i
            XCTAssertEqual(b, dupes.upperBound(10 * i), "where i = \(i)")
            XCTAssertEqual(a, dupes.upperBound(10 * i - 1), "where i = \(i)")
            XCTAssertEqual(a, dupes.upperBound(10 * i - 9), "where i = \(i)")
        }
    }

    func testEqualRange() {
        func check(array: [Int], _ element: Int, _ message: String = "", file: StaticString = __FILE__, line: UInt = __LINE__) {
            let result = array.equalRange(element)
            XCTAssertEqual(result.startIndex, array.lowerBound(element), message, file: file, line: line)
            XCTAssertEqual(result.endIndex, array.upperBound(element), message, file: file, line: line)
        }
        check(empty, 0)
        check(empty, 33)
        check(empty, 100)

        for i in 0 ... 10 {
            check(tens, 10 * i, "where i = \(i)")
            check(tens, 10 * i - 1, "where i = \(i)")
            check(tens, 10 * i - 9, "where i = \(i)")
        }

        check(dupes, 0)
        check(dupes, 10 * dupes.count + 1)
        for i in 1 ... 5 {
            check(dupes, 10 * i, "where i = \(i)")
            check(dupes, 10 * i - 1, "where i = \(i)")
            check(dupes, 10 * i - 9, "where i = \(i)")
        }
    }
    
}
