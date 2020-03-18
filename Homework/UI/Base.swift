//
//  baseModel.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

protocol BaseView {
    associatedtype Model

    var route: Route? { get }
    var data: Any? { get set }
    var model: Model { get set }
}

class ChangeModel<T: Codable> {
    var data: T? = nil {
        didSet {
            DispatchQueue.main.async {
                self.didChange?()
            }
        }
    }

    var didChange: (() -> ())? = nil

    init(didChange: (() -> ())? = nil) {
        self.didChange = didChange
    }
}
