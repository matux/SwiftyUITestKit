import Foundation
import XCTest

final class LogoutTestCase: XCTestCase, LoggingIn, LoggingOut, SigningUp {

    /// Tests logging a user out.
    func testLogout() {
        self.login(user: self.defaultUser)
        self.logout()
    }

    /// Tests logging a user out then logging it back in.
    func testLogoutThenLoginWithSameUser() {
        self.login(user: self.defaultUser)
        self.logout()

        app.navigationBar["Sign In"].button["Cancel"].tap()

        self.login(user: self.defaultUser)
    }

    /// Tests logging a user out then signing a new user up.
    func testLogoutThenSignup() {
        self.login(user: self.defaultUser)
        self.logout()

        app.navigationBar["Sign In"].button["Cancel"].tap()

        self.signup(user: .new)
        self.waitForSignupResult()
    }
}
