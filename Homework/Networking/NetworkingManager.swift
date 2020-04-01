//
//  NetworkingManager.swift
//  Music search
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import Foundation

// should be in some BE config
private var pathDict = [
    NetworkManager.EndPoints.movie(nil).hashValue: "v3/movies/{ID}",
    NetworkManager.EndPoints.list(nil).hashValue: "v3/lists/{ID}",
    NetworkManager.EndPoints.streamUrl(nil).hashValue: "v3/me/streamings",
]

enum NetworkError: Error {
    case didNotWork
    case parseFailed
    case wrongParameters
}

final class NetworkManager {

    // MARK: - Enums
    enum PathReplacementKeys: String {
        case itemId = "ID"

        var replaceKey: String {
            return "{\(self.rawValue)}"
        }
    }

    // MARK: - Main CODE
    private let urlSession: URLSession

    init(session: URLSession = URLSession.shared) {
        urlSession = session
    }

    func getJson<T: Codable>(url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.didNotWork))
                return
            }

            do {
                let item = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(item))
            } catch(let err) {
                debugPrint(err.localizedDescription)
                debugPrint("parseFailed")
                completionHandler(.failure(.parseFailed))
            }
        }
        task.resume()
    }

    func postJson<T: Codable, V: Codable>(url: URL, postBody: V? = nil, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let body = try? postBody?.asDictionary() else {
            debugPrint("Can not conver Codable to Dictionary")
            completionHandler(.failure(.wrongParameters))
            return
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            completionHandler(.failure(.wrongParameters))
            return
        }

        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.didNotWork))
                return
            }

            do {
                let item = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(item))
            } catch(let err) {
                debugPrint(err.localizedDescription)
                debugPrint("parseFailed")
                completionHandler(.failure(.parseFailed))
            }
        }
        task.resume()
    }
}

// MARK: - EndPoints
extension NetworkManager {
    enum EndPoints: Hashable {
        case movie(String?)
        case list(String?)
        case streamUrl(String?)

        var hashValue: Int {
            switch self {
            case .movie:
                return 1
            case .list:
                return 2
            case .streamUrl:
                return 3
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .movie:
                hasher.combine(1)
            case .list:
                hasher.combine(2)
            case .streamUrl:
                hasher.combine(2)
            }
        }

        var domain: String {
            switch globalBootStrap.currentSetUp {
                default:
                    return "https://gizmo.rakuten.tv/"
            }
        }

        private var buildPath: String {
            return domain + (pathDict[self.hashValue] ?? "")
        }

        var url: URL {
            let path = self.buildPath

            let partialUrl: URL! = {
                switch self {
                case .list(let itemId), .movie(let itemId):
                    guard let unId = itemId else {
                        return URL(string: self.domain)
                    }

                    return URL(string: path.replacingOccurrences(of: PathReplacementKeys.itemId.replaceKey, with: String(unId)))

                case .streamUrl:
                    guard let url = URL(string: path) else {
                        return URL(string: self.domain)
                    }

                    return url
                }
            }()

            return appendDefaultParameters(url: partialUrl)
        }

        private func appendDefaultParameters(url: URL) -> URL {
            var componets = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if componets?.queryItems == nil {
                componets?.queryItems = [URLQueryItem]()
            }
            componets?.queryItems?.append(URLQueryItem(name: "classification_id", value: "6"))
            componets?.queryItems?.append(URLQueryItem(name: "device_identifier", value: "ios"))
            componets?.queryItems?.append(URLQueryItem(name: "market_code", value: "es"))

            return componets?.url ?? url
        }

    }
}
