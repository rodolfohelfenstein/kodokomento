//
//  ScannerViewModelType.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol ScannerViewModelType {
    var viewDelegate: ScannerViewModelViewDelegate? { get set }
    var coordinatorDelegate: ScannerViewModelCoordinatorDelegate? { get set }

    func viewDidLayoutSubviews()
    func didCameraScan(value: String)
    func didConfirmButtonTouched()
    func didCancelButtonTouched()
    func didCloseButtonTouched()
}
