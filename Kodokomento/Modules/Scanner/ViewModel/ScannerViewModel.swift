//
//  ScannerViewModel.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class ScannerViewModel {
    // MARK: Delegates

    weak var viewDelegate: ScannerViewModelViewDelegate?

    weak var coordinatorDelegate: ScannerViewModelCoordinatorDelegate?

    // MARK: Properties

    fileprivate let _network: NetworkManagerType

    fileprivate var _qrcode: String?

    // MARK: Initializer

    init(network: NetworkManagerType) {
        _network = network
    }
}

extension ScannerViewModel: ScannerViewModelType {
    func viewDidLayoutSubviews() {
        viewDelegate?.setConfirmation(hidden: true)
        viewDelegate?.setCameraScan(running: true)
        viewDelegate?.setLoading(hidden: true)
    }

    func didCameraScan(value: String) {
        _qrcode = value

        viewDelegate?.setCameraScan(running: false)
        viewDelegate?.setConfirmation(hidden: false)
    }

    func didConfirmButtonTouched() {
        guard let qrcode = _qrcode else { return }

        coordinatorDelegate?.retrieve(qrcode: qrcode)
    }

    func didCancelButtonTouched() {
        _qrcode = nil

        viewDelegate?.setCameraScan(running: true)
        viewDelegate?.setConfirmation(hidden: true)
    }

    func didCloseButtonTouched() {
        coordinatorDelegate?.close()
    }
}
