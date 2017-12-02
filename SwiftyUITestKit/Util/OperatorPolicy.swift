import Foundation

/**
 Coalescing `precedencegroup`.

     self as? Thing ?? Thing() « .any as Type == nil

 is evaluated as

     (((self as? Thing) ?? Thing()) « (.any as Type)) == nil

 - SeeAlso:
 [Policy.swift @ Swift's stdlib](https://github.com/apple/swift/blob/master/stdlib/public/core/Policy.swift)
 */
precedencegroup CoalescingPrecedence {
    associativity: right
    lowerThan: NilCoalescingPrecedence
    higherThan: ComparisonPrecedence
}

/**
 Binary operator intended for generic coalescing operations.

 - Note:
 `⌥ \` produces the `«` glyph.
 */
infix operator « : CoalescingPrecedence

/**
 Prefix operator caret, intended as *logical conjunction* between a parameter's type and the output type.
 */
prefix operator ^
