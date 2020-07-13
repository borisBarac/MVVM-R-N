//
//  File.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

typealias ItemDictionary = [MainViewModel.ListId: [Item]]

final class MainViewModel: ChangeModel<ItemDictionary> {
    let listWorker: ListsWorkerProtocol
    var dataErrorBlock: ((NetworkError) -> Void)?
    let listIds: [ListId] = [.l1, .l2, .l3, .l4, .l5, .l6]

    func getItemsFor(list: ListId) -> [Item] {
        return data?[list] ?? [Item]()
    }

    init(didChange: (() -> Void)? = nil,
                  listWorker: ListsWorkerProtocol = ListsWorker()) {
        self.listWorker = listWorker
        super.init(didChange: didChange)
        buildData()
    }

    func reload() {
        data = nil
        buildData()
    }

    private func buildData() {
        listWorker.buildData(listIds: listIds) { result in
            switch result {
            case .success(let itemDictionary):
                self.data = itemDictionary
            case .failure(let error):
                self.dataErrorBlock?(error)
            }
        }
    }

}

extension MainViewModel {
    enum ListId: String {
        case l1 = "populares-en-taquilla"
        case l2 = "estrenos-para-toda-la-familia"
        case l3 = "estrenos-imprescindibles-en-taquilla"
        case l4 = "estrenos-espanoles"
        case l5 = "si-te-perdiste"
        case l6 = "nuestras-preferidas-de-la-semana"

        var title: String {
            switch self {
            case .l1:
                return "Populares en taquilla"
            case .l2:
                return "Estrenos para toda la familia"
            case .l3:
                return "Estrenos imprescindibles en taquilla"
            case .l4:
                return "Estrenos espanoles"
            case .l5:
                return "Si te perdiste"
            case .l6:
                return "Nuestras preferidas de la semana"
            }
        }

        var getIndex: Int {
            switch self {
            case .l1:
                return 0
            case .l2:
                return 1
            case .l3:
                return 2
            case .l4:
                return 3
            case .l5:
                return 4
            case .l6:
                return 5
            }
        }

        static func getFrom(number: Int) -> ListId {
            switch number {
            case 0:
                return .l1
            case 1:
                return .l2
            case 2:
                return .l3
            case 3:
                return .l4
            case 4:
                return .l5
            case 5:
                return .l6
            default:
                return .l1
            }
        }
    }
}
