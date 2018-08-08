//
//  GistCommentViewModelType.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistCommentViewModelType {
    var viewDelegate: GistCommentViewModelViewDelegate? { get set }
    var coordinatorDelegate: GistCommentViewModelCoordinatorDelegate? { get set }

    var commentsCount: Int { get }
    func commentForIndex(index: Int) -> GistComment

    func viewDidLoad()
    func didCreateCommentButtonTouched()
    func didCloseButtonTouched()
}
