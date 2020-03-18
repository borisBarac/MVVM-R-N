//
//  Music_searchTests.swift
//  Music searchTests
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
@testable import Homework

class NetworkingManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    var session = URLSession(configuration: URLSessionConfiguration.default)
    let testDetailId = 33

    override func setUp() {
        networkManager = NetworkManager(session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDetailUrl() {
        let id = 36
        let url = NetworkManager.EndPoints.detail(36).url
        let contants = url?.absoluteString.contains(String(id))

        XCTAssert(contants ?? false, "Could not build test url")
    }

    func testMainUrl() {
        let url = NetworkManager.EndPoints.main.url

        XCTAssertNotNil(url)
    }

    func testMainJson() {
        var main: MainJson? = nil
        let mainExpectation = expectation(description: "parsed main json to object")

        guard let url = NetworkManager.EndPoints.main.url else {
            XCTFail()
            return
        }

        networkManager.getJson(url: url) { (result: Result<MainJson, NetworkError>) in
            switch result {
            case .success(let object):
                main = object
                if object.items.count > 0 {
                    mainExpectation.fulfill()
                } else {
                    XCTFail("No items")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(main)
        }
    }

    func testDetailJson() {
        var main: DetailJson? = nil
        let mainExpectation = expectation(description: "parsed detail json to object")

        guard let url = NetworkManager.EndPoints.detail(testDetailId).url else {
            XCTFail()
            return
        }

        networkManager.getJson(url: url) { (result: Result<DetailJson, NetworkError>) in
            switch result {
            case .success(let object):
                main = object
                if main?.item.id != nil {
                    mainExpectation.fulfill()
                } else {
                    XCTFail("Detail item not there")
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(main)
        }
    }

}
