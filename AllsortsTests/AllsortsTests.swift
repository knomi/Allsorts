//
//  AllsortsTests.swift
//  AllsortsTests
//
//  Created by Pyry Jahkola on 13.02.2015.
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

// -----------------------------------------------------------------------------
// MARK: - Assertion helpers

func AssertContains<T : Comparable>(interval: @autoclosure () -> HalfOpenInterval<T>,
                                    expression: @autoclosure () -> T,
                                    _ message: String = "",
                                    file: String = __FILE__,
                                    line: UInt = __LINE__)
{
    let ivl = interval()
    let expr = expression()
    let msg = message.isEmpty ? "\(ivl) does not contain \(expr)"
                              : "\(ivl) does not contain \(expr) -- \(message)"
    XCTAssert(ivl.contains(expr), msg, file: file, line: line)
}

func AssertContains<T : Comparable>(interval: @autoclosure () -> ClosedInterval<T>,
                                    expression: @autoclosure () -> T,
                                    _ message: String = "",
                                    file: String = __FILE__,
                                    line: UInt = __LINE__)
{
    let ivl = interval()
    let expr = expression()
    let msg = message.isEmpty ? "\(ivl) does not contain \(expr)"
                              : "\(ivl) does not contain \(expr) -- \(message)"
    XCTAssert(ivl.contains(expr), msg, file: file, line: line)
}

// -----------------------------------------------------------------------------
// MARK: - Test types

/// This struct is used for testing how `Orderable` can be used with ordinary
/// user-defined data structures.
private struct Record<K : Orderable, V> : Orderable {
    var key: K
    var value: V
    init(_ k: K, _ v: V) { key = k; value = v }
}

private func <=> <K, V>(a: Record<K, V>, b: Record<K, V>) -> Ordering {
    return a.key <=> b.key
}

/// This struct is used for checking that `QuicklyDifferent` doesn't perform
/// comparisons overly eagerly. If `.Bad` is compared with something, a test
/// assertion failure is recorded.
private enum HardlyComparable : Orderable {
    case One
    case Two
    case Bad
}

private func <=> (a: HardlyComparable, b: HardlyComparable) -> Ordering {
    switch (a, b) {
    case (.One, .One):                         return .EQ
    case (.One, .Two):                         return .LT
    case (.One, .Bad): XCTFail("one <=> bad"); return .LT
    case (.Two, .One):                         return .GT
    case (.Two, .Two):                         return .EQ
    case (.Two, .Bad): XCTFail("two <=> bad"); return .LT
    case (.Bad, .One): XCTFail("bad <=> one"); return .LT
    case (.Bad, .Two): XCTFail("bad <=> two"); return .GT
    case (.Bad, .Bad): XCTFail("bad <=> bad"); return .LT
    }
}

/// This struct tests the use case of adding a custom `==` operator for but
/// relying on `<=>` for the less-than comparisons. In other words, using this
/// struct to test that `Orderable` and `Comparable` play decently alongside
/// each other.
private struct QuicklyDifferent : Orderable {
    let elements: [HardlyComparable]
    init(_ elements: [HardlyComparable]) { self.elements = elements }
}

private func == (a: QuicklyDifferent, b: QuicklyDifferent) -> Bool {
    return !(a.elements.count != b.elements.count)
        && a.elements <=> b.elements == .EQ
}

private func <=> (a: QuicklyDifferent, b: QuicklyDifferent) -> Ordering {
    return a.elements <=> b.elements
}

// -----------------------------------------------------------------------------
// MARK: - Test data

