//
//  GistCommentCreateViewController.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 06/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import SwiftIcons
import UIKit

class GistCommentCreateViewController: UIViewController {
    // MARK: ViewModel

    var viewModel: GistCommentCreateViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: Outlets

    @IBOutlet var loadingView: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardObservers()
        addKeyboardCloseOnTap()

        setupNavigationItem()

        setupTextView()

        viewModel?.viewDidLoad()

        textView.becomeFirstResponder()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObservers()
        removeKeyboardCloseOnTap()
    }

    // MARK: Layouts

    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(postButtonTouched(_:)))
    }

    func setupTextView() {
        let contentInset = UIEdgeInsets(top: 12.0,
                                        left: 12.0,
                                        bottom: 12.0,
                                        right: 12.0)

        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = contentInset
    }

    // MARK: Actions

    @IBAction func postButtonTouched(_: Any) {
        dismissKeyboard()
        viewModel?.didPostButtonTouched()
    }
}

extension GistCommentCreateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel?.didChange(message: textView.text)
    }
}

extension GistCommentCreateViewController: KeyboardProtocol {
    func keyboardWillShow(keyboardHeight: Float, animationDuration: Float, animationCurve: Int) {
        let contentInset = UIEdgeInsets(top: 12.0,
                                        left: 12.0,
                                        bottom: CGFloat(keyboardHeight + 12.0),
                                        right: 12.0)

        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = contentInset

        UIView.animate(withDuration: TimeInterval(animationDuration),
                       delay: 0.0,
                       options: UIViewAnimationOptions(rawValue: UInt(animationCurve)),
                       animations: {},
                       completion: nil)
    }

    func keyboardWillHide(keyboardHeight _: Float, animationDuration: Float, animationCurve: Int) {
        let contentInset = UIEdgeInsets(top: 12.0,
                                        left: 12.0,
                                        bottom: 12.0,
                                        right: 12.0)

        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = contentInset

        UIView.animate(withDuration: TimeInterval(animationDuration),
                       delay: 0.0,
                       options: UIViewAnimationOptions(rawValue: UInt(animationCurve)),
                       animations: {},
                       completion: nil)
    }
}

extension GistCommentCreateViewController: GistCommentCreateViewModelViewDelegate {
    func setPostButton(hidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.rightBarButtonItem?.isEnabled = !hidden
            self?.navigationItem.rightBarButtonItem?.tintColor = hidden ? .clear : .black
        }
    }

    func setLoading(hidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.isHidden = hidden
        }
    }
}
