//
//  ModelStructs.swift
//  Music search
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

struct ListJson: Codable, Hashable {
    let data: JsonData

    struct JsonData: Codable {
        let type: String
        let id: String
        let numerical_id: Int64

        let contents: Contents

        struct Contents: Codable {
            let data: [Item]
        }
    }

    // should not be compared
    static func == (lhs: ListJson, rhs: ListJson) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(data.id)
    }
}

struct DetailJson: Codable, Hashable {
    let data: Item

    // should not be compared
    static func == (lhs: DetailJson, rhs: DetailJson) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(data.numerical_id)
    }
}

struct Item: Codable, Hashable {
    let id: String
    let numerical_id: Int64
    let title: String?
    let short_plot: String?

    let images: ItemImages?

    struct ItemImages: Codable, Hashable {
        let artwork: String
        let snapshot: String
    }

    // should not be compared
    static func == (lhs: Item, rhs: Item) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct StreamResponce: Codable {
    let data: StreamData

    struct StreamData: Codable {
        let type: String
        let id: String
        let stream_infos: [StreamInfo]
    }
}

struct StreamInfo: Codable {
    let url: String
    let video_quality: String
}
