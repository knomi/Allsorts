//
//  TestHelpers.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest

// -----------------------------------------------------------------------------
// MARK: - Assertions

func AssertContains<T : Comparable>(interval: @autoclosure () -> HalfOpenInterval<T>,
                                    expression: @autoclosure () -> T,
                                    _ message: String = "",
                                    file: String = __FILE__,
                                    line: UInt = __LINE__)
{
    let ivl = interval()
    let expr = expression()
    let msg = message.isEmpty ? "\(ivl) does not contain \(expr)"
                              : "\(ivl) does not contain \(expr) -- \(message)"
    XCTAssert(ivl.contains(expr), msg, file: file, line: line)
}

func AssertContains<T : Comparable>(interval: @autoclosure () -> ClosedInterval<T>,
                                    expression: @autoclosure () -> T,
                                    _ message: String = "",
                                    file: String = __FILE__,
                                    line: UInt = __LINE__)
{
    let ivl = interval()
    let expr = expression()
    let msg = message.isEmpty ? "\(ivl) does not contain \(expr)"
                              : "\(ivl) does not contain \(expr) -- \(message)"
    XCTAssert(ivl.contains(expr), msg, file: file, line: line)
}

