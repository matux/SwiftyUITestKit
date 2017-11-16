import Foundation
import XCTest

/// Describes the capability of logging in using Facebook.
protocol FacebookLoggingIn {

    func loginFacebookAccount(email: String, password: String, _ file: StaticString, _ line: UInt)
}

// Internal enum to keep track and identify each one of the Facebook's login stages and its components.
fileprivate enum LoginStage {
    typealias ButtonElement = XCUIElement
    typealias TextFieldElement = XCUIElement

    case credentials(email: TextFieldElement?, password: TextFieldElement?, button: ButtonElement, title: String)
    case permissions(button: ButtonElement, title: String)
    case confirmLogin(button: ButtonElement, title: String)

    static func from(webView: XCUIElement) -> LoginStage? {
        let (email, password, label, login) = (webView.textFields["Email or Phone"], webView.secureTextFields["Facebook Password"],
                                               webView.staticTexts["Enter email or phone"], webView.buttons["Log In"])

        // Credential input stages
        if email.exists && (label.exists || !password.exists) {
            return .credentials(email: email, password: nil, button: login, title: "Enter email and continue")
        } else if password.exists && !email.exists {
            return .credentials(email: nil, password: password, button: login, title: "Enter password and continue")
        } else if email.exists && password.exists {
            return .credentials(email: email, password: password, button: login, title: "Enter email, password and continue")
        }

        // Permissions and confirmation stages
        if case let continueAs = webView.buttons["Continue as Popplr"], continueAs.exists {
            return .permissions(button: continueAs, title: "Accept read permissions notice")
        } else if webView.staticTexts["Post to Facebook"].exists {
            return .permissions(button: webView.buttons["OK"], title: "Authorize publish permissions request")
        }

        // Final confirmation stage
        if webView.staticTexts["Confirm Login"].exists {
            return .confirmLogin(button: webView.buttons["Continue"], title: "Confirm login and wait for result")
        }

        return nil
    }
}

extension FacebookLoggingIn where Self: XCTestCase {

    func loginFacebookAccount(email: String, password: String,
                              _ file: StaticString = #file, _ line: UInt = #line)
    {
        // It seems that `.firstMatch` crashes the system when a WebView is being shown.
        let webView = app.webViews.element
        XCTContext.runActivity(named: "Trigger iOS Facebook Alert") { _ in
            webView.tap() // Needed to trigger interruption for the alert monitor ¯\_(ツ)_/¯
        }

        // Facebook is tricky because credentials are managed by both Facebook and iOS itself, so it's
        // difficult to assume or predict state.
        let loggingIn = { () -> Bool in
            XCTContext.runActivity(named: "Wait for Facebook to respond") { _ in
                webView.exists && webView.otherElements["Facebook"].waitForExistence()
            }
        }

        let loginStage = { () -> LoginStage? in
            XCTContext.runActivity(named: "Resolve current login stage") { _ in
                .from(webView: webView)
            }
        }

        while loggingIn() {
            switch loginStage() {
            case let .credentials(emailField, passwordField, button, title)?:
                XCTContext.runActivity(named: title) { _ in
                    emailField?.tapAndType(text: email, waitForFocus: true, file, line)
                    passwordField?.tapAndType(text: password, waitForFocus: true, file, line)
                    button.tap(file, line)
                }
            case let .permissions(button, title)?:
                XCTContext.runActivity(named: title) { _ in
                    button.tap(file, line)
                }

            case let .confirmLogin(button, title)?:
                XCTContext.runActivity(named: title) { _ in
                    button.tap(file, line)
                    XCTAssertWaitForDisappearance(webView, file: file, line: line)
                }

            case nil:
                XCTFail("Unsupported Facebook login stage", file: file, line: line)
            }
        }
    }
}
