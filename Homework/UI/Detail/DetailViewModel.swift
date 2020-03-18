//
//  DetailViewModel.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

final class DetailViewModel: ChangeModel<Item> {
    let networkManager = globalBootStrap.networkManager

    // item is in data of superclass

    func getDetails() {
        guard let itemId = self.data?.id else {
            return
        }

        networkManager.getJson(url: NetworkManager.EndPoints.detail(itemId).url) { (result: Result<DetailJson, NetworkError>) in
            switch result {
            case .success(let object):
                self.data = object.item
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
