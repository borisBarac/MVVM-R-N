//
//  ModelStructs.swift
//  Music search
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

struct MainJson: Codable {
    let items: [Item]
}

struct DetailJson: Codable {
    let item: Item
}

struct Item: Codable {
    let id: Int
    let title: String?
    let subtitle: String?
    let date: String?
    let body: String?
}
