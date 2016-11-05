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
        XCTAssertEqual(Ordering(Int.min), Ordering.less)
        XCTAssertEqual(Ordering(-2),      Ordering.less)
        XCTAssertEqual(Ordering(-1),      Ordering.less)
        XCTAssertEqual(Ordering(0),       Ordering.equal)
        XCTAssertEqual(Ordering(1),       Ordering.greater)
        XCTAssertEqual(Ordering(3),       Ordering.greater)
        XCTAssertEqual(Ordering(Int.max), Ordering.greater)
        
        XCTAssertEqual(Ordering.compare(Int.min, Int.max), Ordering.less)
        XCTAssertEqual(Ordering.compare(Int.min, 1), Ordering.less)
        XCTAssertEqual(Ordering.compare(Int.min, 0), Ordering.less)
        XCTAssertEqual(Ordering.compare(Int.min, -1), Ordering.less)
        XCTAssertEqual(Ordering.compare(Int.min, Int.min), Ordering.equal)

        XCTAssertEqual(Ordering.compare(-1, Int.max), Ordering.less)
        XCTAssertEqual(Ordering.compare(-1, 1), Ordering.less)
        XCTAssertEqual(Ordering.compare(-1, 0), Ordering.less)
        XCTAssertEqual(Ordering.compare(-1, -1), Ordering.equal)
        XCTAssertEqual(Ordering.compare(-1, Int.min), Ordering.greater)

        XCTAssertEqual(Ordering.compare(0, Int.max), Ordering.less)
        XCTAssertEqual(Ordering.compare(0, 1), Ordering.less)
        XCTAssertEqual(Ordering.compare(0, 0), Ordering.equal)
        XCTAssertEqual(Ordering.compare(0, -1), Ordering.greater)
        XCTAssertEqual(Ordering.compare(0, Int.min), Ordering.greater)

        XCTAssertEqual(Ordering.compare(1, Int.max), Ordering.less)
        XCTAssertEqual(Ordering.compare(1, 1), Ordering.equal)
        XCTAssertEqual(Ordering.compare(1, 0), Ordering.greater)
        XCTAssertEqual(Ordering.compare(1, -1), Ordering.greater)
        XCTAssertEqual(Ordering.compare(1, Int.min), Ordering.greater)

        XCTAssertEqual(Ordering.compare(Int.max, Int.max), Ordering.equal)
        XCTAssertEqual(Ordering.compare(Int.max, 1), Ordering.greater)
        XCTAssertEqual(Ordering.compare(Int.max, 0), Ordering.greater)
        XCTAssertEqual(Ordering.compare(Int.max, -1), Ordering.greater)
        XCTAssertEqual(Ordering.compare(Int.max, Int.min), Ordering.greater)
        
        XCTAssertEqual(Ordering.compare("ba",   "bar"), Ordering.less)
        XCTAssertEqual(Ordering.compare("bar",  "bar"), Ordering.equal)
        XCTAssertEqual(Ordering.compare("barr", "bar"), Ordering.greater)
        XCTAssertEqual(Ordering.compare("foo",  "bar"), Ordering.greater)
    }
    
    func testOrderingTo() {
        XCTAssertEqual(Ordering.to("foo")("bar"), Ordering.less)
        XCTAssertEqual(Ordering.to("foo")("foo"), Ordering.equal)
        XCTAssertEqual(Ordering.to("foo")("fooo"), Ordering.greater)
    }

    func testOrderingWithin() {
        XCTAssertEqual(Ordering.within("baz" ... "foo")("bar"), Ordering.less)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("baz"), Ordering.equal)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("cow"), Ordering.equal)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("foo"), Ordering.equal)
        XCTAssertEqual(Ordering.within("baz" ... "foo")("foo!"), Ordering.greater)

        XCTAssertEqual(Ordering.within("baz" ..< "foo")("bar"), Ordering.less)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("baz"), Ordering.equal)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("cow"), Ordering.equal)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("foo"), Ordering.greater)
        XCTAssertEqual(Ordering.within("baz" ..< "foo")("foo!"), Ordering.greater)
        
        XCTAssertEqual(0.5 <=> 1...2, Ordering.less)
        XCTAssertEqual(1.5 <=> 1...2, Ordering.equal)
        XCTAssertEqual(1.5 <=> 1...2, Ordering.equal)
        XCTAssertEqual(2.0 <=> 1...2, Ordering.equal)
        XCTAssertEqual(2.1 <=> 1...2, Ordering.greater)
        
        XCTAssertEqual(1...2 <=> 0.5, Ordering.greater)
        XCTAssertEqual(1...2 <=> 1.5, Ordering.equal)
        XCTAssertEqual(1...2 <=> 1.5, Ordering.equal)
        XCTAssertEqual(1...2 <=> 2.0, Ordering.equal)
        XCTAssertEqual(1...2 <=> 2.1, Ordering.less)

        XCTAssertEqual(0.5 <=> 1..<2, Ordering.less)
        XCTAssertEqual(1.5 <=> 1..<2, Ordering.equal)
        XCTAssertEqual(1.5 <=> 1..<2, Ordering.equal)
        XCTAssertEqual(2.0 <=> 1..<2, Ordering.greater)
        XCTAssertEqual(2.1 <=> 1..<2, Ordering.greater)
        
        XCTAssertEqual(1..<2 <=> 0.5, Ordering.greater)
        XCTAssertEqual(1..<2 <=> 1.5, Ordering.equal)
        XCTAssertEqual(1..<2 <=> 1.5, Ordering.equal)
        XCTAssertEqual(1..<2 <=> 2.0, Ordering.less)
        XCTAssertEqual(1..<2 <=> 2.1, Ordering.less)
    }

}
