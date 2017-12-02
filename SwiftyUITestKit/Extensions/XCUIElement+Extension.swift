import Foundation
import XCTest

extension XCUIElement {

    /// Returns an `XCTAttachment` with debugging information about this `XCUIElement`
    var attachement: XCTAttachment {
        return XCTAttachment(name: "\(self)", string: "\(self.debugDescription)", lifetime: .deleteOnSuccess)
    }

    /**
     Sends a tap event to a hittable point computed for the element.

     - Parameters:
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
    */
    func tap(_ file: StaticString, _ line: UInt) {
        XCTContext.runActivity(named: "Tap \(self)") { tapActivity in
            XCTContext.runActivity(named: "Gather debug data") { _ in
                tapActivity.add(self.attachement)
            }

            XCTAssert(self.exists, "\(self) doesn't exist", file: file, line: line)
            XCTAssert(self.isEnabled, "\(self) isn't enabled", file: file, line: line)

            self.tap()
        }
    }

    /**
     Sends a tap event to a hittable point computed for the element to gain keyboard focus, then
     types a string into the element.

     - Parameters:
       - text: Text to type on the element.
       - waitForFocus: Waits synchronously for the element to obtain focus, useful when dealing with WebViews.
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
     */
    func tapAndType(text: String, waitForFocus: Bool = false, _ file: StaticString = #file, _ line: UInt = #line) {
        XCTContext.runActivity(named: "Tap \(self) and type \(text)") { tapActivity in
            XCTContext.runActivity(named: "Gather debug data") { _ in
                tapActivity.add(self.attachement)
            }

            XCTAssert(self.exists, "\(self) doesn't exist", file: file, line: line)
            XCTAssert(self.isEnabled, "\(self) isn't enabled", file: file, line: line)

            self.tap()

            if waitForFocus, let testCase = XCTestCase.current {
                let expectation = testCase.expectation(for: ^"hasKeyboardFocus == true", evaluatedWith: self)
                let waiterResult = XCTWaiter().wait(for: [expectation], timeout: XCTestCase.defaultTimeout)
                XCTAssertEqual(waiterResult, .completed, "\(self) didn't focus after tap.", file: file, line: line)
            } else {
                XCTAssert(self.hasKeyboardFocus, "\(self) didn't focus after tap.", file: file, line: line)
            }

            self.typeText(text)
        }
    }

    /**
     Clears text from a `XCUIElement`.

     - Precondition: Element must have focus. (eg. tap() prior to calling this function)

     - Parameters:
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
     */
    func clearText(_ file: StaticString = #file, _ line: UInt = #line) {
        XCTAssert(self.exists, "\(self) doesn't exist", file: file, line: line)
        XCTAssert(self.hasKeyboardFocus, "\(self) must have focus.", file: file, line: line)

        let deleteKey = XCUIKeyboardKey.delete.rawValue
        let textLength = self.value(as: String.self).count
        let delete = String(repeating: deleteKey, count: textLength)
        self.typeText(delete)
    }

    /**
     Taps this element to acquire focus and clears text.

     - Parameters:
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
     */
    func tapAndClearText(_ file: StaticString = #file, _ line: UInt = #line) {
        self.tap(file, line)
        self.clearText(file, line)
    }

    /**
     Waits a default amount of time for the element's exist property to be true and returns false if the
     timeout expires without the element coming into existence.
     */
    func waitForExistence() -> Bool {
        return self.waitForExistence(timeout: XCTestCase.defaultTimeout)
    }


    /**
     Waits the specified amount of time for the predicate to evaluate true and returns false if the
     timeout expires without the predicate ever being true.

     - Parameters:
       - predicate: Predicate to evaluate.
       - timeout: How long till we time out.

     - Returns:
     True if the predicate evaluates as true, false on timeout or interruption.
     */
    func wait(for predicate: NSPredicate, timeout: TimeInterval = XCTestCase.defaultTimeout) -> Bool {
        guard let testCase = XCTestCase.current else {
            return false
        }

        let expectation = testCase.expectation(for: predicate, evaluatedWith: self)
        let waiterResult = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return waiterResult == .completed
    }
}
