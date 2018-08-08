//
//  CameraPermissionViewController.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class CameraPermissionViewController: UIViewController {
    // MARK: ViewModel

    var viewModel: CameraPermissionViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: Properties

    var cameraScanHelper: CameraScanHelper?

    // MARK: Outlets

    @IBOutlet var body: UILabel!
    @IBOutlet var button: UIButton!
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

    @IBAction func grantPermissionButtonTouched(_: Any) {
        viewModel?.didGrantPermissionButtonTouched()
    }
}

extension CameraPermissionViewController: CameraPermissionViewModelViewDelegate {
    func setLoading(hidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.isHidden = hidden
        }
    }

    func setBody(text: String) {
        body.text = text
    }

    func setButton(text: String) {
        button.setTitle(text, for: .normal)
    }
}
