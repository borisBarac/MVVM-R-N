//
//  File.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

final class MainViewModel: ChangeModel<MainJson> {
    let networkManager = globalBootStrap.networkManager

    var items: [Item] {
        return data?.items ?? [Item]()
    }

    override init(didChange: (() -> ())? = nil) {
        super.init(didChange: didChange)
        networkManager.getJson(url: NetworkManager.EndPoints.main.url) { (result: Result<MainJson, NetworkError>) in
            switch result {
            case .success(let object):
                if object.items.count > 0 {
                    self.data = object
                } else {
                    self.data = nil
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
