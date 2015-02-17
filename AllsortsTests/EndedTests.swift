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
        XCTAssert(isComparableType(Ended<String>))
        XCTAssert(isComparableType(Ended<Int>))
        XCTAssert(isComparableType(Ended<NSData>))

        XCTAssert(isOrderableType(Ended<Int>))
        XCTAssert(isOrderableType(Ended<String>))
        XCTAssert(isOrderableType(Ended<NSData>))
    
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
