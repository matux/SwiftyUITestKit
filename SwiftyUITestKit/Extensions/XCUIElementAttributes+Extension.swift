import Foundation
import XCTest

extension XCUIElementAttributes where Self == XCUIElement {

    /**
     Get the element's value as if it were expressible by a String literal. If it isn't, an empty String
     literal will be returned instead.

     - Parameter:
       - as: Type the value should be returned as.
     */
    func value<T: ExpressibleByStringLiteral>(as: T.Type) -> T {
        return self.value as? T ?? ""
    }

    /**
     Get the element's value casted as the passed Type, if cast isn't possible, nil is returned.

     - Note:

     This is the preferred way to retrieve Boolean values from elements.

     - Parameter:
       - as: Type the value should be returned as.
     */
    func value<T>(as: T.Type) -> T? {
        switch self.value {
        case let value as String where T.self is Bool.Type:
            return value.contains("1") as? T
        default:
            return self.value as? T
        }
    }

    /**
     Returns whether or not this element has keyboard focus.

     - Remark:
     This function seems to be missing from `XCUIElementAttributes` yet it's documented as existing.

     Documentation: [XCUIElementAttributes.hasFocus](https://developer.apple.com/documentation/xctest/xcuielementattributes/1627636-hasfocus)
     */
    var hasKeyboardFocus: Bool {
        return self.value(forKey: "hasKeyboardFocus") as? Bool ?? false
    }
}
