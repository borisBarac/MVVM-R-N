//
//  XCTestExtensions.swift
//  HomeworkTests
//
//  Created by Boris Barac on 22/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation
import XCTest

@testable import Homework

extension XCTest {
    func expectToEventually(_ condition: @autoclosure () -> Bool, timeout: TimeInterval = 1.0, message: String = "") {
        busyWait(
            condition(),
            for: timeout,
            onFulfilled: {},
            onTimeout: { XCTFail(message) }
        )
    }

    func expect(_ condition: @autoclosure () -> Bool, for duration: TimeInterval, message: String = "") {
        busyWait(
            !condition(),
            for: duration,
            onFulfilled: { XCTFail(message) },
            onTimeout: {}
        )
    }

    func busyWait(
        _ condition: @autoclosure () -> Bool,
        for duration: TimeInterval,
        onFulfilled: () -> Void,
        onTimeout: () -> Void
        ) {

        let runLoop = RunLoop.current
        let timeoutDate = Date(timeIntervalSinceNow: duration)

        repeat {
            if condition() {
                onFulfilled()
                return
            }
            runLoop.run(until: Date(timeIntervalSinceNow: 0.01))
        } while Date().compare(timeoutDate) == .orderedAscending

        onTimeout()
    }
    
}

extension Item {
    static var mockItem: Item {
        return Item(id: "matrix", numerical_id: 8329, title: "Matrix", short_plot: nil, images: nil)
    }
}
