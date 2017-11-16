import Foundation
import XCTest

/// Describes the capability for signing a user up.
protocol SigningUp {

    /**
     Signs a user up.

     - Parameters:
       - user: The TestUser object containing the signup data.
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
     */
    func signup(user: TestUser, _ file: StaticString, _ line: UInt)

    /**
     Waits synchronously for the Signup process to complete. Test will fail if signup fails.

     - Parameters:
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
     */
    func waitForSignupResult(_ file: StaticString, _ line: UInt)
}

extension SigningUp where Self: XCTestCase {

    func signup(user: TestUser, _ file: StaticString = #file, _ line: UInt = #line) {
        app.button["Join Now"].tap(file, line)
        XCTAssertExists(app.other["SignupView"], file: file, line: line)

        app.textField["User Name"].tapAndType(text: user.username, file, line)
        app.secureTextField["Password"].tapAndType(text: user.password, file, line)
        app.textField["Email"].tapAndType(text: user.email, file, line)

        app.button["Join Now"].tap(file, line)
    }

    func waitForSignupResult(_ file: StaticString = #file, _ line: UInt = #line) {
        XCTAssertWaitForExistence(app.other["SignupCongratulationsView"], file: file, line: line)
        app.button["Get Started"].tap(file, line)
    }
}

