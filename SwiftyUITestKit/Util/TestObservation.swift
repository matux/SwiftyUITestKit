import Foundation
import XCTest

final class TestObservation: NSObject, XCTestObservation {

    private lazy var testObservationCenter = XCTestObservationCenter.shared

    override init() {
        super.init()

        self.testObservationCenter.addTestObserver(self)
    }

    func testBundleWillStart(_ testBundle: Bundle) {

    }

    func testSuiteWillStart(_ testSuite: XCTestSuite) {

    }

    func testCaseWillStart(_ testCase: XCTestCase) {

    }

    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String,
                  inFile filePath: String?, atLine lineNumber: Int)
    {

    }

    func testCaseDidFinish(_ testCase: XCTestCase) {

    }

    func testSuiteDidFinish(_ testSuite: XCTestSuite) {

    }

    func testBundleDidFinish(_ testBundle: Bundle) {
        self.testObservationCenter.removeTestObserver(self)
    }
}
