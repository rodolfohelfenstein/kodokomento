//
//  GistCommentViewModel.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 06/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

class GistCommentViewModel {
    // MARK: Delegates

    weak var viewDelegate: GistCommentViewModelViewDelegate?

    weak var coordinatorDelegate: GistCommentViewModelCoordinatorDelegate?

    // MARK: Properties

    fileprivate let _network: NetworkManagerType

    fileprivate let _gistId: String

    fileprivate var _gistComments: [GistComment] {
        didSet {
            viewDelegate?.reloadData()
        }
    }

    // MARK: Initializer

    init(network: NetworkManagerType,
         gistId: String) {
        _network = network
        _gistId = gistId
        _gistComments = []
    }

    // MARK: View Properties

    var commentsCount: Int {
        return _gistComments.count
    }

    // MARK: Services

    func fetchGistComments() {
        viewDelegate?.setLoading(hidden: false)

        let router: NetworkRouter = .fetchGistComments(gistId: _gistId)

        let result: NetworkResult<[GistComment]> = { [weak self] response in

            self?.viewDelegate?.setLoading(hidden: true)

            switch response {
            case let .success(gistComments):
                self?._gistComments = gistComments.reversed()
            case .failure:
                break
            }
        }

        _network.call(router: router,
                      result: result)
    }
}

extension GistCommentViewModel: GistCommentViewModelType {
    func viewDidLoad() {
        fetchGistComments()
    }

    func didCreateCommentButtonTouched() {
        coordinatorDelegate?.commentCreated()
    }

    func didCloseButtonTouched() {
        coordinatorDelegate?.close()
    }

    func commentForIndex(index: Int) -> GistComment {
        return _gistComments[index]
    }
}
