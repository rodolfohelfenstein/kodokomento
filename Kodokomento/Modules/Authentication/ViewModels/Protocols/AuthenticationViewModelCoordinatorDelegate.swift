//
//  AuthenticationViewModelCoordinatorDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol AuthenticationViewModelCoordinatorDelegate: class {
    func showSafariView(url: URL)
    func close()
    func closeSafariView()
    func authenticated(credential: Credential)
}
