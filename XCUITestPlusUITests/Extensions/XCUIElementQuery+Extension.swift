import Foundation
import XCTest

extension XCUIElementQuery {

    /// Immediately evaluates the query and returns an array of elements bound by the index of each result.
    var elements: [XCUIElement] {
        return self.allElementsBoundByIndex
    }

    /**
     Returns an element that will use the index into the query's results to determine which underlying
     accessibility element it is matched with.

     - Parameter index: Index the element is bound by.
     */
    subscript(index: Int) -> XCUIElement {
        return self.element(boundBy: index)
    }
}
