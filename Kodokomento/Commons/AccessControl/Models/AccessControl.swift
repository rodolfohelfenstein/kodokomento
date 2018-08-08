//
//  AccessControl.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

struct AccessControl {
    let gitHubApiAccess: GitHubApiAccess
}

extension AccessControl: Decodable {
    enum AccessControlKeys: String, CodingKey {
        case gitHubApiAccess = "GitHubApiAccess"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AccessControlKeys.self)

        let gitHubApiAccess = try container.decode(GitHubApiAccess.self, forKey: .gitHubApiAccess)

        self.init(gitHubApiAccess: gitHubApiAccess)
    }
}
