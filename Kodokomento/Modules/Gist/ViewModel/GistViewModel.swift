//
//  GistViewModel.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class GistViewModel {
    // MARK: Delegates

    weak var viewDelegate: GistViewModelViewDelegate?

    weak var coordinatorDelegate: GistViewModelCoordinatorDelegate?

    // MARK: Properties

    fileprivate let _network: NetworkManagerType

    // MARK: Initializer

    init(network: NetworkManagerType) {
        _network = network
    }
}

extension GistViewModel: GistViewModelType {
    func viewWillAppear() {}

    func didScannerButtonTouched() {
        coordinatorDelegate?.showScanner()
    }
}
