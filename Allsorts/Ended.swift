//
//  Ended.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Orderable value `T` augmented with an upper bound `.end`. An `Ended<T>` is
/// structurally equivalent to `Optional<T>` but flips the ordering of the
/// `Optional.Some(T)` (~ `Ended.value(T)`) and the `Optional.None` (~
/// `Ended.end`) cases such that `.value(x)` compares less than `.end`.
public enum Ended<T : Orderable> : Orderable, Comparable {
    case value(T)
    case end
    
    public init() {
        self = .end
    }
    
    public init(_ value: T?) {
        self = value.map {x in .value(x)} ?? .end
    }
    
    public var value: T? {
        switch self {
        case let .value(x): return .some(x)
        case     .end:      return .none
        }
    }
    
    public func map<U>(_ f: (T) -> U) -> Ended<U> {
        switch self {
        case let .value(x): return .value(f(x))
        case     .end:      return .end
        }
    }
    
    public func flatMap<U>(_ f: (T) -> Ended<U>) -> Ended<U> {
        switch self {
        case let .value(x): return f(x)
        case     .end:      return .end
        }
    }
}

extension Ended : CustomStringConvertible {
    public var description: String {
        switch self {
        case let .value(x): return "value(\(String(reflecting: x)))"
        case     .end:      return "end"
        }
    }
}

extension Ended : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .value(x): return "Ended.value(\(String(reflecting: x)))"
        case     .end:      return "Ended.end"
        }
    }
}

/// Ordering based on `a <=> b == .value(a) <=> .value(b)` and
/// `.value(_) < .end`.
public func <=> <T>(a: Ended<T>, b: Ended<T>) -> Ordering {
    switch (a, b) {
    case let (.value(a), .value(b)): return a <=> b
    case     (.value,    .end     ): return .less
    case     (.end,      .end     ): return .equal
    case     (.end,      .value   ): return .greater
    }
}
