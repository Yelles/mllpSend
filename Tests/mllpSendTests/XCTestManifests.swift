import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(mllpSendTests.allTests),
    ]
}
#endif