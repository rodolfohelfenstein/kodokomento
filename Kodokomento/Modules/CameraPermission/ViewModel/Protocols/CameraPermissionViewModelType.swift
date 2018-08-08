//
//  CameraPermissionViewModelType.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol CameraPermissionViewModelType {
    var viewDelegate: CameraPermissionViewModelViewDelegate? { get set }
    var coordinatorDelegate: CameraPermissionViewModelCoordinatorDelegate? { get set }

    func viewWillAppear()
    func didGrantPermissionButtonTouched()
    func didCloseButtonTouched()
}
