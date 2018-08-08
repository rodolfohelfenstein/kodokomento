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

        viewModel?.viewWillAppear()
    }

    // MARK: Layouts

    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    // MARK: Actions

    @IBAction func scannerButtonTouched(_: Any) {
        viewModel?.didScannerButtonTouched()
    }
}

extension GistViewController: GistViewModelViewDelegate { }
