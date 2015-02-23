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
}

public func <=> <T>(a: Bounded<T>, b: Bounded<T>) -> Ordering {
    switch a {
    case .Min: switch b { case .Min: return .EQ; default: return .LT }
    case .Max: switch b { case .Max: return .EQ; default: return .GT }
    case let .Med(a):
        switch b {
        case     .Max:    return .LT
        case let .Med(b): return a <=> b
        case     .Min:    return .GT
        }
    }
}
