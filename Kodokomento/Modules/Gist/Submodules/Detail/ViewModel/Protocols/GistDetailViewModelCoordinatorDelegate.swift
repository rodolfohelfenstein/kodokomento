//
//  GistDetailViewModelCoordinatorDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistDetailViewModelCoordinatorDelegate: class {
    func close()
    func showComments(gistId: String)
    func gistNotFound()

}
