//
//  BaseWorker.swift
//  Homework
//
//  Created by Boris Barac on 7/11/20.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

class BaseNetworkWorker {
    let networkManager: NetworkManager

    init(networkManager: NetworkManager = globalBootStrap.networkManager) {
        self.networkManager = networkManager
    }
}
