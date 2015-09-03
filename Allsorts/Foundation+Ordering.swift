//
//  Foundation+Ordering.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

import Foundation

public extension Ordering {

    /// Convert an `NSComparisonResult` into an `Ordering`.
    public init(_ comparisonResult: NSComparisonResult) {
        self.init(comparisonResult.rawValue)
    }

    /// Convert an `Ordering` into an `NSComparisonResult`.
    public var comparisonResult: NSComparisonResult {
        switch self {
        case .LT: return .OrderedAscending
        case .EQ: return .OrderedSame
        case .GT: return .OrderedDescending
        }
    }
    
}
