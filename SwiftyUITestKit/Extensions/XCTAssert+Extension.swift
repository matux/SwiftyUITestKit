import Foundation
import XCTest

/**
 Asserts whether an element exists or not.

 - Parameters:
   - element: Element to assert existence.
   - message: Optional message to use in case of failure.
   - file: The file name to log in case of failure. Defaults to the caller's file.
   - line: The line number to log in case of failure. Defaults to the caller's line.
 */
func XCTAssertExists(_ element: @autoclosure () throws -> XCUIElement,
                     _ message: @autoclosure () -> String = "",
                     file: StaticString = #file, line: UInt = #line)
{
    XCTEvaluateAssertion(.exists, message: message, file: file, line: line) {
        let element = try element()
        guard element.exists else {
            return .expectedFailure("(\"\(String(describing: element)))\") doesn't exist.")
        }

        return .success
    }
}

/**
 Waits synchronously for an element to appear.

 - Parameters:
   - element: `XCUIElement` expected to appear.
   - timeout: How long we'll wit before failing. Defaults to `XCTest.defaultTimeout`.
   - message: Optional message to log in case of failure.
   - file: The file name to log in case of failure. Defaults to the caller's file.
   - line: The line number to log in case of failure. Defaults to the caller's line.
 */
func XCTAssertWaitForExistence(_ element: @autoclosure () throws -> XCUIElement,
                               timeout: TimeInterval = XCTestCase.defaultTimeout,
                               _ message: @autoclosure () -> String = "",
                               file: StaticString = #file, line: UInt = #line)
{
    XCTEvaluateAssertion(.waitForExistence, message: message, file: file, line: line) {
        let element = try element()
        guard element.waitForExistence(timeout: timeout) else {
            return .expectedFailure("(\"\(String(describing: element)))\") never appeared")
        }

        return .success
    }
}


/**
 Waits synchronously for an element to disappear.

 - Parameters:
   - element: `XCUIElement` expected to disappear.
   - timeout: How long we'll wit before failing. Defaults to `XCTest.defaultTimeout`.
   - message: Optional message to log in case of failure.
   - file: The file name to log in case of failure. Defaults to the caller's file.
   - line: The line number to log in case of failure. Defaults to the caller's line.
 */
func XCTAssertWaitForDisappearance(_ element: @autoclosure () throws -> XCUIElement,
                                   timeout: TimeInterval = XCTestCase.defaultTimeout,
                                   _ message: @autoclosure () -> String = "",
                                   file: StaticString = #file, line: UInt = #line)
{
    XCTEvaluateAssertion(.waitForDisappearance, message: message, file: file, line: line) {
        guard let testCase = XCTestCase.current else {
            return .expectedFailure("No TestCase currently being run")
        }

        let element = try element()
        guard element.exists else {
            return .expectedFailure("(\"\(String(describing: element)))\") doesn't exist")
        }

        let expectation = testCase.expectation(for: ^"exists == false", evaluatedWith: element)
        let waiterResult = XCTWaiter().wait(for: [expectation], timeout: timeout)
        let errorString = "(\"\(String(describing: element)))\") never disappeared"

        switch waiterResult {
            case .completed:
                return .success
            case .timedOut:
                return .expectedFailure("\(errorString) (.timedOut)")
            default:
                return .expectedFailure("\(errorString) (\(waiterResult)")
        }
    }
}

// MARK: - Here be dragons
//
// Based off Swift's corelib source code:
//  https://github.com/apple/swift-corelibs-xctest/blob/master/Sources/XCTest/Public/XCTAssert.swift

/// Extend base assertions to facilitate following the standard logging scheme of XCTAssert*.
private enum XCTAssertion {
    case exists
    case waitForExistence
    case waitForDisappearance

    var name: String? {
        switch(self) {
            case .exists: return "XCTAssertExists"
            case .waitForExistence: return "XCTAssertWaitForExistence"
            case .waitForDisappearance: return "XCTAssertWaitForDisappearance"
        }
    }
}

/// Builds assertion messages following the standard logging scheme of XCTAssert*.
private enum XCTAssertionResult {
    case success
    case expectedFailure(String?)
    case unexpectedFailure(Swift.Error)

    var isExpected: Bool {
        switch self {
            case .unexpectedFailure(_): return false
            default: return true
        }
    }

    func failureDescription(_ assertion: XCTAssertion) -> String {
        let explanation: String
        switch self {
            case .success: explanation = "passed"
            case .expectedFailure(let details?): explanation = "failed: \(details)"
            case .expectedFailure(_): explanation = "failed"
            case .unexpectedFailure(let error): explanation = "threw error \"\(error)\""
        }

        if let name = assertion.name {
            return "\(name) \(explanation)"
        } else {
            return explanation
        }
    }
}

/// Records failure of assertions following the standard logging scheme of XCTAssert*.
private func XCTEvaluateAssertion(_ assertion: XCTAssertion, message: @autoclosure () -> String = "",
                                  file: StaticString = #file, line: UInt = #line,
                                  expression: () throws -> XCTAssertionResult)
{
    let result: XCTAssertionResult
    do {
        result = try expression()
    } catch {
        result = .unexpectedFailure(error)
    }

    switch result {
        case .success:
            return
        default:
            XCTestCase.current?.recordFailure(
                withDescription: "\(result.failureDescription(assertion)) - \(message())",
                inFile: String(describing: file),
                atLine: Int(line),
                expected: result.isExpected)
    }
}
