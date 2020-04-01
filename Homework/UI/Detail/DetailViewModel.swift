//
//  DetailViewModel.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

final class DetailViewModel: ChangeModel<Item> {
    let networkManager: NetworkManager
    var dataErrorBlock: ((NetworkError) -> ())?

    // item is in data of superclass

    init(didChange: (() -> Void)? = nil, networkManager: NetworkManager = globalBootStrap.networkManager) {
        self.networkManager = networkManager
        super.init(didChange: didChange)

    }

    func getDetails() {
        guard let movieId = data?.id else {
            self.dataErrorBlock?(.wrongParameters)
            return
        }

        networkManager.getJson(url: NetworkManager.EndPoints.movie(movieId).url) { (result: Result<DetailJson, NetworkError>) in
            switch result {
            case .success(let object):
                self.data = object.data
            case .failure(let error):
                print(error.localizedDescription)
                self.dataErrorBlock?(error)
            }
        }
    }

    func getVideoUrlDetails(completionHandler: @escaping (Result<URL, NetworkError>) -> Void) {
        guard let movieId = data?.id else {
            completionHandler(.failure(.wrongParameters))
            return
        }

        let url = NetworkManager.EndPoints.streamUrl(nil).url
        networkManager.postJson(url: url, postBody: StreamPostBody(content_id: movieId)) { (result: Result<StreamResponce, NetworkError>) in
            switch result {
            case .success(let object):
                if let urlString = object.data.stream_infos.first?.url, let url = URL(string: urlString) {
                    DispatchQueue.main.async {
                        completionHandler(.success(url))
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.didNotWork))
                }
            }
        }
    }
}
