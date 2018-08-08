//
//  AuthenticationCoordinator.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation
import SafariServices

class AuthenticationCoordinator: Coordinator {

    // MARK: Properties

    fileprivate weak var authenticationController: AuthenticationViewController?

    // MARK: Lifecycle

    override func start() {
        showAuthentication()
    }

    var finish: ((Bool) -> Void)?

    // MARK: Flows

    func showAuthentication() {

        guard let controller = R.storyboard.authentication.main() else {
            fatalError("AuthenticationViewController of Authentication.storyboard has not found.")
        }

        controller.viewModel = AuthenticationViewModel(network: network)
        controller.viewModel?.coordinatorDelegate = self

        router.setRoot(module: controller,
                       hideBar: false)

        authenticationController = controller

    }

}

extension AuthenticationCoordinator: AuthenticationViewModelCoordinatorDelegate {

    func showSafariView(url: URL) {
        let controller = SFSafariViewController(url: url)
        controller.delegate = authenticationController

        router.present(module: controller)
    }

    func close() {
        finish?(false)
    }

    func closeSafariView() {
        router.dismiss(animated: true)
    }

    func authenticated(credential: Credential) {

        LocalStorageHelper.accessToken = credential.accessToken
        finish?(true)

    }

}
