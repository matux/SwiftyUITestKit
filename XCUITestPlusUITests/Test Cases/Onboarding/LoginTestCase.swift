import Foundation
import XCTest

final class LoginTestCase: XCTestCase, LoggingIn, FacebookLoggingIn {

    /// Tests login using a valid Facebook account.
    func testLoginWithFacebook() {
        self.loginWithFacebook(user: .facebook)
    }

    /// Test manual username/password login with valid credentials.
    func testLogin() {
        self.login(user: self.defaultUser)
    }

    /**
     Tests error feedback when providing empty credentials, username and/or password. Also asserts login is
     still possible after failure by providing valid credentials.
     */
    func testLoginErrorOnEmptyCredentials() {
        app.button["Sign In"].tap()
        XCTAssertExists(app.other["SignInView"])

        let usernameField = app.textField["User Name"]
        let passwordField = app.secureTextField["Password"]

        XCTAssert(usernameField.value(as: String.self).isEmpty, "Username field should be initially empty.")
        XCTAssert(passwordField.value(as: String.self).isEmpty, "Password field should be initially empty.")

        XCTContext.runActivity(named: "Log in with empty credentials to trigger alerts.") { _ in
            XCTContext.runActivity(named: "Empty username and password.") { _ in
                app.button["Sign In"].tap()
                app.alert["User name is Required"].button["Ok"].tap()
            }

            XCTContext.runActivity(named: "Valid username and empty password.") { _ in
                usernameField.tapAndType(text: self.defaultUser.username)

                app.button["Sign In"].tap()
                app.alert["Password Required"].button["Ok"].tap()
            }

            XCTContext.runActivity(named: "Empty username and valid password.") { _ in
                usernameField.tapAndClearText()
                passwordField.tapAndType(text: self.defaultUser.password)

                app.button["Sign In"].tap()
                app.alert["User name is Required"].button["Ok"].tap()
            }
        }

        XCTContext.runActivity(named: "Ensurelog in is still possible after failure.") { _ in
            usernameField.tapAndClearText()
            usernameField.typeText(self.defaultUser.username)
            passwordField.tapAndClearText()
            passwordField.typeText(self.defaultUser.password)

            app.button["Sign In"].tap()
            XCTAssertWaitForExistence(app.navigationBar["Home"])
        }
    }

    /**
     Tests error feedback when providing invalid credentials such as for a non-existing username, or a
     wrong password for an existing user. Also asserts login is still possible after failure by providing
     valid credentials.
     */
    func testLoginErrorOnInvalidCredentials() {
        app.button["Sign In"].tap()
        XCTAssertExists(app.other["SignInView"])

        let usernameField = app.textField["User Name"]
        let passwordField = app.secureTextField["Password"]

        XCTAssert(usernameField.value(as: String.self).isEmpty, "Username field should be initially empty.")
        XCTAssert(passwordField.value(as: String.self).isEmpty, "Password field should be initially empty.")

        XCTContext.runActivity(named: "Log in with invalid credentials to trigger alert.") { _ in
            XCTContext.runActivity(named: "Incorrect password.") { _ in
                usernameField.tapAndType(text: self.defaultUser.username)
                passwordField.tapAndType(text: "B4Dm34t")

                app.button["Sign In"].tap()

                let alert = app.alert["Login error"]
                XCTAssertWaitForExistence(alert)
                XCTAssertExists(alert.staticText["Invalid username or password."])
                alert.buttons["Ok"].tap()
            }

            XCTContext.runActivity(named: "Non-existing user.") { _ in
                usernameField.tapAndClearText()
                usernameField.typeText("B4Dm34tF00")
                passwordField.tapAndClearText()
                passwordField.typeText(self.defaultUser.password)

                app.button["Sign In"].tap()

                let alert = app.alert["Login error"]
                XCTAssertWaitForExistence(alert)
                XCTAssertExists(alert.staticText["Invalid username or password."])
                alert.buttons["Ok"].tap()
            }
        }

        XCTContext.runActivity(named: "Ensure login is still possible after failure.") { _ in
            usernameField.tapAndClearText()
            usernameField.typeText(self.defaultUser.username)
            passwordField.tapAndClearText()
            passwordField.typeText(self.defaultUser.password)

            app.button["Sign In"].tap()
            XCTAssertWaitForExistence(app.navigationBar["Home"])
        }
    }
}
