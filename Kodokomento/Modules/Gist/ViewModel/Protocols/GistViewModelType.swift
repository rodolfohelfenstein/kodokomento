//
//  GistViewModelType.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistViewModelType {
    var viewDelegate: GistViewModelViewDelegate? { get set }
    var coordinatorDelegate: GistViewModelCoordinatorDelegate? { get set }

    func viewWillAppear()
    func didScannerButtonTouched()
    func didUnauthorizeButtonTouched()
    func didUnautohrizeAlertButtonTouched()

}
