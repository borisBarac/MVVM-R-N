//
//  MainModelTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
@testable import Homework

class MainModelTests: XCTestCase {

    var model: MainViewModel!

    override func setUp() {
    }

    override func tearDown() {
    }

    func test() {
        var mainExpectation = expectation(description: "Main model working")
        model = MainViewModel(didChange: {
            mainExpectation.fulfill()
        })

        waitForExpectations(timeout: 1) { error in
            XCTAssert(self.model.data?.items.count ?? -1 > 0)
        }
    }

}
