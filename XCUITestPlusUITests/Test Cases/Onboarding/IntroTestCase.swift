import Foundation
import XCTest

final class IntroTestCase: XCTestCase {

    func testSignupAndLoginIsAccessibleAndCancelable() {
        XCTAssertExists(app.other["OnboardingView"])

        XCTContext.runActivity(named: "Access Sign in and come back") { _ in
            app.button["Join Now"].tap()
            app.navigationBar["Sign Up"].button["Cancel"].tap()
            XCTAssertExists(app.other["OnboardingView"])
        }

        XCTContext.runActivity(named: "Access Log in and come back") { _ in
            app.button["Sign In"].tap()
            app.navigationBar["Sign In"].button["Cancel"].tap()
            XCTAssertExists(app.other["OnboardingView"])
        }
    }

    func testIntroPaging() {
        XCTAssert(app.otherElements["OnboardingView"].firstMatch.exists)

        XCTContext.runActivity(named: "Swipe pages forward") { _ in
            for page in 1...4 {
                app.pageIndicator["page \(page) of 5"].swipeLeft()
            }
        }

        XCTContext.runActivity(named: "Swipe pages back") { _ in
            for page in (2...5).reversed() {
                app.pageIndicator["page \(page) of 5"].swipeRight()
            }
        }

        XCTContext.runActivity(named: "Assert we're at page one") { _ in
            XCTAssertExists(app.pageIndicator["page 1 of 5"])
        }

        XCTContext.runActivity(named: "Assert Sign up and Log in are still accessible.") { _ in
            self.testSignupAndLoginIsAccessibleAndCancelable()
        }
    }
}
