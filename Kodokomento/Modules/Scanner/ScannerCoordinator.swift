//
//  ScannerCoordinator.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class ScannerCoordinator: Coordinator {
    // MARK: Lifecycle

    override func start() {
        showScanner()
    }

    var finish: ((String?) -> Void)?

    // MARK: Flows

    func showScanner() {
        guard let controller = R.storyboard.scanner.main() else {
            fatalError("ScannerViewController in Scanner.storyboard has not found.")
        }

        controller.viewModel = ScannerViewModel(network: network)
        controller.viewModel?.coordinatorDelegate = self

        router.navigationController.navigationBar.barStyle = .black
        router.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        router.navigationController.navigationBar.shadowImage = UIImage()
        router.navigationController.navigationBar.isTranslucent = true
        router.navigationController.view.backgroundColor = .clear
        router.navigationController.view.tintColor = .white

        router.setRoot(module: controller, hideBar: false)
    }
}

extension ScannerCoordinator: ScannerViewModelCoordinatorDelegate {
    func close() {
        finish?(nil)
    }

    func retrieve(qrcode: String) {
        finish?(qrcode)
    }
}
