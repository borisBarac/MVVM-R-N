//
//  DetailModelTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
@testable import Homework

class DetailModelTests: XCTestCase {

    var model: DetailViewModel!
    var mainExpectation: XCTestExpectation!

    override func setUp() {
        // is here because didChange is getting called multiple times
        mainExpectation = expectation(description: "Detail model working")
        model = DetailViewModel(didChange: check)
    }

    override func tearDown() {
    }

    func test() {
        model.data = Item(id: 33, title: nil, subtitle: nil, date: nil, body: nil)
        model.getDetails()

        wait(for: [mainExpectation], timeout: 5)
    }

    func check() {
        if model.data?.body != nil {
            mainExpectation.fulfill()
        }
    }

}
