//
//  GistCoordinator.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class GistCoordinator: Coordinator {
    // MARK: Lifecycle

    override func start() {
        showGist()
    }

    var finish: (() -> Void)?

    // MARK: Flows

    func showGist() {
        guard let controller = R.storyboard.gist.main() else {
            fatalError("GistViewController in Gist.storyboard has not found.")
        }

        controller.viewModel = GistViewModel(network: network)

        controller.viewModel?.coordinatorDelegate = self

        router.setRoot(module: controller, hideBar: false)
    }

    func showGistDetail(gistId: String) {
        guard let controller = R.storyboard.gist.detail() else {
            fatalError("GistDetailViewController in Gist.storyboard has not found.")
        }

        controller.viewModel = GistDetailViewModel(network: network,
                                                   gistId: gistId)
        controller.viewModel?.coordinatorDelegate = self

        router.push(module: controller)
    }

    // MARK: Modules

    func runScannerModule() {
        let coordinator = factory.makeScanner()
        addDependency(coordinator)
        coordinator.start()
        coordinator.finish = { [weak self] value in
            self?.removeDependency(coordinator)
            self?.router.dismiss(animated: true)

            if let value = value { self?.showGistDetail(gistId: value) }
        }

        router.present(module: coordinator)
    }

    func runCameraPermissionModule() {
        let coordinator = factory.makeCameraPermission()
        addDependency(coordinator)
        coordinator.start()
        coordinator.finish = { [weak self] value in
            self?.removeDependency(coordinator)
            self?.router.dismiss(animated: true)

            if value { self?.runScannerModule() }
        }

        router.present(module: coordinator)
    }

    func runGistCommentsModule(gistId: String) {
        let coordinator = factory.makeGistComment(gistId: gistId)
        addDependency(coordinator)
        coordinator.start()
        coordinator.finish = { [weak self] in
            self?.removeDependency(coordinator)
            self?.router.dismiss(animated: true)
        }

        router.present(module: coordinator)
    }
}

extension GistCoordinator: GistViewModelCoordinatorDelegate {
    func showScanner() {
        switch CameraScanHelper.permission() {
        case .authorized:
            runScannerModule()
        case .denied,
             .notDetermined,
             .restricted:
            runCameraPermissionModule()
        }
    }
}

extension GistCoordinator: GistDetailViewModelCoordinatorDelegate {
    func close() {
        router.popToRoot(animated: true)
    }

    func showComments(gistId: String) {
        runGistCommentsModule(gistId: gistId)
    }

    func gistNotFound() {
        router.popToRoot(animated: true)
    }
}
