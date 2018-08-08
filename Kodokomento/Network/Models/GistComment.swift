//
//  GistComment.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 01/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

struct GistComment {
    let id: Int
    let user: User
    let body: String
    let createdAt: Date

    enum GistCommentKeys: String, CodingKey {
        case id
        case user
        case body
        case createdAt = "created_at"
    }

}

extension GistComment: Decodable {

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: GistCommentKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        user = try container.decode(User.self, forKey: .user)
        body = try container.decode(String.self, forKey: .body)
        let createdAtString = try container.decode(String.self, forKey: .createdAt)

        if let date = DateFormatter.iso8601Full.date(from: createdAtString) {
            createdAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }

    }
}
