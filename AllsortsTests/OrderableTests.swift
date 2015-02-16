//
//  OrderableTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

// -----------------------------------------------------------------------------
// MARK: - OrderableTests

class OrderableTests : XCTestCase {

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
    
    func testOrderableFoundation() {
        XCTAssertFalse(isOrderableType(NSObject))
        XCTAssertFalse(isOrderableType(NSArray))
        XCTAssertFalse(isOrderableType(NSDictionary))
        XCTAssert(isOrderableType(NSData))
        XCTAssert(isOrderableType(NSDate))
        XCTAssert(isOrderableType(NSIndexPath))
        XCTAssert(isOrderableType(NSDecimalNumber))
        XCTAssert(isOrderableType(NSNumber))
        XCTAssert(isOrderableType(NSString))
        XCTAssert(isOrderableType(NSUUID))
    
        XCTAssertEqual(NSData() <=> NSData(), Ordering.EQ)
        XCTAssertEqual(NSData()
                   <=> "".dataUsingEncoding(NSUTF8StringEncoding), Ordering.EQ)
        XCTAssertEqual(NSData()
                   <=> "!".dataUsingEncoding(NSUTF8StringEncoding), Ordering.LT)
        XCTAssertEqual("!".dataUsingEncoding(NSUTF8StringEncoding)
                   <=> "!".dataUsingEncoding(NSUTF8StringEncoding), Ordering.EQ)
        XCTAssertEqual("!!".dataUsingEncoding(NSUTF8StringEncoding)
                   <=> "!".dataUsingEncoding(NSUTF8StringEncoding), Ordering.GT)

        // FIXME: Avoiding `as!` while still supporting Swift 1.1
        let distantPast = (NSDate.distantPast() as? NSDate)!
        let distantFuture = (NSDate.distantFuture() as? NSDate)!
        
        XCTAssertEqual(distantPast <=> NSDate(), Ordering.LT)
        XCTAssertEqual(distantFuture <=> NSDate(), Ordering.GT)
        XCTAssertEqual(distantPast <=> distantPast, Ordering.EQ)
        XCTAssertEqual(distantPast <=> distantFuture, Ordering.LT)
        XCTAssertEqual(distantFuture <=> distantFuture, Ordering.EQ)
        XCTAssertEqual(NSDate()
                   <=> NSDate(timeIntervalSince1970: 0), Ordering.GT)
        
        XCTAssertEqual(indexPath() <=> indexPath(), Ordering.EQ)
        XCTAssertEqual(indexPath(1) <=> indexPath(), Ordering.GT)
        XCTAssertEqual(indexPath(1, 0, 2)
                   <=> indexPath(1, 1), Ordering.LT)
        XCTAssertEqual(indexPath(1, 0, 2)
                   <=> indexPath(1, 0, 0, 1), Ordering.GT)
        XCTAssertEqual(indexPath(1, 2, 3, 0, 123)
                   <=> indexPath(1, 2, 3, 0, 123), Ordering.EQ)
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

// -----------------------------------------------------------------------------
// MARK: -
// MARK: An orderable record type

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

// MARK: Limited comparisons

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

// MARK: Short-circuited equality

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

// MARK: Foundation object construction

/// Construct an `NSIndexPath` with the given indexes.
private func indexPath(indexes: Int...) -> NSIndexPath {
    var path = indexes
    return NSIndexPath(indexes: &path, length: path.count)
}

// MARK: Conformance checkers
private func isComparableType<T : Comparable>(T.Type) -> Bool { return true }
private func isComparableType<T : Any>(T.Type) -> Bool { return false }
private func isOrderableType<T : Orderable>(T.Type) -> Bool { return true }
private func isOrderableType<T : Any>(T.Type) -> Bool { return false }

