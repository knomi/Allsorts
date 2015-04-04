//
//  Bounded.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

public protocol BoundedType {
    class var min: Self { get }
    class var max: Self { get }
}

public enum Bounded<T : Orderable> : Comparable, Orderable, BoundedType {
    case Min
    case Med(T)
    case Max
    
    public init(_ value: T) { self = .Med(value) }
    
    public static func pure(value: T) -> Bounded {
        return .Med(value)
    }
    
    public static var min: Bounded { return .Min }
    public static var max: Bounded { return .Max }
    
    public func analysis<R>(#ifMin: () -> R,
                             ifMed: T -> R,
                             ifMax: () -> R) -> R
    {
        switch self {
        case     .Min:    return ifMin()
        case let .Med(x): return ifMed(x)
        case     .Max:    return ifMax()
        }
    }
}

extension Bounded : Printable {
    public var description: String {
        switch self {
        case     .Min:    return "Min"
        case let .Med(x): return "Med(\(x))"
        case     .Max:    return "Max"
        }
    }
}

public func <=> <T>(a: Bounded<T>, b: Bounded<T>) -> Ordering {
    switch (a, b) {
    case     (.Min,    .Min   ): return .EQ
    case     (.Min,    _      ): return .LT
    
    case     (.Med,    .Max   ): return .LT
    case let (.Med(a), .Med(b)): return a <=> b
    case     (.Med,    .Min   ): return .GT
    
    case     (.Max,    .Max   ): return .EQ
    case     (.Max,    _      ): return .GT
    }
}
