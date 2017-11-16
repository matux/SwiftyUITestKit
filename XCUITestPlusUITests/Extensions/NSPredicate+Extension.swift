//
//  NSPredicate+Extension.swift
//  POPPLR
//
//  Created by Matias Pequeno on 10/21/17.
//  Copyright © 2017 Popplr. All rights reserved.
//

import Foundation

/**
 Operator overload to generate `NSPredicate` from a String literal. Unfortunately, `NSPredicate` cannot
 be extended to be `ExpressibleByStringLiteral`.

 - Parameters:
   - format: Format of the Predicate.

 - Returns:
   A new `NSPredicate` with the provided format.
 */
public prefix func ^ (format: String) -> NSPredicate {
    return NSPredicate(format: format)
}
