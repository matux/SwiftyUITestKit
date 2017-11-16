import XCTest

final class SignupTestCase: XCTestCase, SigningUp, FacebookLoggingIn {

    private let newUser: TestUser = .new

    /**
     Tests signup using password and expects a confirmation code to be sent before successfully joining.

     - TODO:
     Fix `confirmSignupWithCode` step. We need to be able to send a fake code and the server has to approve it.
     */
    func testSignupWithPassword() {
        self.signup(user: self.newUser)
        self.waitForSignupResult()
    }

    /// Tests signup using a Facebook account.
    func testSignupWithFacebook() {
        app.button["Join Now"].tap()
        XCTAssertExists(app.other["SignupView"])

        app.button["Continue with Facebook"].tap()
        self.monitorInterruption { alert in
            alert.button["Continue"].tap()
        }

        self.loginFacebookAccount(email: self.newUser.email, password: self.newUser.password)
        XCTAssertWaitForExistence(app.other["SignupDone"])

        app.button["Get Started"].tap()
        XCTAssertExists(app.navigationBar["Profile"])
    }

    /// Tests that we login automagically when trying to sign up using a registered Facebook account.
    func testSignupWithRegisteredFacebookAccount() {
        app.button["Join Now"].tap()
        XCTAssertExists(app.other["SignupView"])

        app.button["Continue with Facebook"].tap()
        self.monitorInterruption { alert in
            alert.button["Continue"].tap()
        }

        self.loginFacebookAccount(email: TestUser.facebook.email, password: TestUser.facebook.password)
        XCTAssertWaitForExistence(app.navigationBars["Home"])
    }

    /// Tests erroring when trying to signup using an existing username or email
    func testSignupWithExistingUsername() {
        self.signup(user: self.defaultUser)
        XCTAssertWaitForExistence(app.alerts.staticText["User already exists"])
        app.alerts.button["Ok"].tap()
    }


    /// Tests that tapping Create Account in the log in screen takes you to the sign up one.
    func testCreateAccountButtonInLoginTakesUserToSignup() {
        app.button["Sign In"].tap()
        XCTAssertExists(app.other["SignInView"])

        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.button["Create new account"].tap()
        XCTAssertExists(app.other["SignupView"])
    }
}
