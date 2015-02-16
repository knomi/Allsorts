//
//  OrderingTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

class OrderingTests: XCTestCase {

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
    
    func testOrderingTo() {
        XCTAssertEqual(Ordering.to("foo")("bar"), Ordering.LT)
        XCTAssertEqual(Ordering.to("foo")("foo"), Ordering.EQ)
        XCTAssertEqual(Ordering.to("foo")("fooo"), Ordering.GT)
    }

    func testOrderingWithin() {
        XCTAssertEqual(Ordering.within("baz" ... "foo")("bar"), Ordering.LT)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("baz"), Ordering.EQ)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("cow"), Ordering.EQ)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("foo"), Ordering.EQ)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("foo!"), Ordering.GT)

        XCTAssertEqual(Ordering.within("baz" ..< "foo")("bar"), Ordering.LT)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("baz"), Ordering.EQ)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("cow"), Ordering.EQ)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("foo"), Ordering.GT)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("foo!"), Ordering.GT)
    }

}
