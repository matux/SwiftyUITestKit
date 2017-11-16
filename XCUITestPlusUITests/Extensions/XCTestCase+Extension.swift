import Foundation
import XCTest

private struct AssociatedKeys {
    static var application = 0 as UInt8
    static var interruptionMonitors = 0 as UInt8
}

/// Traits available to all `XCTestCase` implementations.
extension XCTestCase {

    /// Current `XCTestCase` being run.
    fileprivate(set) static weak var current: XCTestCase?

    /// Default timeout interval for synchronous operations
    static let defaultTimeout = 15 as TimeInterval

    /**
     Default user for test cases.

     - Note:
     Override on your `XCTestCase` implementation to use other users.
     */
    var defaultUser: TestUser { return .existing }

    /**
     Single shared instance of `XCUIApplication` intended to avoid `XCUIApplication()` repetition.

         class MyTestCase: XCTestCase {
             func test() {
                 app.buttons["Ok"].firstMatch.tap()
             }
         }

     - Attention:
     Explicit usage of `self` to access `app` is exceptionally **discouraged**. Goal is to improve maintainability
     through simplicity while ensuring `XCTest` usage remains predictable and familiar.
     */
    var app: XCUIApplication {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.application) as! XCUIApplication }
        set { objc_setAssociatedObject(self, &AssociatedKeys.application, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /**
     Enumerates all valid launch arguments.

     `cleanSlate`: Requests the app to start as if it were a first time launch. Test should expect app's storage to be completely purged.

     - Attention:
     Map new arguments to this `enum` to take advantage of compile-time type checking.
     */
    enum LaunchArgument: String {
        case cleanSlate = "cleanSlate"
    }

    /**
     Launch arguments to be passed to the XCUIApplication.

     - Note:
     Override to pass different arguments.
     */
    var launchArguments: [LaunchArgument] {
        return [.cleanSlate]
    }

    /**
     Waits synchronously for the fullscreen activity indicator overlay to disappear. The UI is
     non-interactive while the overlay is on-screen.

     - Parameters:
       - timeout: How long to wait before failing. Defaults to `XCTest.defaultTimeout`.
       - file: The file name to log in case of failure. Defaults to the caller's file.
       - line: The line number to log in case of failure. Defaults to the caller's line.
     */
    func waitForActivity(timeout: TimeInterval = XCTestCase.defaultTimeout,
                         _ file: StaticString = #file, _ line: UInt = #line)
    {
        let activityOverlay = app.other["LoadingActivityOverlay"]
        guard activityOverlay.exists else {
            return
        }

        XCTContext.runActivity(named: "Wait for fullscreen activity indicator overlay to disappear.") { _ in
            XCTAssertWaitForDisappearance(activityOverlay, timeout: timeout, file: file, line: line)
        }
    }
}

/**
 Mixin providing default behavior for all `XCTestCase` implementations.

 - Note
 *"Extensions [...] cannot override existing functionality."*

 This language directive can be violated when
 dealing with objc classes by ensuring the overriden functions are dynamically dispatched.

 While this isn't ideal, subclassing `XCTestCase` to create a base class for our test cases has two issues:
 1. Diverts from standard/familiar framework usage.
 2. XCode thinks that base class is an actual test case and lists it everywhere as such adding a layer of
 potential confusion and unexpected bugs.
 */
extension XCTestCase {

    open override dynamic func setUp() {
        super.setUp()

        XCTestCase.current = self

        self.continueAfterFailure = false
        self.app = XCUIApplication()
        self.app.launchArguments = self.launchArguments.map { $0.rawValue }
        self.app.launch()
    }
}

/**
 Monitor interruption wrapper.
 */
extension XCTestCase {

    func monitorInterruption(handler: @escaping (XCUIElement) -> Void) {
        var monitorUUID: UUID!

        let objectRef = self.addUIInterruptionMonitor(withDescription: "") { interruptingElement in
            handler(interruptingElement)
            return true
        }

        // XCTest's `add...Monitor` returns an `NSObjectProtocol`. Why? Because #yolo.
        let uuidString = (objectRef as AnyObject).uuidString
        monitorUUID = uuidString.flatMap(UUID.init)
        guard monitorUUID != nil else {
            self.removeUIInterruptionMonitor(objectRef)
            return XCTFail("Fatal error trying to add interruption monitor with UUID \(String(reflecting: objectRef))")
        }

        self.addTeardownBlock { [unowned self] in
            self.removeUIInterruptionMonitor(monitorUUID as NSObjectProtocol)
        }
    }
}
