//
//  GistDetailViewModelViewDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistDetailViewModelViewDelegate: class {
    func reloadFields()
    func setLoading(hidden: Bool)
    func showAlert(title: String, body: String, action: String)
}
