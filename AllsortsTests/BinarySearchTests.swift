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

    func testExample() {

        // indices:          0,   1,  2,   3,  4,  5,   6,  7,  8,  9
        let xs: [Double] = [10,  20, 20,  30, 30, 30,  40, 40, 40, 40]

        do {
            // Find an arbitrary sort-preserving insertion index
            let i28: Int = xs.binarySearch {x in x <=> 28} //=> 3
            let i29: Int = xs.binarySearch(29) //=> 3
            let i30: Int = xs.binarySearch(30) //=> 3, 4, or 5
            let i31: Int = xs.binarySearch(31) //=> 6
            XCTAssertEqual(i28, 3)
            XCTAssertEqual(i29, 3)
            AssertContains(3...5, i30)
            XCTAssertEqual(i31, 6)
        }

        do {
            // Find index of an equal element, or `nil` if not found
            let j28: Int? = xs.binaryFind {x in x <=> 28} //=> nil
            let j29: Int? = xs.binaryFind(29) //=> nil
            let j30: Int? = xs.binaryFind(30) //=> 3, 4, or 5
            let j31: Int? = xs.binaryFind(31) //=> nil
            XCTAssertEqual(j28, nil)
            XCTAssertEqual(j29, nil)
            if let j30 = j30 {
                AssertContains(3...5, j30)
            } else {
                XCTAssertNotNil(j30)
            }
            XCTAssertEqual(j31, nil)
        }

        do {
            /// Find the lowest sort-preserving insertion index
            let l28: Int = xs.lowerBound {x in x <=> 28} //=> 3
            let l29: Int = xs.lowerBound(29) //=> 3
            let l30: Int = xs.lowerBound(30) //=> 3
            let l31: Int = xs.lowerBound(31) //=> 6
            XCTAssertEqual(l28, 3)
            XCTAssertEqual(l29, 3)
            XCTAssertEqual(l30, 3)
            XCTAssertEqual(l31, 6)
        }

        do {
            /// Find the lowest sort-preserving insertion index
            let u28: Int = xs.upperBound {x in x <=> 28} //=> 3
            let u29: Int = xs.upperBound(29) //=> 3
            let u30: Int = xs.upperBound(30) //=> 6
            let u31: Int = xs.upperBound(31) //=> 6
            XCTAssertEqual(u28, 3)
            XCTAssertEqual(u29, 3)
            XCTAssertEqual(u30, 6)
            XCTAssertEqual(u31, 6)
        }

        do {
            /// Find the range of equal elements
            let r28: Range<Int> = xs.equalRange {x in x <=> 28} //=> 3 ..< 3
            let r29: Range<Int> = xs.equalRange(29) //=> 3 ..< 3
            let r30: Range<Int> = xs.equalRange(30) //=> 3 ..< 6
            let r31: Range<Int> = xs.equalRange(31) //=> 6 ..< 6
            let r20 = xs.equalRange(Ordering.within(20 ... 30)) //=> 1 ..< 6
            XCTAssertEqual(r28, 3 ..< 3)
            XCTAssertEqual(r29, 3 ..< 3)
            XCTAssertEqual(r30, 3 ..< 6)
            XCTAssertEqual(r31, 6 ..< 6)
            XCTAssertEqual(r20, 1 ..< 6)
        }
        
        do {
            let surnames   = ["Greenwood", "Greenwood", "O'Brien", "Selway", "Yorke"]
            let givenNames = ["Colin",     "Jonny",     "Ed",      "Philip", "Thom"]
            let index = surnames.indices.binarySearch {i in
                surnames[i] <=> "Greenwood" || givenNames[i] <=> "Jonny"
            }
            XCTAssertEqual(index, 1)
        }
    }

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
