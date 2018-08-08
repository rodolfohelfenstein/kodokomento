//
//  KeyboardProtocol.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

var KeyboardShowObserverObjectKey: UInt8 = 1
var KeyboardHideObserverObjectKey: UInt8 = 2

protocol KeyboardProtocol: class {
    func addKeyboardObservers()
    func removeKeyboardObservers()
    func keyboardWillShow(keyboardHeight: Float, animationDuration: Float, animationCurve: Int)
    func keyboardWillHide(keyboardHeight: Float, animationDuration: Float, animationCurve: Int)
}

extension KeyboardProtocol where Self: UIViewController {
    private var keyboardCloseTap: UITapGestureRecognizer {
        let keyboardCloseTap = UITapGestureRecognizer(target: self,
                                                      action: #selector(UIViewController.dismissKeyboard))
        keyboardCloseTap.cancelsTouchesInView = false
        return keyboardCloseTap
    }

    private var keyboardWillShow: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &KeyboardShowObserverObjectKey) as? NSObjectProtocol
        }

        set {
            objc_setAssociatedObject(self, &KeyboardShowObserverObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var keyboardWillHide: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &KeyboardHideObserverObjectKey) as? NSObjectProtocol
        }

        set {
            objc_setAssociatedObject(self, &KeyboardHideObserverObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addKeyboardObservers() {
        keyboardWillShow =
            Foundation
            .NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name.UIKeyboardWillShow,
                         object: nil,
                         queue: OperationQueue.main,
                         using: { [weak self] notification in

                             guard
                                 let keyboardHeight = self?.getKeyboardHeight(notification: notification),
                                 let animationDuration = self?.getAnimationDuration(notification: notification),
                                 let animationCurve = self?.getAnimationCurve(notification: notification) else { return }

                             self?.keyboardWillShow(keyboardHeight: keyboardHeight,
                                                    animationDuration: animationDuration,
                                                    animationCurve: animationCurve)

            })

        keyboardWillHide =
            Foundation
            .NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name.UIKeyboardDidHide,
                         object: nil,
                         queue: OperationQueue.main,
                         using: { [weak self] notification in

                             guard
                                 let keyboardHeight = self?.getKeyboardHeight(notification: notification),
                                 let animationDuration = self?.getAnimationDuration(notification: notification),
                                 let animationCurve = self?.getAnimationCurve(notification: notification) else { return }

                             self?.keyboardWillHide(keyboardHeight: keyboardHeight,
                                                    animationDuration: animationDuration,
                                                    animationCurve: animationCurve)

            })
    }

    func removeKeyboardObservers() {
        if let keyboardWillShow = keyboardWillShow {
            Foundation.NotificationCenter.default.removeObserver(keyboardWillShow)
        }

        if let keyboardWillHide = keyboardWillHide {
            Foundation.NotificationCenter.default.removeObserver(keyboardWillHide)
        }

        keyboardWillShow = nil
        keyboardWillHide = nil
    }

    func addKeyboardCloseOnTap() {
        view.addGestureRecognizer(keyboardCloseTap)
    }

    func removeKeyboardCloseOnTap() {
        view.removeGestureRecognizer(keyboardCloseTap)
    }

    private func getKeyboardHeight(notification: Notification) -> Float {
        guard
            let info = notification.userInfo,
            let rectValue = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return 0.0
        }

        let value = view.convert(rectValue, from: nil)

        return Float(value.height)
    }

    private func getAnimationDuration(notification: Notification) -> Float {
        guard
            let info = notification.userInfo,
            let keyboardAnimationDuration = info[UIKeyboardAnimationDurationUserInfoKey] as? Float else {
            return 0.0
        }

        return keyboardAnimationDuration
    }

    private func getAnimationCurve(notification: Notification) -> Int {
        guard
            let info = notification.userInfo,
            let keyboardAnimationCurve = info[UIKeyboardAnimationCurveUserInfoKey] as? Int else {
            return 0
        }

        return keyboardAnimationCurve
    }
}
