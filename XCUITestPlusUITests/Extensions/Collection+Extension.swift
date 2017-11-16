//
//  Collection+Extension.swift
//  POPPLR
//
//  Created by Matias Pequeno on 9/1/17.
//  Copyright © 2017 Popplr. All rights reserved.
//

import Foundation

public extension Collection where Self.Index == Int, Self.IndexDistance == Self.Index {

    /// Safe Collection indexing.
    ///
    /// - parameter index: The index to subscript.
    ///
    /// - returns: The element at the given index or nil if out of bounds.
    public subscript(safe index: Self.Index) -> Iterator.Element? {
        return 0..<self.count ~= index ? self[index] : nil
    }
}

public extension Collection where Self: RangeReplaceableCollection, Self.Element: Equatable {

    @discardableResult
    public mutating func remove(element: Self.Element) -> Self.Element? {
        return self.index { indexed in indexed == element }
                   .map { index in self.remove(at: index) }
    }
}
