//
//  Foundation+Ordering.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation

public extension Ordering {

    /// Convert an `ComparisonResult` into an `Ordering`.
    public init(_ comparisonResult: ComparisonResult) {
        self.init(comparisonResult.rawValue)
    }

    /// Convert an `Ordering` into an `ComparisonResult`.
    public var comparisonResult: ComparisonResult {
        switch self {
        case .less: return .orderedAscending
        case .equal: return .orderedSame
        case .greater: return .orderedDescending
        }
    }
    
}
