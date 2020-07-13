//
//  DetailViewModel.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

final class DetailViewModel: ChangeModel<Item> {
    let detailWorker: DetailWorkerProtocol
    let streamWorker: StreamWorkerProtocol
    var dataErrorBlock: ((NetworkError) -> ())?

    // item is in the data of the superclass

    init(didChange: (() -> Void)? = nil, detailWorker: DetailWorkerProtocol = DetailWorker(), streamWorker: StreamWorkerProtocol = StreamWorker()) {
        self.detailWorker = detailWorker
        self.streamWorker = streamWorker
        super.init(didChange: didChange)

    }

    func getDetails() {
        guard let movieId = data?.id else {
            self.dataErrorBlock?(.wrongParameters)
            return
        }

        detailWorker.getDetailsForItemWith(id: movieId) { (result: Result<Item, NetworkError>) in
            switch result {
            case .success(let object):
                self.data = object
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

        streamWorker.getStreamUrlWith(id: movieId) { (result: Result<StreamResponce, NetworkError>) in
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
