//
//  HomeworkUITests.swift
//  HomeworkUITests
//
//  Created by Boris Barac on 29/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest

/**
 # READ ME

 - In general is better to use accesebility IDs but for this simple UI there is really no need.
 - Navigation functions are extracted and shared in `XCUIApplication`
 - What should also be here, but the app is to simple, is to add specific accesebility IDs to specific elements that are gonna be used for screen identification and to share that code that so it can be reused
 */
class HomeworkUITests: XCTestCase {

    let app: XCUIApplication = {
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]

        return app
    }()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainViewController() {
        app.launch()

        let collectionViews = app.collectionViews
        let cell = collectionViews.cells.element(boundBy: 1)

        let exists = NSPredicate.existsPredicate
        expectation(for: exists, evaluatedWith: cell, handler: nil)

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(cell.exists)
        XCTAssertEqual(collectionViews.count, 6)

        for i in 0..<6 {
            let cellCount = collectionViews.element(boundBy: i).cells.count
            XCTAssertGreaterThan(cellCount, 0)
        }
    }

    func testDetailViewController() {
        app.launch()
        app.goToDetail()

        let playButton = app.buttons.element(boundBy: 0)
        let exists = NSPredicate.existsPredicate
        expectation(for: exists, evaluatedWith: playButton, handler: nil)

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(playButton.exists)

        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)
    }

    func testPlayerViewController() {
        app.launch()
        app.goToDetail()
        app.playVideo()

        let player = app.otherElements["Video"]
        let exists = NSPredicate.existsPredicate
        expectation(for: exists, evaluatedWith: player, handler: nil)

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(player.exists)
    }
}
