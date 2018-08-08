//
//  ScannerViewController.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {
    // MARK: ViewModel

    var viewModel: ScannerViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: Properties

    var cameraScanHelper: CameraScanHelper?

    // MARK: Outlets

    @IBOutlet var previewView: UIView!
    @IBOutlet var confirmationView: UIView!
    @IBOutlet var loadingView: UIView!

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationItem()

        setupConfirmationView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupCameraScan()

        viewModel?.viewDidLayoutSubviews()
    }

    // MARK: Layouts

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    func setupCameraScan() {
        cameraScanHelper = CameraScanHelper(preview: previewView, delegate: self)
    }

    func setupConfirmationView() {
        confirmationView.layer.cornerRadius = 4.0
    }

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(closeButtonTouched(_:)))
    }

    // MARK: Actions

    @IBAction func closeButtonTouched(_: Any) {
        viewModel?.didCloseButtonTouched()
    }

    @IBAction func confirmButtonTouched(_: Any) {
        viewModel?.didConfirmButtonTouched()
    }

    @IBAction func cancelButtonTouched(_: Any) {
        viewModel?.didCancelButtonTouched()
    }
}

extension ScannerViewController: ScannerViewModelViewDelegate {
    func setLoading(hidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.isHidden = hidden
        }
    }

    func setConfirmation(hidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.confirmationView.isHidden = hidden
        }
    }

    func setCameraScan(running: Bool) {
        DispatchQueue.main.async { [weak self] in
            running
                ? self?.cameraScanHelper?.startScan()
                : self?.cameraScanHelper?.stopScan()
        }
    }
}

extension ScannerViewController: CameraScanHelperDelegate {
    func didCameraScan(qrcode: QRCode?) {
        if let qrcode = qrcode {
            viewModel?.didCameraScan(value: qrcode.value)
        }
    }
}
