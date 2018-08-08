//
//  GistCommentCreateViewModelCoordinatorDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistCommentCreateViewModelCoordinatorDelegate: class {
    func close()
    func didCreate()
    func didUnauthenticate()
}
