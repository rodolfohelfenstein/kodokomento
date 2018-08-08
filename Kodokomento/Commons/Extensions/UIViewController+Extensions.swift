//
//  UIViewController+Extensions.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: Presentable {
    func toPresentable() -> UIViewController {
        return self
    }
}
