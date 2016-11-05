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
    case infimum
    case bounded(T)
    case supremum
    
    public init(_ value: T) { self = .bounded(value) }
    
    public static var min: Bounded { return .infimum }
    public static var max: Bounded { return .supremum }
    
    public func analysis<R>(infimum: ()  -> R,
                            bounded: (T) -> R,
                            supremum: ()  -> R) -> R
    {
        switch self {
        case     .infimum:    return infimum()
        case let .bounded(x): return bounded(x)
        case     .supremum:   return supremum()
        }
    }
}

extension Bounded : CustomStringConvertible {
    public var description: String {
        switch self {
        case     .infimum:    return "infimum"
        case let .bounded(x): return "bounded(\(String(reflecting: x)))"
        case     .supremum:   return "supremum"
        }
    }
}

extension Bounded : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case     .infimum:    return "Bounded.infimum"
        case let .bounded(x): return "Bounded.bounded(\(String(reflecting: x)))"
        case     .supremum:    return "Bounded.supremum"
        }
    }
}

public func <=> <T>(a: Bounded<T>, b: Bounded<T>) -> Ordering {
    switch (a, b) {
    case     (.infimum,    .infimum   ): return .equal
    case     (.infimum,    _          ): return .less
    
    case     (.bounded,    .supremum  ): return .less
    case let (.bounded(a), .bounded(b)): return a <=> b
    case     (.bounded,    .infimum   ): return .greater
    
    case     (.supremum,    .supremum ): return .equal
    case     (.supremum,    _         ): return .greater
    }
}
