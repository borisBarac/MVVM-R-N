//
//  MainModelTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
import OHHTTPStubsSwift
import OHHTTPStubs

@testable import Homework

class MainModelTests: XCTestCase {

    var model: MainViewModel!

    override func setUp() {
        // default
        stubTest(reqFail: false)
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }

    func testMainModelChange() {
        let mainExpectation = expectation(description: "Main model working")
        model = MainViewModel(didChange: {
            mainExpectation.fulfill()
        })

        waitForExpectations(timeout: 1) { error in
            let getItem = self.model.getItemsFor

            XCTAssertGreaterThan(getItem(.l1).count, 0, "No items for l1")
            XCTAssertGreaterThan(getItem(.l2).count, 0, "No items for l2")
            XCTAssertGreaterThan(getItem(.l3).count, 0, "No items for l3")
            XCTAssertGreaterThan(getItem(.l4).count, 0, "No items for l4")
            XCTAssertGreaterThan(getItem(.l5).count, 0, "No items for l5")
            XCTAssertGreaterThan(getItem(.l6).count, 0, "No items for l6")
        }
    }

    func testDataErrorBlock() {
        stubTest(reqFail: true)

        var called = false
        model = MainViewModel()
        model.dataErrorBlock = { _ in
            called = true
        }

        expectToEventually(called, timeout: 5, message: "Data Error block not called")
    }

    func testListIdInit() {
        let list = MainViewModel.ListId.getFrom(number: 1)
        XCTAssertEqual(list, .l2)

        let list2 = MainViewModel.ListId.getFrom(number: 2)
        XCTAssertEqual(list2, .l3)


        let list3 = MainViewModel.ListId.getFrom(number: -999)
        XCTAssertEqual(list3, .l1)

        let list4 = MainViewModel.ListId.getFrom(number: 0)
        XCTAssertEqual(list4, .l1)
    }

}
// MARK: - Stubs
extension MainModelTests {
    private func stubTest(reqFail: Bool) {
        stub(condition: isHost("gizmo.rakuten.tv") && pathStartsWith("/v3/lists/")) { _ in
            guard let path = OHPathForFile("ListMock.json", type(of: self)) else {
                    preconditionFailure("Could not find expected file in test bundle")
            }

            if reqFail == false {
                return HTTPStubsResponse(fileAtPath: path,
                                         statusCode: 200,
                                         headers: ["Content-Type": "application/json"])
            } else {
                return HTTPStubsResponse(error: NSError(
                    domain: "test",
                    code: 42,
                    userInfo: [:]))
            }
        }
    }
}
