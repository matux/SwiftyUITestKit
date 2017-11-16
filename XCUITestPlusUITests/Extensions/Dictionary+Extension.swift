//
//  Dictionary+Extension.swift
//  POPPLR
//
//  Created by Matias Pequeno on 9/20/17.
//  Copyright © 2017 Popplr. All rights reserved.
//

import Foundation

extension Dictionary {

    /// Constructor for creating a dictionary based on a pair of (key, value). This is useful to allow
    /// "dictionary comprehension".
    ///
    /// - parameter pairs: An array of pairs (key, value). Note that the resulting dictionary will end up
    ///                    being of type: [key.Type: value.Type].
    public init(_ pairs: [(Key, Value)]) {
        self.init(minimumCapacity: pairs.count)

        pairs.forEach { self[$0.0] = $0.1 }
    }
}
