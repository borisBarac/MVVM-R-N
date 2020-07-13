//
//  DetailWorkerTests.swift
//  HomeworkTests
//
//  Created by Boris Barac on 7/11/20.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
import OHHTTPStubsSwift
import OHHTTPStubs

@testable import Homework

class DetailWorkerTests: XCTestCase {


    func testGettingData() {
        let id = Item.mockItem.id
        var plot: String? = nil

        DetailWorker().getDetailsForItemWith(id: id) { result in
            switch result {
            case .success(let detail):
                plot = detail.short_plot
            default:
                print("fail")
            }

        }

        expectToEventually(plot == nil, timeout: 5, message: "ID is not nil")
    }

    func testWrongParameters() {
        var err: NetworkError? = nil

        DetailWorker().getDetailsForItemWith(id: "") { result in
            switch result {
            case .failure(let error):
                err = error
                debugPrint(error.localizedDescription)
            default:
                print("fail")
            }

        }

        expectToEventually(err == nil, timeout: 5, message: "ID is not nil")
    }


}
