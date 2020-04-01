//
//  ModelExtensionsTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 25/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
@testable import Homework

class ModelExtensionsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConversionOfCodableToDictionary() throws {
        let image = Item.ItemImages(artwork: "test", snapshot: "test")

        let codable = Item(id: "11",
                           numerical_id: 12,
                           title: "Test",
                           short_plot: "ttest",
                           images: image)
        
        _ = try XCTUnwrap(codable.asDictionary())
    }
}
