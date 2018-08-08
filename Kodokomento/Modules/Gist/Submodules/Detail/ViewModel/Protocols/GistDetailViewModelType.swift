//
//  GistDetailViewModelType.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistDetailViewModelType {
    var viewDelegate: GistDetailViewModelViewDelegate? { get set }
    var coordinatorDelegate: GistDetailViewModelCoordinatorDelegate? { get set }

    func viewDidLoad()
    func fetchGist()
    func didCommentButtonTouched()
    func didCloseButtonTouched()
    func didAlertButtonTouched()

    var ownerAvatar: URL? { get }
    var ownerIdentifier: NSAttributedString? { get }
    var gistCreationDate: String? { get }
    var gistFilename: String? { get }
    var gistBody: URL? { get }
    var commentsCount: String? { get }
}
