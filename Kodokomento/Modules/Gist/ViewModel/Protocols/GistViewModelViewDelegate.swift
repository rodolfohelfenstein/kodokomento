//
//  GistViewModelViewDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistViewModelViewDelegate: class {
    func refreshAuthorizationButton()
    func showUnauthorizeAlert(title: String, body: String, action: String, cancel: String)
}
