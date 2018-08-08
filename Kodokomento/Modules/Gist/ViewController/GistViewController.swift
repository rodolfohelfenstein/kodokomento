//
//  GistViewController.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class GistViewController: UIViewController {
    // MARK: ViewModel

    var viewModel: GistViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: Outlets

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationItem()

        viewModel?.viewWillAppear()
    }

    // MARK: Layouts

    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    func setupNavigationItem() {
        if !LocalStorageHelper.accessToken.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                target: self,
                                                                action: #selector(unauthorizeButtonTouched(_:)))

        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    // MARK: Actions

    @IBAction func scannerButtonTouched(_: Any) {
        viewModel?.didScannerButtonTouched()
    }

    @IBAction func unauthorizeButtonTouched(_: Any) {
        viewModel?.didUnauthorizeButtonTouched()
    }
}

extension GistViewController: GistViewModelViewDelegate {
    func refreshAuthorizationButton() {
        setupNavigationItem()
    }

    func showUnauthorizeAlert(title: String, body: String, action: String, cancel: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: action, style: .default, handler: { [weak self] _ in
            self?.viewModel?.didUnautohrizeAlertButtonTouched()
        }))

        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
