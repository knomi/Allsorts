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
        XCTAssertEqual(QuicklyDifferent([.one]),
                       QuicklyDifferent([.one]))
        XCTAssertEqual(QuicklyDifferent([.one, .two]),
                       QuicklyDifferent([.one, .two]))
        
        XCTAssertLessThan(QuicklyDifferent([]),
                          QuicklyDifferent([.one]))
        XCTAssertLessThan(QuicklyDifferent([.two, .one]),
                          QuicklyDifferent([.two, .two]))
        XCTAssertLessThan(QuicklyDifferent([.two, .one, .bad]),
                          QuicklyDifferent([.two, .two]))
        XCTAssertLessThan(QuicklyDifferent([.two, .one, .bad]),
                          QuicklyDifferent([.two, .two, .bad]))

        XCTAssertEqual(QuicklyDifferent([.one]),
                       QuicklyDifferent([.one]))
        XCTAssertFalse(QuicklyDifferent([.bad])
                    == QuicklyDifferent([.one, .two]))
        XCTAssert(QuicklyDifferent([.bad])
               != QuicklyDifferent([.two, .two]))
        XCTAssertNotEqual(QuicklyDifferent([.two]),
                          QuicklyDifferent([.bad, .two]))
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
        XCTAssertFalse(isOrderableType(NSObject.self))
        XCTAssertFalse(isOrderableType(NSArray.self))
        XCTAssertFalse(isOrderableType(NSDictionary.self))
        XCTAssert(isOrderableType(Data.self))
        XCTAssert(isOrderableType(Date.self))
        XCTAssert(isOrderableType(IndexPath.self))
        XCTAssert(isOrderableType(NSDecimalNumber.self))
        XCTAssert(isOrderableType(NSNumber.self))
        //XCTAssert(isOrderableType(NSString.self))
        XCTAssert(isOrderableType(UUID.self))
    
        XCTAssertEqual(Data() <=> Data(), Ordering.equal)
        XCTAssertEqual(Data()
                   <=> "".data(using: .utf8)!, Ordering.equal)
        XCTAssertEqual(Data()
                   <=> "!".data(using: .utf8)!, Ordering.less)
        XCTAssertEqual("!".data(using: .utf8)!
                   <=> "!".data(using: .utf8)!, Ordering.equal)
        XCTAssertEqual("!!".data(using: .utf8)!
                   <=> "!".data(using: .utf8)!, Ordering.greater)

        let distantPast = Date.distantPast
        let distantFuture = Date.distantFuture
        
        XCTAssertEqual(distantPast <=> Date(), Ordering.less)
        XCTAssertEqual(distantFuture <=> Date(), Ordering.greater)
        XCTAssertEqual(distantPast <=> distantPast, Ordering.equal)
        XCTAssertEqual(distantPast <=> distantFuture, Ordering.less)
        XCTAssertEqual(distantFuture <=> distantFuture, Ordering.equal)
        XCTAssertEqual(Date()
                   <=> Date(timeIntervalSince1970: 0), Ordering.greater)
        
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
/// comparisons overly eagerly. If `.bad` is compared with something, a test
/// assertion failure is recorded.
private enum HardlyComparable : Orderable, Comparable {
    case one
    case two
    case bad
}

private func <=> (a: HardlyComparable, b: HardlyComparable) -> Ordering {
    switch (a, b) {
    case (.one, .one):                         return .equal
    case (.one, .two):                         return .less
    case (.one, .bad): XCTFail("one <=> bad"); return .less
    case (.two, .one):                         return .greater
    case (.two, .two):                         return .equal
    case (.two, .bad): XCTFail("two <=> bad"); return .less
    case (.bad, .one): XCTFail("bad <=> one"); return .less
    case (.bad, .two): XCTFail("bad <=> two"); return .greater
    case (.bad, .bad): XCTFail("bad <=> bad"); return .less
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
        && (a.elements <=> b.elements) == .equal
}

private func <=> (a: QuicklyDifferent, b: QuicklyDifferent) -> Ordering {
    return a.elements <=> b.elements
}

// MARK: Foundation object construction

/// Construct an `IndexPath` with the given indexes.
private func indexPath(_ indexes: Int...) -> IndexPath {
    return IndexPath(indexes: indexes)
}
