//
//  GistCommentCreateViewModel.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 06/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class GistCommentCreateViewModel {
    // MARK: Delegates

    weak var viewDelegate: GistCommentCreateViewModelViewDelegate?

    weak var coordinatorDelegate: GistCommentCreateViewModelCoordinatorDelegate?

    // MARK: Properties

    fileprivate let _network: NetworkManagerType

    fileprivate let _gistId: String

    fileprivate var _message: String? {
        didSet {
            viewDelegate?.setPostButton(hidden: _message?.isEmpty ?? true)
        }
    }

    // MARK: Initializer

    init(network: NetworkManagerType,
         gistId: String) {
        _network = network
        _gistId = gistId
    }

    // MARK: Services

    func postComment() {
        guard let message = _message else { return }

        viewDelegate?.setLoading(hidden: false)

        let router: NetworkRouter = .postGistComment(gistId: _gistId, message: message)

        let result: NetworkResult<GistComment> = { [weak self] response in

            self?.viewDelegate?.setLoading(hidden: true)

            switch response {
            case .success:

                self?.coordinatorDelegate?.didCreate()

            case let .failure(error):

                switch error {
                case .unauthorized:
                    self?.coordinatorDelegate?.didUnauthenticate()
                default:
                    break
                }
            }
        }

        _network.call(router: router,
                      result: result)
    }
}

extension GistCommentCreateViewModel: GistCommentCreateViewModelType {
    func viewDidLoad() {
        viewDelegate?.setPostButton(hidden: true)
        viewDelegate?.setLoading(hidden: true)
    }

    func didPostButtonTouched() {
        postComment()
    }

    func didChange(message: String?) {
        _message = message
    }
}
