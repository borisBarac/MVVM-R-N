//
//  AppDelegate.swift
//  homework
//
//  Created by Boris Barac on 17/03/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        do {
            try globalBootStrap.router.showRoute(route: Route(routePath: .main), data: nil)
        } catch {
            print("Can not make root")
        }

        return true
    }

}
