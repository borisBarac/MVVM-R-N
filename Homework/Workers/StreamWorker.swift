//
//  StreamWorker.swift
//  Homework
//
//  Created by Boris Barac on 7/11/20.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

protocol StreamWorkerProtocol: class {
    func getStreamUrlWith(id: String, completionHandler: @escaping (Result<StreamResponce, NetworkError>) -> Void)
}

final class StreamWorker: BaseNetworkWorker, StreamWorkerProtocol {
    func getStreamUrlWith(id: String, completionHandler: @escaping (Result<StreamResponce, NetworkError>) -> Void) {
        let url = NetworkManager.EndPoints.streamUrl(nil).url
        networkManager.postJson(url: url, postBody: StreamPostBody(content_id: id)) { (result: Result<StreamResponce, NetworkError>) in
            completionHandler(result)
        }

    }
}
