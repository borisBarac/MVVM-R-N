//
//  NetworkingManager.swift
//  Music search
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let mainReload = Notification.Name(rawValue: "main_reload")
}

// should be in some BE config
private var pathDict = [
    NetworkManager.EndPoints.main.hashValue: "test/native/contentList.json",
    NetworkManager.EndPoints.detail(nil).hashValue: "test/native/content/{ID}.json"
]

enum NetworkError: Error {
    case didNotWork
}

final class NetworkManager {

    // MARK: - Enums
    enum PathReplacementKeys: String {
        case itemId = "ID"

        var replaceKey: String {
            return "{\(self.rawValue)}"
        }
    }

    public enum EndPoints: Hashable {
        case main
        case detail(Int?)

        var hashValue: Int {
            switch self {
            case .main:
                return 1
            case .detail:
                return 2
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .main:
                hasher.combine(1)
            case .detail:
                hasher.combine(2)
            }
        }

        var domain: String {
            switch globalBootStrap.currentSetUp {
                default:
                    return "http://dynamic.pulselive.com/"
            }
        }

        private var buildPath: String {
            return domain + (pathDict[self.hashValue] ?? "")
        }

        var url: URL! {
            let path = self.buildPath

            switch self {
            case .detail(let itemId):
                guard let unId = itemId else {
                    return URL(string: self.buildPath)
                }

                return URL(string: path.replacingOccurrences(of: PathReplacementKeys.itemId.replaceKey, with: String(unId)))
            default:
                return URL(string: self.buildPath)
            }

        }
    }

    // MARK: - Main CODE
    private let urlSession: URLSession

    init(session: URLSession = URLSession.shared) {
        urlSession = session
    }

    func getJson<T: Codable>(url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let task = urlSession.dataTask(with: url){ (data, response, error) in
            debugPrint(response as Any)
            guard let data = data else {
                completionHandler(.failure(.didNotWork))
                return
            }

            do {
                let item = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(item))
                debugPrint(item)
            } catch {
                debugPrint("parseFailed")
                completionHandler(.failure(.didNotWork))
            }
        }
        task.resume()
    }
}
