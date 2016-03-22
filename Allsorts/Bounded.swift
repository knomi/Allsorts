//
//  Bounded.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

public protocol BoundedType {
    static var min: Self { get }
    static var max: Self { get }
}

public enum Bounded<T : Orderable> : Comparable, Orderable, BoundedType {
    case Min
    case Med(T)
    case Max
    
    public init(_ value: T) { self = .Med(value) }
    
    public static var min: Bounded { return .Min }
    public static var max: Bounded { return .Max }
    
    public func analysis<R>(@noescape ifMin ifMin: () -> R,
                            @noescape ifMed:       T  -> R,
                            @noescape ifMax:       () -> R) -> R
    {
        switch self {
        case     .Min:    return ifMin()
        case let .Med(x): return ifMed(x)
        case     .Max:    return ifMax()
        }
    }
}

extension Bounded : CustomStringConvertible {
    public var description: String {
        switch self {
        case     .Min:    return "Min"
        case let .Med(x): return "Med(\(x))"
        case     .Max:    return "Max"
        }
    }
}

extension Bounded : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case     .Min:    return "Bounded.Min"
        case let .Med(x): return "Bounded.Med(\(String(reflecting: x)))"
        case     .Max:    return "Bounded.Max"
        }
    }
}

@warn_unused_result
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
