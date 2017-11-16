import Foundation
import XCTest

/// Describes the capability of logging a user in
protocol LoggingIn {

    /**
     Logs a user in. Assumes initial Onboarding screen as the starting point.

     - Parameters:
       - user: TestUser containing the login data.
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
    */
    func login(user: TestUser, _ file: StaticString, _ line: UInt)

    /**
     Logs a user in with Facebook. Assumes initial Onboarding screen as the starting point.

     - Parameters:
       - user: TestUser containing the Facebook login data.
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
     */
    func loginWithFacebook(user: TestUser, _ file: StaticString, _ line: UInt)
}

extension LoggingIn where Self: XCTestCase {

    func login(user: TestUser, _ file: StaticString = #file, _ line: UInt = #line) {
        XCTContext.runActivity(named: "Log user \"\(user.username)\" in") { _ in
            XCTAssertExists(app.other["OnboardingView"], "The OnboardingView doesn't exists", file: file, line: line)

            app.button["Sign In"].tap(file, line)
            XCTAssertExists(app.other["SignInView"], "SignInView didn't show after tapping Sign In", file: file, line: line)

            app.textField["User Name"].tapAndType(text: user.username, file, line)
            app.secureTextField["Password"].tapAndType(text: user.password, file, line)
            app.button["Sign In"].tap(file, line)

            XCTAssertWaitForExistence(app.navigationBar["Home"], file: file, line: line)
            self.waitForActivity(file, line)
        }
    }

    func loginWithFacebook(user: TestUser, _ file: StaticString = #file, _ line: UInt = #line) {
        XCTFail("Conform to FacebookLoggingIn in order to be able to log in using Facebook.")
    }
}

extension LoggingIn where Self: XCTestCase, Self: FacebookLoggingIn {

    func loginWithFacebook(user: TestUser, _ file: StaticString = #file, _ line: UInt = #line) {
        app.button["Sign In"].tap(file, line)
        XCTAssertExists(app.other["SignInView"], file: file, line: line)

        app.button["Continue with Facebook"].tap(file, line)
        self.monitorInterruption { alert in
            alert.button["Continue"].tap(file, line)
        }

        XCTContext.runActivity(named: "Login on Facebook") { _ in
            self.loginFacebookAccount(email: user.email, password: user.password, file, line)
        }

        XCTAssertWaitForExistence(app.navigationBars["Home"], file: file, line: line)
    }
}
