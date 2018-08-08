//
//  User.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 01/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let login: String
    let avatar: URL
}

extension User: Decodable {
    enum UserKeys: String, CodingKey {
        case id
        case login
        case avatar = "avatar_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)

        let id = try container.decode(Int.self, forKey: .id)
        let login = try container.decode(String.self, forKey: .login)
        let avatar = try container.decode(URL.self, forKey: .avatar)

        self.init(id: id,
                  login: login,
                  avatar: avatar)
    }
}
