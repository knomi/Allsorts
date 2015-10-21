//
//  TestHelpers.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import XCTest
import Allsorts

// -----------------------------------------------------------------------------
// MARK: - Assertions


func AssertContains<T : Comparable>(@autoclosure interval: () -> HalfOpenInterval<T>,
                                    @autoclosure _ expression: () -> T,
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

func AssertContains<T : Comparable>(@autoclosure interval: () -> ClosedInterval<T>,
                                    @autoclosure _ expression: () -> T,
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

// -----------------------------------------------------------------------------
// MARK: - Conformance checkers
func isComparableType<T : Comparable>(_: T.Type) -> Bool { return true }
func isComparableType<T : Any>(_: T.Type) -> Bool { return false }

func isOrderableType<T : Orderable>(_: T.Type) -> Bool { return true }
func isOrderableType<T : Any>(_: T.Type) -> Bool { return false }

