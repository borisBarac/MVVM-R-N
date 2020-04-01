//
//  Music_searchTests.swift
//  Music searchTests
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
@testable import Homework

class NetworkIntegrationTests: XCTestCase {
    var networkManager: NetworkManager!
    var session = URLSession(configuration: URLSessionConfiguration.default)

    let listId = "estrenos-imprescindibles-en-taquilla"
    let movieId = "matrix"

    override func setUp() {
        networkManager = NetworkManager(session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainJson() {
        var main: ListJson? = nil
        let mainExpectation = expectation(description: "parsed main json to object")

        let url = NetworkManager.EndPoints.list(listId).url

        networkManager.getJson(url: url) { (result: Result<ListJson, NetworkError>) in
            switch result {
            case .success(let object):
                main = object
                if object.data.contents.data.count > 0 {
                    mainExpectation.fulfill()
                } else {
                    XCTFail("No items")
                }
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail("Network error")
            }
        }

        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(main)
        }
    }

    func testDetailJson() {
        var detail: DetailJson? = nil
        let mainExpectation = expectation(description: "parsed detail json to object")

        let url = NetworkManager.EndPoints.list(listId).url

        networkManager.getJson(url: url) { (result: Result<DetailJson, NetworkError>) in
            switch result {
            case .success(let object):
                detail = object
                if detail?.data.id != nil {
                    mainExpectation.fulfill()
                } else {
                    XCTFail("Detail item not there")
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(detail)
        }
    }

    func testStreamJson() {
        var streamData: StreamResponce? = nil
        let mainExpectation = expectation(description: "parsed stream data")

        let url = NetworkManager.EndPoints.streamUrl(nil).url

        networkManager.postJson(url: url, postBody: StreamPostBody(content_id: "matrix")) { (result: Result<StreamResponce, NetworkError>) in
            switch result {
            case .success(let object):
                streamData = object
                if streamData?.data.stream_infos.first?.url != nil {
                    mainExpectation.fulfill()
                } else {
                    XCTFail("Stream data not there")
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(streamData)
        }
    }

}
