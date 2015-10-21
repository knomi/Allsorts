//
//  Swift+BoundedType.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation

// MARK: Numbers

extension Float : BoundedType {
    public static var min: Float { return -infinity }
    public static var max: Float { return infinity }
}

extension Double : BoundedType {
    public static var min: Double { return -infinity }
    public static var max: Double { return infinity }
}

extension Int    : BoundedType {}

extension Int8   : BoundedType {}

extension Int16  : BoundedType {}

extension Int32  : BoundedType {}

extension Int64  : BoundedType {}

extension UInt   : BoundedType {}

extension UInt8  : BoundedType {}

extension UInt16 : BoundedType {}

extension UInt32 : BoundedType {}

extension UInt64 : BoundedType {}
