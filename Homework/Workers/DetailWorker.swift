//
//  DetailWorker.swift
//  Homework
//
//  Created by Boris Barac on 7/11/20.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

protocol DetailWorkerProtocol: class {
    func getDetailsForItemWith(id: String, completionHandler: @escaping (Result<Item, NetworkError>) -> Void)
}

final class DetailWorker: BaseNetworkWorker, DetailWorkerProtocol {
    func getDetailsForItemWith(id: String, completionHandler: @escaping (Result<Item, NetworkError>) -> Void) {
        networkManager.getJson(url: NetworkManager.EndPoints.movie(id).url) { (result: Result<DetailJson, NetworkError>) in
            completionHandler(
                result.map { (detail) -> Item in
                    return detail.data
            })
        }
    }
}
