import Foundation
import XCTest

final class AutoLoginTestCase: XCTestCase, LoggingIn, FacebookLoggingIn, LoggingOut {

    /// Test auto-login with password
    func testAutoLoginWithPassword() {
        self.login(user: self.defaultUser)
        self.logout()

        self.app.restart()

        XCTAssertWaitForExistence(app.navigationBar["Home"])
    }

    /// Tests auto-login using a Facebook account
    func testAutoLoginWithFacebook() {
        self.loginWithFacebook(user: .facebook)
        self.logout()

        self.app.restart()

        XCTAssertWaitForExistence(app.navigationBar["Home"])
    }
}
