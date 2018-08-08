//
//  ScannerViewModelCoordinatorDelegate.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

protocol ScannerViewModelCoordinatorDelegate: class {
    func close()
    func retrieve(qrcode: String)
}
