//
//  DetailModelTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
import OHHTTPStubsSwift
import OHHTTPStubs

@testable import Homework

class DetailModelTests: XCTestCase {
    var model: DetailViewModel!
    var detailWorkerMock: DetailWorkerMock!

    override func setUp() {
        detailWorkerMock = DetailWorkerMock()
        model = DetailViewModel(detailWorker: detailWorkerMock)
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
        detailWorkerMock.shouldReturnError = nil
    }

    func testDetailChange() {
        model.data = Item.mockItem
        model.getDetails()

        expectToEventually(model.data?.short_plot != nil, timeout: 5, message: "Model did not change")
    }

    func testNoIdInit() {
        model.getDetails()
        expectToEventually(model.data?.short_plot == nil, timeout: 5, message: "ID is not nil")
    }

    func testDataErrorBlock() {
        var called = false
        detailWorkerMock.shouldReturnError = .wrongParameters

        model.dataErrorBlock = { _ in
            called = true
        }
        model.data = Item(id: "", numerical_id: -1279, title: nil, short_plot: nil, images: nil)
        model.getDetails()

        expectToEventually(called, timeout: 5, message: "Data Error block not called")
    }

    func testPlayStream() {
        var url: URL? = nil

        stub(condition: isHost("gizmo.rakuten.tv") && pathStartsWith("/v3/me/streamings")) { _ in
            guard let path = OHPathForFile("StreamMock.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return HTTPStubsResponse(fileAtPath: path,
                                     statusCode: 200,
                                     headers: ["Content-Type": "application/json"])
        }

        model.data = Item.mockItem
        model.getVideoUrlDetails { result in
            switch result {
            case .success(let resUrl):
                url = resUrl
            case .failure(let err):
                debugPrint(err.localizedDescription)
                XCTFail("Did not get playback url")
            }
        }

        expectToEventually(url != nil, timeout: 5, message: "Did not get playback url")
    }

    func testPlayStreamNoId() {
        var error = NetworkError.didNotWork
        model.data = nil
        let mainExpectation = expectation(description: "PlayStream no ID")

        model.getVideoUrlDetails { result in
            switch result {
            case .success:
                XCTFail("We are testing the error case")
            case .failure(let err):
                error = err
                mainExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5) { err in
            XCTAssertEqual(error, .wrongParameters)
        }
    }

    func testPlayStreamNetworkFail() {
        var error = NetworkError.parseFailed
        let mainExpectation = expectation(description: "PlayStream Network Fail")
        model.data = nil

        stub(condition: isHost("gizmo.rakuten.tv") && pathStartsWith("/v3/me/streamings")) { _ in
            return HTTPStubsResponse(error: NSError(
                domain: "test",
                code: 42,
                userInfo: [:]))
        }

        model.data = Item.mockItem
        model.getVideoUrlDetails { result in
            switch result {
            case .success:
                XCTFail("We are testing the error case")
            case .failure(let err):
                error = err
                mainExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5) { err in
            XCTAssertEqual(error, .didNotWork)
        }
    }

}
