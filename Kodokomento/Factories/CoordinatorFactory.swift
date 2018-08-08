//
//  CoordinatorFactory.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 31/07/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryType: class {
    func makeApp() -> AppCoordinator
    func makeAuthentication() -> AuthenticationCoordinator
    func makeScanner() -> ScannerCoordinator
    func makeCameraPermission() -> CameraPermissionCoordinator
    func makeGist() -> GistCoordinator
    func makeGistComment(gistId: String) -> GistCommentCoordinator
}

class CoordinatorFactory: CoordinatorFactoryType {
    func makeApp() -> AppCoordinator {
        let navigationController = UINavigationController()

        let router = Router(navigationController: navigationController)
        let factory = CoordinatorFactory()
        let network = NetworkManager()

        return AppCoordinator(router: router,
                              factory: factory,
                              network: network)
    }

    func makeAuthentication() -> AuthenticationCoordinator {
        guard let navigationController = R.storyboard.authentication.root() else {
            fatalError("Root Navigation of Authentication.storyboard has not found.")
        }

        let router = Router(navigationController: navigationController)
        let factory = CoordinatorFactory()
        let network = NetworkManager()

        return AuthenticationCoordinator(router: router,
                                         factory: factory,
                                         network: network)
    }

    func makeScanner() -> ScannerCoordinator {
        guard let navigationController = R.storyboard.scanner.root() else {
            fatalError("Root Navigation of Scanner.storyboard has not found.")
        }

        let router = Router(navigationController: navigationController)
        let factory = CoordinatorFactory()
        let network = NetworkManager()

        return ScannerCoordinator(router: router,
                                  factory: factory,
                                  network: network)
    }

    func makeCameraPermission() -> CameraPermissionCoordinator {
        guard let navigationController = R.storyboard.cameraPermission.root() else {
            fatalError("Root Navigation of CameraPermission.storyboard has not found.")
        }

        let router = Router(navigationController: navigationController)
        let factory = CoordinatorFactory()
        let network = NetworkManager()

        return CameraPermissionCoordinator(router: router,
                                           factory: factory,
                                           network: network)
    }

    func makeGist() -> GistCoordinator {
        guard let navigationController = R.storyboard.gist.root() else {
            fatalError("Root Navigation of Gist.storyboard has not found.")
        }

        let router = Router(navigationController: navigationController)
        let factory = CoordinatorFactory()
        let network = NetworkManager()

        return GistCoordinator(router: router,
                               factory: factory,
                               network: network)
    }

    func makeGistComment(gistId: String) -> GistCommentCoordinator {
        guard let navigationController = R.storyboard.gist.root() else {
            fatalError("Root Navigation of GistComment.storyboard has not found.")
        }

        let router = Router(navigationController: navigationController)
        let factory = CoordinatorFactory()
        let network = NetworkManager()

        return GistCommentCoordinator(router: router,
                                      factory: factory,
                                      network: network,
                                      gistId: gistId)
    }
}
