//
//  AllsortsTests.swift
//  AllsortsTests
//
//  Created by Pyry Jahkola on 13.02.2015.
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

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
    
}
