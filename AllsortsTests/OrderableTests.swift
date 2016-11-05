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
        XCTAssertEqual(Record(1, "foo") <=> Record(2, "bar"), Ordering.less)
        XCTAssertEqual(Record(2, "foo") <=> Record(2, "bar"), Ordering.equal)
        XCTAssertEqual(Record(3, "foo") <=> Record(2, "bar"), Ordering.greater)
        
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
    
        XCTAssertEqual(NSData() <=> NSData(), Ordering.equal)
        XCTAssertEqual(NSData()
                   <=> "".dataUsingEncoding(NSUTF8StringEncoding)!, Ordering.equal)
        XCTAssertEqual(NSData()
                   <=> "!".dataUsingEncoding(NSUTF8StringEncoding)!, Ordering.less)
        XCTAssertEqual("!".dataUsingEncoding(NSUTF8StringEncoding)!
                   <=> "!".dataUsingEncoding(NSUTF8StringEncoding)!, Ordering.equal)
        XCTAssertEqual("!!".dataUsingEncoding(NSUTF8StringEncoding)!
                   <=> "!".dataUsingEncoding(NSUTF8StringEncoding)!, Ordering.greater)

        let distantPast = NSDate.distantPast()
        let distantFuture = NSDate.distantFuture()
        
        XCTAssertEqual(distantPast <=> NSDate(), Ordering.less)
        XCTAssertEqual(distantFuture <=> NSDate(), Ordering.greater)
        XCTAssertEqual(distantPast <=> distantPast, Ordering.equal)
        XCTAssertEqual(distantPast <=> distantFuture, Ordering.less)
        XCTAssertEqual(distantFuture <=> distantFuture, Ordering.equal)
        XCTAssertEqual(NSDate()
                   <=> NSDate(timeIntervalSince1970: 0), Ordering.greater)
        
        XCTAssertEqual(indexPath() <=> indexPath(), Ordering.equal)
        XCTAssertEqual(indexPath(1) <=> indexPath(), Ordering.greater)
        XCTAssertEqual(indexPath(1, 0, 2)
                   <=> indexPath(1, 1), Ordering.less)
        XCTAssertEqual(indexPath(1, 0, 2)
                   <=> indexPath(1, 0, 0, 1), Ordering.greater)
        XCTAssertEqual(indexPath(1, 2, 3, 0, 123)
                   <=> indexPath(1, 2, 3, 0, 123), Ordering.equal)
    }

    func testOrderableSwift() {
        XCTAssertEqual("ba"  <=> "bar", Ordering.less)
        XCTAssertEqual("bar" <=> "bar", Ordering.equal)
        XCTAssertEqual("foo" <=> "bar", Ordering.greater)
        
        XCTAssertEqual(-Double.infinity <=>  Double.infinity, Ordering.less)
        XCTAssertEqual(-Double.infinity <=> -Double.infinity, Ordering.equal)
        XCTAssertEqual( Double.infinity <=> -Double.infinity, Ordering.greater)
        XCTAssertEqual(1.2 <=> 1, Ordering.greater)
    }
    
}

// -----------------------------------------------------------------------------
// MARK: -
// MARK: An orderable record type

/// This struct is used for testing how `Orderable` can be used with ordinary
/// user-defined data structures.
private struct Record<K : Orderable, V> : Orderable, Comparable {
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
private enum HardlyComparable : Orderable, Comparable {
    case One
    case Two
    case Bad
}

private func <=> (a: HardlyComparable, b: HardlyComparable) -> Ordering {
    switch (a, b) {
    case (.One, .One):                         return .equal
    case (.One, .Two):                         return .less
    case (.One, .Bad): XCTFail("one <=> bad"); return .less
    case (.Two, .One):                         return .greater
    case (.Two, .Two):                         return .equal
    case (.Two, .Bad): XCTFail("two <=> bad"); return .less
    case (.Bad, .One): XCTFail("bad <=> one"); return .less
    case (.Bad, .Two): XCTFail("bad <=> two"); return .greater
    case (.Bad, .Bad): XCTFail("bad <=> bad"); return .less
    }
}

// MARK: Short-circuited equality

/// This struct tests the use case of adding a custom `==` operator for but
/// relying on `<=>` for the less-than comparisons. In other words, using this
/// struct to test that `Orderable` and `Comparable` play decently alongside
/// each other.
private struct QuicklyDifferent : Orderable, Comparable {
    let elements: [HardlyComparable]
    init(_ elements: [HardlyComparable]) { self.elements = elements }
}

private func == (a: QuicklyDifferent, b: QuicklyDifferent) -> Bool {
    return !(a.elements.count != b.elements.count)
        && a.elements <=> b.elements == .equal
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
