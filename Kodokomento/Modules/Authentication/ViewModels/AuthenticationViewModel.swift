//
//  AuthenticationViewModel.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class AuthenticationViewModel {
    // MARK: Delegates

    weak var viewDelegate: AuthenticationViewModelViewDelegate?

    weak var coordinatorDelegate: AuthenticationViewModelCoordinatorDelegate?

    // MARK: Properties

    fileprivate let _network: NetworkManagerType

    fileprivate var _permissionCode: String? {
        didSet {
            fetchAuthentication()
        }
    }

    // MARK: Initializer

    init(network: NetworkManagerType) {
        _network = network
    }

    // MARK: Services

    func fetchPermission() {
        guard let url = NetworkRouter.fetchPermission().request().url else { return }

        coordinatorDelegate?.showSafariView(url: url)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(permissionResponse(notification:)),
                                               name: .didPermissionSuccess,
                                               object: nil)
    }

    func fetchAuthentication() {
        guard let permissionCode = _permissionCode else { return }

        let router: NetworkRouter = .fetchAuthentication(code: permissionCode)

        let result: NetworkResult<Credential> = { [weak self] response in

            switch response {
            case let .success(credential):
                self?.coordinatorDelegate?.authenticated(credential: credential)
            case .failure:
                break
            }
        }

        _network.call(router: router,
                      result: result)
    }

    // MARK: Notifications

    @objc func permissionResponse(notification: NSNotification) {
        if let code = notification.userInfo?["code"] as? String {
            _permissionCode = code
        }
    }
}

extension AuthenticationViewModel: AuthenticationViewModelType {
    func viewWillAppear() {
        viewDelegate?.setLoading(hidden: true)
    }

    func didAuthenticationButtonTouched() {
        fetchPermission()
    }

    func didCloseButtonTouched() {
        coordinatorDelegate?.close()
    }

    func didSafariFinish() {
        coordinatorDelegate?.closeSafariView()
    }
}
