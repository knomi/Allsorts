//
//  BoundedTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts
import Foundation

class BoundedTests : XCTestCase {

    func testBounded() {
        XCTAssert(isComparableType(Bounded<String>.self))
        XCTAssert(isComparableType(Bounded<Int>.self))
        XCTAssert(isComparableType(Bounded<Data>.self))

        XCTAssert(isOrderableType(Bounded<Int>.self))
        XCTAssert(isOrderableType(Bounded<String>.self))
        XCTAssert(isOrderableType(Bounded<Data>.self))
    
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
        XCTAssertEqual(Bounded<String>.min.description, "infimum")
        XCTAssertEqual(Bounded("foo").description, "bounded(\"foo\")")
        XCTAssertEqual(Bounded<String>.max.description, "supremum")
        
        XCTAssertEqual((Bounded("bar") ... Bounded("foo")).description, "bounded(\"bar\")...bounded(\"foo\")")
    }

}
