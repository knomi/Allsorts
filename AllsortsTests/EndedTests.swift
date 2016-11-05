//
//  EndedTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

class EndedTests : XCTestCase {

    func testEnded() {
        XCTAssert(isComparableType(Ended<String>.self))
        XCTAssert(isComparableType(Ended<Int>.self))
        XCTAssert(isComparableType(Ended<Data>.self))

        XCTAssert(isOrderableType(Ended<Int>.self))
        XCTAssert(isOrderableType(Ended<String>.self))
        XCTAssert(isOrderableType(Ended<Data>.self))
    
        let empty = Ended("")
        let bar = Ended("bar")
        let baz = Ended("baz")
        let end = Ended<String>()
        
        XCTAssertEqual(empty, empty)
        XCTAssertEqual(end, end)
        
        XCTAssertNotEqual(empty, end)

        XCTAssertLessThan(empty, bar)
        XCTAssertLessThan(bar, baz)
        XCTAssertLessThan(baz, end)
        XCTAssertLessThan(empty, end)
    }

}
