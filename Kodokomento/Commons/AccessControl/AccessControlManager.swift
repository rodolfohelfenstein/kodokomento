//
//  AccessControlManager.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

class AccessControlManager {
    static var accessControl: AccessControl {
        guard
            let fileurl = R.file.accessControlPlist(),
            let filedata = try? Data(contentsOf: fileurl, options: .mappedIfSafe),
            let accessControl = try? PropertyListDecoder().decode(AccessControl.self, from: filedata) else {
            fatalError("'AccessControl.plist' Not Found. Please Read Repository Instructions")
        }

        return accessControl
    }
}
