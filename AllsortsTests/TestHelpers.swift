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
                                    file: StaticString = #file,
                                    line: UInt = #line)
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

func bitwiseCeil<T : UnsignedIntegerType>(x: T) -> T {
    var i = ~T(0)
    while ~i < x {
        i = T.multiplyWithOverflow(i, 2).0
    }
    return ~i
}

func randomMax<T : UnsignedIntegerType>(max: T) -> T {
    let m = bitwiseCeil(max)
    var buf = T(0)
    repeat {
        arc4random_buf(&buf, sizeof(UInt.self))
        buf = buf & m
    } while buf > max
    return buf
}

func random<T : UnsignedIntegerType>(interval: ClosedInterval<T>) -> T {
    let a = interval.start
    let b = interval.end
    return a + randomMax(b - a)
}

func random(interval: ClosedInterval<Int>) -> Int {
    let a = UInt(bitPattern: interval.start)
    let b = UInt(bitPattern: interval.end)
    let n = b - a
    return Int(bitPattern: UInt.addWithOverflow(a, randomMax(n)).0)
}

func randomArray(count count: Int,
                         value: ClosedInterval<Int>) -> [Int]
{
    var ints = [Int]()
    for _ in 0 ..< count {
        ints.append(random(value))
    }
    return ints
}
