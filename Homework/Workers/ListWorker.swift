//
//  ListWorker.swift
//  Homework
//
//  Created by Boris Barac on 7/11/20.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

protocol ListsWorkerProtocol: class {
    func buildData(listIds: [MainViewModel.ListId], completionHandler: @escaping (Result<ItemDictionary, NetworkError>) -> Void)
}

final class ListsWorker: BaseNetworkWorker, ListsWorkerProtocol {
    private var reqInProgress = false

    func buildData(listIds: [MainViewModel.ListId], completionHandler: @escaping (Result<ItemDictionary, NetworkError>) -> Void) {
        guard reqInProgress == false else {
            return
        }

        var temp = ItemDictionary()
        let dispatchGroup = DispatchGroup()
        var reqResArr = [Bool]()

        reqInProgress = true
        listIds.forEach { (listId) in
            dispatchGroup.enter()
            networkManager.getJson(url: NetworkManager.EndPoints.list(listId.rawValue).url) { (result: Result<ListJson, NetworkError>) in
                switch result {
                case .success(let object):
                    reqResArr.append(true)
                    temp[listId] = object.data.contents.data
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(.failure(error))
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            guard reqResArr.count == listIds.count else {
                return
            }

            self.reqInProgress = false
            completionHandler(.success(temp))
        }
    }
}
