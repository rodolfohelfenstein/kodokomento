//
//  AppCoordinator.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 31/07/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    lazy var tabBarController: UITabBarController = {
        let controller = UITabBarController()
        controller.tabBar.isHidden = true

        return controller

    }()

    lazy var gistCoordinator: GistCoordinator = {
        let coordinator = factory.makeGist()
        coordinator.start()
        coordinator.finish = { [weak self] in
        }
        addDependency(coordinator)

        return coordinator

    }()

    override func start() {
        let coordinators: [UIViewController] = [gistCoordinator.toPresentable()]

        tabBarController.setViewControllers(coordinators, animated: false)

        router.setRoot(module: tabBarController, hideBar: true)
    }
}
