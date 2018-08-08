//
//  GitHubApiAccess.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

struct GitHubApiAccess {
    let clientId: String
    let clientSecret: String
    let redirectUri: String
}

extension GitHubApiAccess: Decodable {
    enum GitHubApiAccessKeys: String, CodingKey {
        case clientId
        case clientSecret
        case redirectUri
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GitHubApiAccessKeys.self)

        let clientId = try container.decode(String.self, forKey: .clientId)
        let clientSecret = try container.decode(String.self, forKey: .clientSecret)
        let redirectUri = try container.decode(String.self, forKey: .redirectUri)

        self.init(clientId: clientId,
                  clientSecret: clientSecret,
                  redirectUri: redirectUri)
    }
}
