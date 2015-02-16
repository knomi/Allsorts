//
//  SortingTests.swift
//  Allsorts
//
//  Created by Pyry Jahkola on 16.02.2015.
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

class SortingTests: XCTestCase {

    func testSort() {
        XCTAssertEqual(
            sorted(musicians) {$0.first < $1.first}.map {$0.first},
            ["Colin", "Ed", "Jonny", "Philip", "Thom"],
            "Swift.sorted(xs, isLessThan) should still work too")
        XCTAssertEqual(
            sorted(musicians, Ordering.by {$0.first}).map {$0.first},
            ["Colin", "Ed", "Jonny", "Philip", "Thom"])
        XCTAssertEqual(
            sorted(musicians, Ordering.by {$0.last}
                           || Ordering.by {$0.year}).map {$0.first},
            ["Colin", "Jonny", "Ed", "Philip", "Thom"])
    }

    func testStableSort() {
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by {$0.year}).map {$0.first},
            ["Philip", "Thom", "Ed", "Colin", "Jonny"])
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by {$0.year}
                                 || Ordering.by {$0.last}
                                 || Ordering.by {$0.first}).map {$0.first},
            ["Philip", "Ed", "Thom", "Colin", "Jonny"])
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by({$0.last})).map {$0.first},
            ["Jonny", "Colin", "Ed", "Philip", "Thom"])
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by {$0.last}
                                 || Ordering.by {$0.first}).map {$0.first},
            ["Colin", "Jonny", "Ed", "Philip", "Thom"])
    }

}

// -----------------------------------------------------------------------------
// MARK: -
// MARK: A band member

private typealias Musician = ( first: String
                             , last: String
                             , year: Int
                             )

private let musicians: [Musician] =
    [ ("Thom",   "Yorke",     1968)
    , ("Jonny",  "Greenwood", 1971)
    , ("Colin",  "Greenwood", 1969)
    , ("Ed",     "O'Brien",   1968)
    , ("Philip", "Selway",    1967)
    ]
