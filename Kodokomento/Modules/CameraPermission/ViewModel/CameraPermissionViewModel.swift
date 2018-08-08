//
//  CameraPermissionViewModel.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class CameraPermissionViewModel {
    // MARK: Delegates

    weak var viewDelegate: CameraPermissionViewModelViewDelegate?

    weak var coordinatorDelegate: CameraPermissionViewModelCoordinatorDelegate?
}

extension CameraPermissionViewModel: CameraPermissionViewModelType {
    func viewWillAppear() {
        switch CameraScanHelper.permission() {
        case .denied,
             .restricted:
            viewDelegate?.setBody(text: R.string.kodokomento.cameraPermissionDeniedBody())
            viewDelegate?.setButton(text: R.string.kodokomento.cameraPermissionDeniedButton())
        case .notDetermined:
            viewDelegate?.setBody(text: R.string.kodokomento.cameraPermissionNotDeterminedBody())
            viewDelegate?.setButton(text: R.string.kodokomento.cameraPermissionNotDeterminedButton())
        case .authorized:
            coordinatorDelegate?.permissionGranted()
        }
    }

    func didGrantPermissionButtonTouched() {
        CameraScanHelper.requestPermission()
    }

    func didCloseButtonTouched() {
        coordinatorDelegate?.close()
    }
}
