import Foundation
import XCTest

final class ForgotPasswordTestCase: XCTestCase {

    /// Tests password reset functionality
    func testForgotPassword() {
        app.button["Sign In"].tap()
        XCTAssertExists(app.other["SignInView"])

        app.button["Forgot your password?"].tap()
        XCTAssertExists(app.other["ForgotPasswordView"])

        app.textField["User Name"].tapAndType(text: self.defaultUser.username)

        app.button["Forgot Password"].tap()
        XCTAssertWaitForExistence(app.otherElements["UpdatePasswordView"].firstMatch)

        app.textFields["New Password"].firstMatch.tapAndType(text: self.defaultUser.password)

        app.buttons["Update Password"].firstMatch.tap()

        XCTAssertWaitForExistence(app.alerts["Password Reset Complete"].firstMatch)
        app.alerts["Password Reset Complete"].buttons["Ok"].firstMatch.tap()

        XCTAssert(app.otherElements["OnboardingView"].firstMatch.exists)
    }
}
