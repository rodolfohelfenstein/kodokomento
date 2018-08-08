//
//  CameraPermissionCoordinator.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class CameraPermissionCoordinator: Coordinator {

    // MARK: Lifecycle

    override func start() {
        showCameraPermission()
    }

    var finish: ((Bool) -> Void)?

    // MARK: Flows

    func showCameraPermission() {

        guard let controller = R.storyboard.cameraPermission.main() else {
            fatalError("CameraPermissionViewController in CameraPermission.storyboard has not found.")
        }

        controller.viewModel = CameraPermissionViewModel()
        controller.viewModel?.coordinatorDelegate = self

        router.navigationController.navigationBar.barStyle = .default
        router.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        router.navigationController.navigationBar.shadowImage = UIImage()
        router.navigationController.navigationBar.isTranslucent = true
        router.navigationController.view.backgroundColor = .clear
        router.navigationController.view.tintColor = .black

        router.setRoot(module: controller, hideBar: false)
    }
}

extension CameraPermissionCoordinator: CameraPermissionViewModelCoordinatorDelegate {
    func close() {
        finish?(false)
    }

    func permissionGranted() {
        finish?(true)
    }
}
