//
//  GistCommentCreateViewModelViewDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol GistCommentCreateViewModelViewDelegate: class {
    func setPostButton(hidden: Bool)
    func setLoading(hidden: Bool)
}
