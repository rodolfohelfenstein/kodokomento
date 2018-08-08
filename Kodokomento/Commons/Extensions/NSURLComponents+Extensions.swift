//
//  NSURLComponents+Extensions.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 31/07/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

extension NSURLComponents {
    convenience init?(url: URL, resolvingAgainstBaseURL: Bool, parameters: Parameters?) {
        self.init(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL)

        queryItems = parameters?.map({ param -> URLQueryItem in
            URLQueryItem(name: param.key, value: "\(param.value)")
        })
    }
}
