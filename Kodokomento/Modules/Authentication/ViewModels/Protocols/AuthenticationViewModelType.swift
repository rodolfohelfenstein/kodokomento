//
//  AuthenticationViewModelType.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol AuthenticationViewModelType {
    var viewDelegate: AuthenticationViewModelViewDelegate? { get set }
    var coordinatorDelegate: AuthenticationViewModelCoordinatorDelegate? { get set }

    func viewWillAppear()
    func didAuthenticationButtonTouched()
    func didCloseButtonTouched()
    func didSafariFinish()
}
