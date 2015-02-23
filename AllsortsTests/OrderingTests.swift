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
        XCTAssertEqual(Ordering.create(Int.min), Ordering.LT)
        XCTAssertEqual(Ordering.create(-2),      Ordering.LT)
        XCTAssertEqual(Ordering.create(-1),      Ordering.LT)
        XCTAssertEqual(Ordering.create(0),       Ordering.EQ)
        XCTAssertEqual(Ordering.create(1),       Ordering.GT)
        XCTAssertEqual(Ordering.create(3),       Ordering.GT)
        XCTAssertEqual(Ordering.create(Int.max), Ordering.GT)
        
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
        
        XCTAssertEqual(0.5 <=> 1...2, Ordering.LT)
        XCTAssertEqual(1.5 <=> 1...2, Ordering.EQ)
        XCTAssertEqual(1.5 <=> 1...2, Ordering.EQ)
        XCTAssertEqual(2.0 <=> 1...2, Ordering.EQ)
        XCTAssertEqual(2.1 <=> 1...2, Ordering.GT)
        
        XCTAssertEqual(1...2 <=> 0.5, Ordering.GT)
        XCTAssertEqual(1...2 <=> 1.5, Ordering.EQ)
        XCTAssertEqual(1...2 <=> 1.5, Ordering.EQ)
        XCTAssertEqual(1...2 <=> 2.0, Ordering.EQ)
        XCTAssertEqual(1...2 <=> 2.1, Ordering.LT)

        XCTAssertEqual(0.5 <=> 1..<2, Ordering.LT)
        XCTAssertEqual(1.5 <=> 1..<2, Ordering.EQ)
        XCTAssertEqual(1.5 <=> 1..<2, Ordering.EQ)
        XCTAssertEqual(2.0 <=> 1..<2, Ordering.GT)
        XCTAssertEqual(2.1 <=> 1..<2, Ordering.GT)
        
        XCTAssertEqual(1..<2 <=> 0.5, Ordering.GT)
        XCTAssertEqual(1..<2 <=> 1.5, Ordering.EQ)
        XCTAssertEqual(1..<2 <=> 1.5, Ordering.EQ)
        XCTAssertEqual(1..<2 <=> 2.0, Ordering.LT)
        XCTAssertEqual(1..<2 <=> 2.1, Ordering.LT)
    }

}
