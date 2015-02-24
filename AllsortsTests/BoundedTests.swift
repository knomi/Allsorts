//
//  BoundedTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

class BoundedTests : XCTestCase {

    func testBounded() {
        XCTAssert(isComparableType(Bounded<String>))
        XCTAssert(isComparableType(Bounded<Int>))
        XCTAssert(isComparableType(Bounded<NSData>))

        XCTAssert(isOrderableType(Bounded<Int>))
        XCTAssert(isOrderableType(Bounded<String>))
        XCTAssert(isOrderableType(Bounded<NSData>))
    
        let start = Bounded<String>.min
        let empty = Bounded("")
        let bar = Bounded("bar")
        let baz = Bounded("baz")
        let foo = Bounded("foo")
        let end = Bounded<String>.max
        
        XCTAssertEqual(start, Bounded.min)
        XCTAssertEqual(bar, bar)
        XCTAssertEqual(end, Bounded.max)

        XCTAssertNotEqual(bar, Bounded.min)
        XCTAssertNotEqual(foo, Bounded.max)
        XCTAssertNotEqual(start, Bounded.max)

        XCTAssertLessThan(start, empty)
        XCTAssertLessThan(empty, bar)
        XCTAssertLessThan(bar, baz)
        XCTAssertLessThan(baz, foo)
        XCTAssertLessThan(foo, end)
    }
    
    func testPrintable() {
        XCTAssertEqual(Bounded<String>.min.description, "Min")
        XCTAssertEqual(Bounded("foo").description, "Med(foo)")
        XCTAssertEqual(Bounded<String>.max.description, "Max")
        
        XCTAssertEqual((Bounded("bar") ... Bounded("foo")).description, "Med(bar)...Med(foo)")
    }

}
