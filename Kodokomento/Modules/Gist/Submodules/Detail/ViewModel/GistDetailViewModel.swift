//
//  GistDetailViewModel.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class GistDetailViewModel {
    // MARK: Delegates

    weak var viewDelegate: GistDetailViewModelViewDelegate?

    weak var coordinatorDelegate: GistDetailViewModelCoordinatorDelegate?

    // MARK: Properties

    fileprivate let _network: NetworkManagerType

    fileprivate let _gistId: String

    fileprivate var _gist: Gist? {
        didSet {
            viewDelegate?.reloadFields()
            viewDelegate?.setLoading(hidden: true)
        }
    }

    // MARK: Initializer

    init(network: NetworkManagerType,
         gistId: String) {
        _network = network
        _gistId = gistId
    }

    // MARK: Services

    func fetchGist() {
        viewDelegate?.setLoading(hidden: false)

        let router: NetworkRouter = .fetchGist(gistId: _gistId)

        let result: NetworkResult<Gist> = { [weak self] response in

            switch response {
            case let .success(gist):
                self?._gist = gist
            case .failure:
                self?.viewDelegate?.showAlert(title: R.string.kodokomento.gistNotFoundAlertTitle(),
                                              body: R.string.kodokomento.gistNotFoundAlertBody(),
                                              action: R.string.kodokomento.gistNotFoundAlertAction())
            }
        }

        _network.call(router: router,
                      result: result)
    }

    // MARK: View Properties

    var ownerAvatar: URL? {
        guard let gist = _gist else { return nil }

        return gist.owner.avatar
    }

    var ownerIdentifier: NSAttributedString? {
        guard let gist = _gist, let gistFile = gist.gistFile else { return nil }

        let text = "\(gist.owner.login) / \(gistFile.filename)"
        let attributedString = NSMutableAttributedString(string: text)

        text.enumerateSubstrings(in: text.startIndex ..< text.endIndex, options: .byWords) { substring, substringRange, _, _ in

            if substring == "/" {
                attributedString.addAttribute(.foregroundColor,
                                              value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                              range: NSRange(substringRange,
                                                             in: text))
            }

            if substring == gistFile.filename {
                attributedString.addAttribute(.font,
                                              value: UIFont.systemFont(ofSize: 16.0,
                                                                       weight: .bold),
                                              range: NSRange(substringRange,
                                                             in: text))
            }
        }

        return attributedString
    }

    var gistCreationDate: String? {
        guard let gist = _gist else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"

        return "Created in \(formatter.string(from: gist.createdAt))"
    }

    var gistFilename: String? {
        guard let gist = _gist, let gistFile = gist.gistFile else { return nil }

        return gistFile.filename
    }

    var gistBody: URL? {
        guard let gist = _gist, let gistFile = gist.gistFile else { return nil }

        return gistFile.rawUrl
    }

    var commentsCount: String? {
        return "COMMENTS (\(_gist?.commentsCount ?? 0))"
    }
}

extension GistDetailViewModel: GistDetailViewModelType {
    func viewDidLoad() {
        fetchGist()
    }

    func didAlertButtonTouched() {
        coordinatorDelegate?.gistNotFound()
    }

    func didCommentButtonTouched() {
        coordinatorDelegate?.showComments(gistId: _gistId)
    }

    func didCloseButtonTouched() {
        coordinatorDelegate?.close()
    }
}
