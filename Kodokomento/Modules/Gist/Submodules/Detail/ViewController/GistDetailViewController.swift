//
//  GistDetailViewController.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit
import Kingfisher
import WebKit

class GistDetailViewController: UIViewController {
    // MARK: ViewModel

    var viewModel: GistDetailViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: Outlets

    @IBOutlet var gistView: UIView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var ownerAvatarImageView: UIImageView!
    @IBOutlet var ownerIdentifierLabel: UILabel!
    @IBOutlet var gistCreationDateLabel: UILabel!
    @IBOutlet var gistFilenameLabel: UILabel!
    @IBOutlet var gistBodyWebView: WKWebView!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGistView()

        setupAvatarImageView()

        viewModel?.viewDidLoad()

    }

    // MARK: Layouts

    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    func setupGistView() {

        gistView.layer.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8941176471, blue: 0.9098039216, alpha: 1)
        gistView.layer.borderWidth = 1.0
        gistView.layer.cornerRadius = 4.0
        gistView.clipsToBounds = true

    }

    func setupAvatarImageView() {

        ownerAvatarImageView.layer.cornerRadius = ownerAvatarImageView.frame.height / 2
        ownerAvatarImageView.clipsToBounds = true

    }

    // MARK: Actions

    @IBAction func closeButtonTouched(_: Any) {
        viewModel?.didCloseButtonTouched()
    }

    @IBAction func commentButtonTouched(_: Any) {
        viewModel?.didCommentButtonTouched()
    }

}

extension GistDetailViewController: GistDetailViewModelViewDelegate {

    func reloadFields() {

        DispatchQueue.main.async { [weak self] in

            if let ownerAvatar = self?.viewModel?.ownerAvatar {
                self?.ownerAvatarImageView.kf.setImage(with: ownerAvatar,
                                                 placeholder: nil,
                                                 options: [.transition(ImageTransition.fade(0.3))],
                                                 progressBlock: nil) { _, _, _, _ in }
            }

            if let ownerIdentifier = self?.viewModel?.ownerIdentifier {
                self?.ownerIdentifierLabel.attributedText = ownerIdentifier
            }

            if let gistCreationDate = self?.viewModel?.gistCreationDate {
                self?.gistCreationDateLabel.text = gistCreationDate
            }

            if let gistFilename = self?.viewModel?.gistFilename {
                self?.gistFilenameLabel.text = gistFilename
            }

            if let gistBody = self?.viewModel?.gistBody {
                self?.gistBodyWebView.load(URLRequest(url: gistBody))
            }

            self?.commentsButton.setTitle(self?.viewModel?.commentsCount, for: .normal)

        }

    }

    func setLoading(hidden: Bool) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = hidden
            self.view.isUserInteractionEnabled = hidden
        }
    }

    func showAlert(title: String, body: String, action: String) {

        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: action, style: .default, handler: { [weak self] _ in
            self?.viewModel?.didAlertButtonTouched()
        }))

        present(alert, animated: true, completion: nil)

    }

}
