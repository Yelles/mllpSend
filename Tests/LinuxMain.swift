import XCTest

import mllpSendTests

var tests = [XCTestCaseEntry]()
tests += mllpSendTests.allTests()
XCTMain(tests)