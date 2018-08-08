//
//  ScannerViewModelViewDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol ScannerViewModelViewDelegate: class {
    func setLoading(hidden: Bool)
    func setConfirmation(hidden: Bool)
    func setCameraScan(running: Bool)
}
