import Foundation
import XCTest

/// Describes the capability of logging a user in
protocol LoggingOut {

    /// Logs a user in. Assumes the Me tab within the main tab bar is accessible.
    func logout(file: StaticString, line: UInt)
}

extension LoggingOut where Self: XCTestCase {

    func logout(file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Log user out") { _ in
            XCTContext.runActivity(named: "Go to Me section") { _ in
                app.tabBars.button["Me"].tap(file, line)
                XCTAssertExists(app.navigationBar["Me"],
                                "Tapping Me didn't show Me's section.", file: file, line: line)
            }

            XCTContext.runActivity(named: "Go to Settings and Tap Logout") { _ in
                app.navigationBar["Me"].button["settingsIconWhite"].tap(file, line)
                app.tables.cells.staticText["Log Out"].tap(file, line)
                XCTAssertWaitForExistence(app.navigationBar["Sign In"],
                                          "Log out button didn't take us back to Sign In screen.", file: file, line: line)
            }
        }
    }
}
