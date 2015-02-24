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
    
    public static var min: Bounded { return .Min }
    public static var max: Bounded { return .Max }
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
