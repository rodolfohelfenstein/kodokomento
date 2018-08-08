//
//  Coordinator.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 31/07/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class Coordinator: Presentable {
    internal var childCoordinators: [Coordinator] = []

    // Coordinator Router

    internal var router: RouterType
    internal var factory: CoordinatorFactoryType
    internal var network: NetworkManagerType

    // Coordinator Starter Method

    func start() {}

    init(router: RouterType,
         factory: CoordinatorFactoryType,
         network: NetworkManagerType) {
        self.router = router
        self.factory = factory
        self.network = network
    }

    public func addDependency(_ coordinator: Coordinator) {
        if !childCoordinators.contains { return $0 === coordinator } {
            childCoordinators.append(coordinator)
        }
    }

    public func removeDependency(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }

    func toPresentable() -> UIViewController {
        return router.toPresentable()
    }
}
