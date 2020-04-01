//
//  EndPointsTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 22/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
@testable import Homework

class EndPointsTests: XCTestCase {
    let movie = "matrix"
    let list = "estrenos-imprescindibles-en-taquilla"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    fileprivate func testPath(endpoint: NetworkManager.EndPoints, key: String) throws {
        let endPoint = try XCTUnwrap(endpoint.url)
        let components = URLComponents(url: endPoint, resolvingAgainstBaseURL: true)

        XCTAssertNotNil(components?.host)
        XCTAssertNotNil(components?.path)
        XCTAssert(components?.path.contains(key) ?? false, "Wrong path")
    }

    func testMoviesPath() throws {
        try testPath(endpoint: NetworkManager.EndPoints.movie(movie), key: movie)
    }

    func testListPath() throws {
        try testPath(endpoint: NetworkManager.EndPoints.list(list), key: list)
    }

    func testMovieUrl() throws {
        let testString = "/v3/movies/\(movie)?classification_id=6&device_identifier=ios&market_code=es"
        let endPoint = try XCTUnwrap(NetworkManager.EndPoints.movie(movie).url)

        XCTAssert(endPoint.absoluteString.contains(testString), "Wrong URL")
    }

    func testListUrl() throws {
        let testString = "/v3/lists/\(list)?classification_id=6&device_identifier=ios&market_code=es"
        let endPoint = try XCTUnwrap(NetworkManager.EndPoints.list(list).url)

        XCTAssert(endPoint.absoluteString.contains(testString), "Wrong URL")
    }

}
