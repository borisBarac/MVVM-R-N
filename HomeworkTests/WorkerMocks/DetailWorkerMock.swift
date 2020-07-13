//
//  DetailWorkerMock.swift
//  HomeworkTests
//
//  Created by Boris Barac on 7/11/20.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

@testable import Homework

/// This works great, gives you control, you can make many mocks, but the problem when u use mocks based on protocols or on subclass is that is breaks the code coverage map.
/// And functions that are actually covered withe the tests (Like the mormal worker when mocking the API) are not covered with tests anymore, and that requres extra unit tests to be writen.
class DetailWorkerMock: DetailWorkerProtocol {

    var shouldReturnError: NetworkError?

    func getDetailsForItemWith(id: String, completionHandler: @escaping (Result<Item, NetworkError>) -> Void) {
        if let err = shouldReturnError {
            completionHandler(.failure(err))
        }

        let detailJson: DetailJson = mockObjectForJson(file: "DetailMock")
        completionHandler(.success(detailJson.data))
    }
}
