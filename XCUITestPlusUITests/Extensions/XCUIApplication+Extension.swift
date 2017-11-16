import Foundation
import XCTest

extension XCUIApplication {

    /// Terminates and relaunches the application synchronously. On return the application ready to handle
    /// events. Any failure in the sequence will be reported as a test failure and the test will be halted
    /// at that point.
    open func restart() {
        self.terminate()

        if !self.wait(for: .notRunning, timeout: XCTestCase.defaultTimeout) {
            XCTFail("App didn't terminate within the alloted time.")
        }

        // Avoid clean slate to trigger autologin
        self.launchArguments.remove(element: "cleanSlate")
        self.launchEnvironment.removeValue(forKey: "cleanSlate")
        self.launch()

        if !self.wait(for: .runningForeground, timeout: XCTestCase.defaultTimeout) {
            XCTFail("App didn't launch within the alloted time.")
        }
    }
}
