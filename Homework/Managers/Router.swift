//
//  Router.swift
//  Music search
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import UIKit
import AVKit

struct Route: Decodable, Encodable {
    enum PresentationStyle: String, Decodable, Encodable {
        case push
        case pop
        case root
    }

    enum RoutePath: String, Decodable, Encodable {
        case main
        case detail
        case error
        case player
    }

    let routePath: RoutePath
    let presentationStyle: PresentationStyle
    let embedInNavBar: Bool
    let parrentRoutePath: String?
    // extra navigation bar
    let hasNavigation: Bool

    init(routePath: RoutePath, presentationStyle: PresentationStyle = .push, embedInNavBar: Bool = false, parrentRoutePath: String? = nil, hasNavigation: Bool = false) {
        self.routePath = routePath
        self.presentationStyle = presentationStyle
        self.embedInNavBar = embedInNavBar
        self.parrentRoutePath = parrentRoutePath
        self.hasNavigation = hasNavigation
    }

    static func makeMainErorRoute(error: Error) -> Route {
        return Route(routePath: .error, parrentRoutePath: nil, hasNavigation: false)
    }
}

final class Router {

    enum RouterError: Error {
        case canNotCalculateRoute
        case canNotMakeView
        case castingData
        case missingData
        case canNotPush
        case canNotPop
        case canNotMakeRoot
    }

    var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    var lastRoute: Route?
    var rootVC: UIViewController {
        let root = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController

        // fail fast approach, is this is boken, there is no app
        assert(root != nil)

        return root!
    }

    /// checks for logIn, local data, some upgrade option, what ever can be done here
    func calculate(route: Route) throws -> Route {
        switch route.routePath {
        case .detail:
            return Route(routePath: .detail, presentationStyle: .push, embedInNavBar: false, parrentRoutePath: nil)
        case .main:
            return Route(routePath: .main, presentationStyle: .root, embedInNavBar: true, parrentRoutePath: nil)
        case .player:
            return Route(routePath: .player, presentationStyle: .pop, embedInNavBar: false, parrentRoutePath: nil)
        default:
            throw RouterError.canNotCalculateRoute
        }
    }

    func makeView(route: Route, data: Any?) throws -> (UIViewController, Route?) {
        let route = try? calculate(route: route)
        switch route?.routePath {
        case .main:
            return (MainViewController(route: route, data: nil), route)
        case .detail:
            guard let _ = data else {
                throw RouterError.missingData
            }
            let vc = DetailViewController(route: route, data: data)
            return (vc, route)
        case .player:
            guard let url = data as? URL else {
                throw RouterError.castingData
            }
            return (makePlayerWith(url: url), route)
        default:
            throw RouterError.canNotMakeView
        }
    }

    func showRoute(route: Route, data: Any?, completion: ((UIViewController?) -> Void)? = nil) throws {
        var (vc, newRoute) = try makeView(route: route, data: data)

        guard let unRoute = newRoute else {
            throw RouterError.canNotCalculateRoute
        }

        if unRoute.embedInNavBar || unRoute.hasNavigation {
            vc = UINavigationController(rootViewController: vc)
        }

        switch unRoute.presentationStyle {
        case .push:
            if let navVC = topViewController?.navigationController {
                navVC.pushViewController(vc, animated: true, completion: {
                    completion?(vc)
                })
            } else {
                throw RouterError.canNotPush
            }
            lastRoute = newRoute
        case .pop:
            let presenting = topViewController ?? rootVC
            presenting.present(vc, animated: true, completion: {
                self.lastRoute = newRoute
                completion?(vc)
            })
        case .root:
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = vc
            (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
            lastRoute = newRoute
            completion?(vc)
        }
    }

    // MARK: - Helper
    func makePlayerWith(url: URL) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        return playerViewController
    }

    func displayCancelingAlert(title: String, subTitle: String) {
        guard isNotUnitTest else {
            return
        }

        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.topViewController?.present(alert, animated: true, completion: nil)
    }

}
