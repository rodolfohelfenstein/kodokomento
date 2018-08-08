//
//  GistCommentViewController.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 06/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

class GistCommentViewController: UIViewController {
    // MARK: ViewModel

    var viewModel: GistCommentViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: Outlets

    @IBOutlet var loadingView: UIView!
    @IBOutlet var tableView: UITableView!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        viewModel?.viewDidLoad()
    }

    // MARK: Layouts

    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(closeButtonTouched(_:)))

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(createCommentButtonTouched(_:)))
    }

    // MARK: Actions

    @IBAction func closeButtonTouched(_: Any) {
        viewModel?.didCloseButtonTouched()
    }

    @IBAction func createCommentButtonTouched(_: Any) {
        viewModel?.didCreateCommentButtonTouched()
    }
}

extension GistCommentViewController: GistCommentViewModelViewDelegate {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func setLoading(hidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.isHidden = hidden
        }
    }
}

extension GistCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel?.commentsCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.gistCommentCell, for: indexPath),
            let gistComment = viewModel?.commentForIndex(index: indexPath.row) {
            cell.setItem(gistComment: gistComment)

            return cell
        }

        return UITableViewCell()
    }
}
