//
//  LocalStorageHelper.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class LocalStorageHelper: NSObject {
    enum LocalStorageHelperKeys: String {
        case accessToken
    }

    static var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: LocalStorageHelperKeys.accessToken.rawValue) ?? ""
        }

        set {
            UserDefaults.standard.set(newValue, forKey: LocalStorageHelperKeys.accessToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
