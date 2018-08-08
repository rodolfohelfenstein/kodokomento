//
//  Gist.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 01/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

struct Gist {
    let id: String
    let owner: User
    let description: String
    let commentsCount: Int
    let file: [String: FileType]
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case description
        case commentsCount = "comments"
        case file = "files"
        case createdAt = "created_at"
    }

    var gistFile: GistFile? {
        if let value = file.first?.value {
            switch value {
            case let .file(file):
                return file
            }
        }

        return nil
    }
}

extension Gist: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        owner = try container.decode(User.self, forKey: .owner)
        description = try container.decode(String.self, forKey: .description)
        commentsCount = try container.decode(Int.self, forKey: .commentsCount)
        file = try container.decode([String: FileType].self, forKey: .file)
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