private let empty = [Int]()
private let tens  = [ 0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
private let dupes = [10, 20, 20, 30, 30, 30, 40, 40, 40, 40, 50, 50, 50, 50, 50]

// -----------------------------------------------------------------------------
// MARK: - Tests

class AllsortsTests: XCTestCase {

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
    
    func testOrdering() {
        XCTAssertEqual(Ordering(rawValue: Int.min), Ordering.LT)
        XCTAssertEqual(Ordering(rawValue: -2),      Ordering.LT)
        XCTAssertEqual(Ordering(rawValue: -1),      Ordering.LT)
        XCTAssertEqual(Ordering(rawValue: 0),       Ordering.EQ)
        XCTAssertEqual(Ordering(rawValue: 1),       Ordering.GT)
        XCTAssertEqual(Ordering(rawValue: 3),       Ordering.GT)
        XCTAssertEqual(Ordering(rawValue: Int.max), Ordering.GT)
        
        XCTAssertEqual(Ordering.compare(Int.min, Int.max), Ordering.LT)
        XCTAssertEqual(Ordering.compare(Int.min, 1), Ordering.LT)
        XCTAssertEqual(Ordering.compare(Int.min, 0), Ordering.LT)
        XCTAssertEqual(Ordering.compare(Int.min, -1), Ordering.LT)
        XCTAssertEqual(Ordering.compare(Int.min, Int.min), Ordering.EQ)

        XCTAssertEqual(Ordering.compare(-1, Int.max), Ordering.LT)
        XCTAssertEqual(Ordering.compare(-1, 1), Ordering.LT)
        XCTAssertEqual(Ordering.compare(-1, 0), Ordering.LT)
        XCTAssertEqual(Ordering.compare(-1, -1), Ordering.EQ)
        XCTAssertEqual(Ordering.compare(-1, Int.min), Ordering.GT)

        XCTAssertEqual(Ordering.compare(0, Int.max), Ordering.LT)
        XCTAssertEqual(Ordering.compare(0, 1), Ordering.LT)
        XCTAssertEqual(Ordering.compare(0, 0), Ordering.EQ)
        XCTAssertEqual(Ordering.compare(0, -1), Ordering.GT)
        XCTAssertEqual(Ordering.compare(0, Int.min), Ordering.GT)

        XCTAssertEqual(Ordering.compare(1, Int.max), Ordering.LT)
        XCTAssertEqual(Ordering.compare(1, 1), Ordering.EQ)
        XCTAssertEqual(Ordering.compare(1, 0), Ordering.GT)
        XCTAssertEqual(Ordering.compare(1, -1), Ordering.GT)
        XCTAssertEqual(Ordering.compare(1, Int.min), Ordering.GT)

        XCTAssertEqual(Ordering.compare(Int.max, Int.max), Ordering.EQ)
        XCTAssertEqual(Ordering.compare(Int.max, 1), Ordering.GT)
        XCTAssertEqual(Ordering.compare(Int.max, 0), Ordering.GT)
        XCTAssertEqual(Ordering.compare(Int.max, -1), Ordering.GT)
        XCTAssertEqual(Ordering.compare(Int.max, Int.min), Ordering.GT)
        
        XCTAssertEqual(Ordering.compare("ba",   "bar"), Ordering.LT)
        XCTAssertEqual(Ordering.compare("bar",  "bar"), Ordering.EQ)
        XCTAssertEqual(Ordering.compare("barr", "bar"), Ordering.GT)
        XCTAssertEqual(Ordering.compare("foo",  "bar"), Ordering.GT)
    }
    
    func testOrderable() {
        XCTAssertEqual(Record(1, "foo") <=> Record(2, "bar"), Ordering.LT)
        XCTAssertEqual(Record(2, "foo") <=> Record(2, "bar"), Ordering.EQ)
        XCTAssertEqual(Record(3, "foo") <=> Record(2, "bar"), Ordering.GT)
        
        XCTAssertEqual(QuicklyDifferent([]),
                       QuicklyDifferent([]))
        XCTAssertEqual(QuicklyDifferent([.One]),
                       QuicklyDifferent([.One]))
        XCTAssertEqual(QuicklyDifferent([.One, .Two]),
                       QuicklyDifferent([.One, .Two]))
        
        XCTAssertLessThan(QuicklyDifferent([]),
                          QuicklyDifferent([.One]))
        XCTAssertLessThan(QuicklyDifferent([.Two, .One]),
                          QuicklyDifferent([.Two, .Two]))
        XCTAssertLessThan(QuicklyDifferent([.Two, .One, .Bad]),
                          QuicklyDifferent([.Two, .Two]))
        XCTAssertLessThan(QuicklyDifferent([.Two, .One, .Bad]),
                          QuicklyDifferent([.Two, .Two, .Bad]))

        XCTAssertEqual(QuicklyDifferent([.One]),
                       QuicklyDifferent([.One]))
        XCTAssertFalse(QuicklyDifferent([.Bad])
                    == QuicklyDifferent([.One, .Two]))
        XCTAssert(QuicklyDifferent([.Bad])
               != QuicklyDifferent([.Two, .Two]))
        XCTAssertNotEqual(QuicklyDifferent([.Two]),
                          QuicklyDifferent([.Bad, .Two]))
    }
    
    func testOrderableIsComparable() {
        XCTAssert(Record(1, "foo") <  Record(2, "bar"))
        XCTAssert(Record(1, "foo") <= Record(2, "bar"))
        XCTAssert(Record(1, "foo") != Record(2, "bar"))
        
        XCTAssert(Record(2, "foo") <= Record(2, "bar"))
        XCTAssert(Record(2, "foo") == Record(2, "bar"))
        XCTAssert(Record(2, "foo") >= Record(2, "bar"))
        
        XCTAssert(Record(3, "foo") != Record(2, "bar"))
        XCTAssert(Record(3, "foo") >= Record(2, "bar"))
        XCTAssert(Record(3, "foo") >  Record(2, "bar"))
    }
    
    func testOrderableSwift() {
        XCTAssertEqual("ba"  <=> "bar", Ordering.LT)
        XCTAssertEqual("bar" <=> "bar", Ordering.EQ)
        XCTAssertEqual("foo" <=> "bar", Ordering.GT)
        
        XCTAssertEqual(-Double.infinity <=>  Double.infinity, Ordering.LT)
        XCTAssertEqual(-Double.infinity <=> -Double.infinity, Ordering.EQ)
        XCTAssertEqual( Double.infinity <=> -Double.infinity, Ordering.GT)
        XCTAssertEqual(1.2 <=> 1, Ordering.GT)
    }
    
}
