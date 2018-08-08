//
//  Credential.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 07/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

struct Credential {
    let accessToken: String
    let scope: String
    let tokenType: String
}

extension Credential: Decodable {
    enum CredentialKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CredentialKeys.self)

        let accessToken = try container.decode(String.self, forKey: .accessToken)
        let scope = try container.decode(String.self, forKey: .scope)
        let tokenType = try container.decode(String.self, forKey: .tokenType)

        self.init(accessToken: accessToken,
                  scope: scope,
                  tokenType: tokenType)
    }
}
