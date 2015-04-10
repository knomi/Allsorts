//
//  SortingTests.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

class SortingTests: XCTestCase {

    func testSort() {
        let byRevName = Ordering.reverse(byLast <|> byFirst)
        byRevName(("ZZ", "Top", 1969), ("Led", "Zeppelin", 1968))
        
        XCTAssertEqual(
            sorted(musicians) {$0.first < $1.first}.map {$0.first},
            ["Colin", "Ed", "Jonny", "Philip", "Thom"],
            "Swift.sorted(xs, isLessThan) should still work too")
        XCTAssertEqual(
            sorted(musicians, Ordering.by {$0.first}).map {$0.first},
            ["Colin", "Ed", "Jonny", "Philip", "Thom"])
        XCTAssertEqual(
            sorted(musicians, byLast <|> byFirst).map {$0.first},
            ["Colin", "Jonny", "Ed", "Philip", "Thom"])
        XCTAssertEqual(
            sorted(musicians, byLast
                          <|> Ordering.reverse(byYear)).map {$0.first},
            ["Jonny", "Colin", "Ed", "Philip", "Thom"])
        XCTAssertEqual(
            sorted(musicians, Ordering.by {count($0.last)}
                          <|> Ordering.reverse(byYear)).map {$0.first},
            ["Thom", "Philip", "Ed", "Jonny", "Colin"])
    }

    func testStableSort() {
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by {$0.year}).map {$0.first},
            ["Philip", "Thom", "Ed", "Colin", "Jonny"])
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by {$0.year}
                                <|> Ordering.by {$0.last}
                                <|> Ordering.by {$0.first}).map {$0.first},
            ["Philip", "Ed", "Thom", "Colin", "Jonny"])
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by({$0.last})).map {$0.first},
            ["Jonny", "Colin", "Ed", "Philip", "Thom"])
        XCTAssertEqual(
            stableSorted(musicians, Ordering.by {$0.last}
                                <|> Ordering.by {$0.first}).map {$0.first},
            ["Colin", "Jonny", "Ed", "Philip", "Thom"])
    }

}

// -----------------------------------------------------------------------------
// MARK: -
// MARK: A band member

private typealias Musician = (first: String, last: String, year: Int)
private let byFirst = Ordering.by {(m: Musician) in m.first}
private let byLast  = Ordering.by {(m: Musician) in m.last}
private let byYear  = Ordering.by {(m: Musician) in m.year}
private let musicians: [Musician] =
    [ ("Thom",   "Yorke",     1968)
    , ("Jonny",  "Greenwood", 1971)
    , ("Colin",  "Greenwood", 1969)
    , ("Ed",     "O'Brien",   1968)
    , ("Philip", "Selway",    1967)
    ]
