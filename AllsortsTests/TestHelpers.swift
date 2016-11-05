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


func AssertContains<T : Comparable>(_ interval: @autoclosure () -> Range<T>,
                                    _ expression: @autoclosure () -> T,
                                    _ message: String = "",
                                    file: StaticString = #file,
                                    line: UInt = #line)
{
    let ivl = interval()
    let expr = expression()
    let msg = message.isEmpty ? "\(ivl) does not contain \(expr)"
                              : "\(ivl) does not contain \(expr) -- \(message)"
    XCTAssert(ivl.contains(expr), msg, file: file, line: line)
}

func AssertContains<T : Comparable>(_ interval: @autoclosure () -> ClosedRange<T>,
                                    _ expression: @autoclosure () -> T,
                                    _ message: String = "",
                                    file: StaticString = #file,
                                    line: UInt = #line)
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

// MARK: - Random numbers

func bitwiseCeil<T : UnsignedInteger>(_ x: T) -> T {
    var i = ~T(0)
    while ~i < x {
        i = T.multiplyWithOverflow(i, 2).0
    }
    return ~i
}

func randomMax<T : UnsignedInteger>(_ max: T) -> T {
    let m = bitwiseCeil(max)
    var buf = T(0)
    repeat {
        arc4random_buf(&buf, MemoryLayout<UInt>.size)
        buf = buf & m
    } while buf > max
    return buf
}

func random<T : UnsignedInteger>(_ interval: ClosedRange<T>) -> T {
    let a = interval.lowerBound
    let b = interval.upperBound
    return a + randomMax(b - a)
}

func random(_ interval: ClosedRange<Int>) -> Int {
    let a = UInt(bitPattern: interval.lowerBound)
    let b = UInt(bitPattern: interval.upperBound)
    let n = b - a
    return Int(bitPattern: UInt.addWithOverflow(a, randomMax(n)).0)
}

func randomArray(count: Int, value: ClosedRange<Int>) -> [Int] {
    var ints = [Int]()
    for _ in 0 ..< count {
        ints.append(random(value))
    }
    return ints
}
