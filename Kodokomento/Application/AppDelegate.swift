//
//  AppDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private lazy var coordinator = CoordinatorFactory().makeApp()

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator.toPresentable()
        window?.makeKeyAndVisible()

        coordinator.start()

        return true
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        if
            let code = urlComponents?.queryItems?.filter({ $0.name == "code" }).first,
            let value = code.value {
            NotificationCenter.default.post(name: .didPermissionSuccess,
                                            object: nil,
                                            userInfo: ["code": value])
        }

        return true
    }
}
