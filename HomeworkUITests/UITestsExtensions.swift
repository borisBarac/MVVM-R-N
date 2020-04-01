
//
//  File.swift
//  HomeworkUITests
//
//  Created by Boris Barac on 29/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation
import XCTest

extension XCUIApplication {
    func goToDetail() {
        let collectionViews = self.collectionViews
        let cell = collectionViews.cells.element(boundBy: 1)
        cell.tap()
    }

    func playVideo() {
        let button = self.buttons.element(boundBy: 1)
        button.tap()
    }
}

extension NSPredicate {
    static var existsPredicate: NSPredicate {
        return NSPredicate(format: "exists == true")
    }
}
