//
//  baseModel.swift
//  Homework
//
//  Created by Boris Barac on 18/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation
import UIKit

var isIpad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

protocol BaseView {
    associatedtype Model

    var route: Route? { get }
    var data: Any? { get set }
    var model: Model { get set }
}

class ChangeModel<T: Hashable> {
    var data: T? = nil {
        didSet {
            DispatchQueue.main.async {
                self.didChange?()
            }
        }
    }

    var didChange: (() -> Void)?

    init(didChange: (() -> Void)? = nil) {
        self.didChange = didChange
    }
}
