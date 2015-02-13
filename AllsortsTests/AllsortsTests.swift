//
//  AllsortsTests.swift
//  AllsortsTests
//
//  Created by Pyry Jahkola on 13.02.2015.
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

private struct Record<K : Orderable, V> : Orderable {
    var key: K
    var value: V
    init(_ k: K, _ v: V) { key = k; value = v }
}

private func <=> <K, V>(a: Record<K, V>, b: Record<K, V>) -> Ordering {
    return a.key <=> b.key
}

class AllsortsTests: XCTestCase {
    
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
