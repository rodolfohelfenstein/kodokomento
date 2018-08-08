//
//  GistCommentCoordinator.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class GistCommentCoordinator: Coordinator {

    // MARK: Properties

    fileprivate weak var mainController: GistCommentViewController?

    fileprivate weak var createController: GistCommentCreateViewController?

    private var _gistId: String

    // MARK: Initialize

    init(router: RouterType,
         factory: CoordinatorFactoryType,
         network: NetworkManagerType,
         gistId: String) {
        _gistId = gistId

        super.init(router: router,
                   factory: factory,
                   network: network)
    }

    // MARK: Lifecycle

    override func start() {
        showGistComment()
    }

    var finish: (() -> Void)?

    // MARK: Flows

    func showGistComment() {

        guard let controller = R.storyboard.gistComment.main() else {
            fatalError("GistCommentViewController in GistComment.storyboard has not found.")
        }

        controller.viewModel = GistCommentViewModel(network: network, gistId: _gistId)
        controller.viewModel?.coordinatorDelegate = self

        router.setRoot(module: controller, hideBar: false)

        mainController = controller

    }

    func showGistCommentCreate() {

        guard let controller = R.storyboard.gistComment.create() else {
            fatalError("GistCommentCreateViewController in GistComment.storyboard has not found.")
        }

        controller.viewModel = GistCommentCreateViewModel(network: network, gistId: _gistId)
        controller.viewModel?.coordinatorDelegate = self

        router.push(module: controller)

        createController = controller

    }

    // MARK: Module

    func runAuthenticationModule() {
        let coordinator = factory.makeAuthentication()
        addDependency(coordinator)
        coordinator.start()
        coordinator.finish = { [weak self] status in
            self?.removeDependency(coordinator)
            self?.router.dismiss(animated: true, completion: {

                if status {

                    let alert = UIAlertController(title: R.string.kodokomento.authorizeAlertTitle(),
                                                  message: R.string.kodokomento.authorizeAlertBody(),
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: R.string.kodokomento.authorizeAlertAction(),
                                                  style: .default,
                                                  handler: { [weak self] _ in
                                                    self?.createController?.viewModel?.didPostButtonTouched()
                    }))

                    self?.router.present(module: alert)

                }

            })

        }

        router.present(module: coordinator)
    }

}

extension GistCommentCoordinator: GistCommentViewModelCoordinatorDelegate {
    func commentCreated() {
        showGistCommentCreate()
    }
}

extension GistCommentCoordinator: GistCommentCreateViewModelCoordinatorDelegate {
    func close() {
        router.dismiss(animated: true)
    }

    func didCreate() {
        router.popToRoot(animated: true)
        mainController?.viewModel?.viewDidLoad()
    }

    func didUnauthenticate() {
        runAuthenticationModule()
    }
}
