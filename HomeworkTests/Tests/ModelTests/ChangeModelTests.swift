//
//  ChangeModelTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
@testable import Homework

class ChangeModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDidChangeSubject() {
        let mainExpectation = expectation(description: "Change subject working")
        let model = ChangeModel<Int> {
            mainExpectation.fulfill()
        }

        model.data = 8
        waitForExpectations(timeout: 1) { error in
            XCTAssert(true)
        }
    }
}
