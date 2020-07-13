//
//  TestUtilities.swift
//  HomeworkTests
//
//  Created by Boris Barac on 7/11/20.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

func mockObjectForJson<T: Codable>(file: String) -> T {
    let data = Bundle.dataFor(file: file)
    let object = try! JSONDecoder().decode(T.self, from: data)
    return object
}

extension Bundle {
    static func dataFor(file: String, type: String = "json") -> Data {
        let bundle = Bundle(for: RouterTests.self)
        let path = bundle.url(forResource: file, withExtension: type)!
        let data = try? Data(contentsOf: path)

        assert(data != nil, "MOCK for \(file) is not there!!!")

        return data!
    }
}
