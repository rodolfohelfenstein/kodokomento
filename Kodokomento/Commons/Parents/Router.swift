//
//  Router.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 31/07/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation
import UIKit

protocol RouterType: class, Presentable {
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }

    func present(module: Presentable)
    func present(module: Presentable, animated: Bool)
    func present(module: Presentable, animated: Bool, completion: (() -> Void)?)

    func push(module: Presentable)
    func push(module: Presentable, animated: Bool)
    func push(module: Presentable, animated: Bool, completion: (() -> Void)?)

    func setRoot(module: Presentable)
    func setRoot(module: Presentable, animated: Bool)
    func setRoot(module: Presentable, hideBar: Bool)
    func setRoot(module: Presentable, animated: Bool, hideBar: Bool)

    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)

    func pop(animated: Bool)

    func popToRoot(animated: Bool)
}

final class Router: NSObject {
    private var _completions: [UIViewController: () -> Void]

    private var _navigationController: UINavigationController

    public init(navigationController: UINavigationController = UINavigationController()) {
        _navigationController = navigationController
        _completions = [:]

        super.init()

        _navigationController.delegate = self
    }

    private func runCompletion(for controller: UIViewController) {
        _completions[controller]?()
        _completions.removeValue(forKey: controller)
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated _: Bool) {
        guard
            let viewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !_navigationController.viewControllers.contains(viewController) else {
            return
        }

        runCompletion(for: viewController)
    }
}

extension Router: RouterType {
    var navigationController: UINavigationController {
        return _navigationController
    }

    var rootViewController: UIViewController? {
        return _navigationController.viewControllers.first
    }

    func present(module: Presentable) {
        present(module: module, animated: true)
    }

    func present(module: Presentable, animated: Bool) {
        present(module: module, animated: animated, completion: nil)
    }

    func present(module: Presentable, animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            self?._navigationController.present(module.toPresentable(), animated: animated, completion: completion)
        }
    }

    func push(module: Presentable) {
        push(module: module, animated: true)
    }

    func push(module: Presentable, animated: Bool) {
        push(module: module, animated: animated, completion: nil)
    }

    func push(module: Presentable, animated: Bool, completion: (() -> Void)?) {
        let controller = module.toPresentable()

        guard controller is UINavigationController == false else { return }

        if let completion = completion { _completions[controller] = completion }

        DispatchQueue.main.async { [weak self] in
            self?._navigationController.pushViewController(controller, animated: animated)
        }
    }

    func setRoot(module: Presentable) {
        setRoot(module: module, animated: false, hideBar: false)
    }

    func setRoot(module: Presentable, animated: Bool) {
        setRoot(module: module, animated: animated, hideBar: false)
    }

    func setRoot(module: Presentable, hideBar: Bool) {
        setRoot(module: module, animated: false, hideBar: hideBar)
    }

    func setRoot(module: Presentable, animated: Bool, hideBar: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?._completions.forEach { $0.value() }
            self?._navigationController.setViewControllers([module.toPresentable()], animated: animated)
            self?._navigationController.isNavigationBarHidden = hideBar
        }
    }

    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            self?._navigationController.dismiss(animated: animated, completion: completion)
        }
    }

    func pop(animated: Bool) {
        DispatchQueue.main.async { [weak self] in

            if let controller = self?.navigationController.popViewController(animated: animated) {
                self?.runCompletion(for: controller)
            }
        }
    }

    func popToRoot(animated: Bool) {
        DispatchQueue.main.async { [weak self] in

            if let controllers = self?.navigationController.popToRootViewController(animated: animated) {
                controllers.forEach { self?.runCompletion(for: $0) }
            }
        }
    }

    func toPresentable() -> UIViewController {
        return _navigationController
    }
}
