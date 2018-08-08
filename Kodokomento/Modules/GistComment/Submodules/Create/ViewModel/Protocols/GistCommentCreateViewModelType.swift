//
//  GistCommentCreateViewModelType.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistCommentCreateViewModelType {
    var viewDelegate: GistCommentCreateViewModelViewDelegate? { get set }
    var coordinatorDelegate: GistCommentCreateViewModelCoordinatorDelegate? { get set }

    func viewDidLoad()
    func didPostButtonTouched()
    func didChange(message: String?)
}
