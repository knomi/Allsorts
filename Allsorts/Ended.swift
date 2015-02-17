//
//  Ended.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Orderable value `T` augmented with an upper bound `.End`.
public enum Ended<T : Orderable> : Orderable {
    case Another(T)
    case End
    
    public init() {
        self = .End
    }
    
    public init(_ value: T?) {
        self = value.map {x in .Another(x)} ?? .End
    }
    
    public var another: T? {
        switch self {
        case let .Another(x): return .Some(x)
        case     .End:        return .None
        }
    }
    
    public var isEnd: Bool {
        switch self {
        case .Another: return false
        case .End:     return true
        }
    }
}

/// Ordering based on `a <=> b == .Another(a) <=> .Another(b)` and
/// `.Another(_) < .End`.
public func <=> <T>(a: Ended<T>, b: Ended<T>) -> Ordering {
    switch (a, b) {
    case     (.Another,    .End       ): return .LT
    case     (.End,        .End       ): return .EQ
    case     (.End,        .Another   ): return .GT
    case let (.Another(a), .Another(b)): return a <=> b
    }
}
