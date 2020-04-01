//
//  NetworkExtensions.swift
//  Homework
//
//  Created by Boris Barac on 25/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
