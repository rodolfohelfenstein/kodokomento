//
//  GistFile.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 08/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

enum FileType: Codable {
    case file(GistFile)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .file(container.decode(GistFile.self))
        } catch DecodingError.typeMismatch {
            throw DecodingError.typeMismatch(FileType.self,
                                             DecodingError.Context(codingPath: decoder.codingPath,
                                                                   debugDescription: "Encoded payload not of an expected type"))
        }
    }

    func encode(to _: Encoder) throws {}
}

struct GistFile {
    let filename: String
    let type: String
    let language: String
    let rawUrl: URL
}

extension GistFile: Decodable {
    enum GistFileKeys: String, CodingKey {
        case filename
        case type
        case language
        case rawUrl = "raw_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GistFileKeys.self)

        let filename = try container.decode(String.self, forKey: .filename)
        let type = try container.decode(String.self, forKey: .type)
        let language = try container.decode(String.self, forKey: .language)
        let rawUrl = try container.decode(URL.self, forKey: .rawUrl)

        self.init(filename: filename,
                  type: type,
                  language: language,
                  rawUrl: rawUrl)
    }
}
