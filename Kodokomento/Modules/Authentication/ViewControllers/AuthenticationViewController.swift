//
//  AuthenticationViewController.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import SafariServices
import UIKit

class AuthenticationViewController: UIViewController {
    // MARK: ViewModel

    var viewModel: AuthenticationViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: Outlets

    @IBOutlet var loadingView: UIView!

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationItem()

        viewModel?.viewWillAppear()
    }

    // MARK: Layouts

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(closeButtonTouched(_:)))
    }

    // MARK: Actions

    @IBAction func closeButtonTouched(_: Any) {
        viewModel?.didCloseButtonTouched()
    }

    @IBAction func authenticationButtonTouched(_: Any) {
        viewModel?.didAuthenticationButtonTouched()
    }
}

// MARK: View Delegate

extension AuthenticationViewController: AuthenticationViewModelViewDelegate {
    func setLoading(hidden: Bool) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = hidden
            self.view.isUserInteractionEnabled = hidden
        }
    }
}

// MARK: Safari View Controller Delegate

extension AuthenticationViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_: SFSafariViewController) {
        viewModel?.didSafariFinish()
    }
}
