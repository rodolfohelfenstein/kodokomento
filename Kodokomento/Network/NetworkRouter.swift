//
//  NetworkRouter.swift
//  Kodokomento
//
//  Created by Rodolfo Helfenstein Bulgam on 01/08/18.
//  Copyright © 2018 Helfens Studios. All rights reserved.
//

import Foundation

enum NetworkRouter {
    // MARK: Authentication

    case fetchPermission()
    case fetchAuthentication(code: String)

    // MARK: Gist

    case fetchGist(gistId: String)

    // MARK: Gist Comment

    case fetchGistComments(gistId: String)
    case postGistComment(gistId: String, message: String)
}

extension NetworkRouter {
    var baseUrl: URL {
        switch self {
        case .fetchPermission,
             .fetchAuthentication:
            return URL(string: "https://github.com")!

        case .fetchGist,
             .fetchGistComments,
             .postGistComment:
            return URL(string: "https://api.github.com")!
        }
    }

    var path: String {
        switch self {
        case .fetchPermission:
            return "/login/oauth/authorize"

        case .fetchAuthentication:
            return "/login/oauth/access_token"

        case let .fetchGist(gistId):
            return "/gists/\(gistId)"

        case let .fetchGistComments(gistId):
            return "/gists/\(gistId)/comments"

        case let .postGistComment(values):
            return "/gists/\(values.gistId)/comments"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchPermission,
             .fetchGist,
             .fetchGistComments:
            return .get

        case .fetchAuthentication,
             .postGistComment:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchPermission:
            return ["client_id": AccessControlManager.accessControl.gitHubApiAccess.clientId,
                    "redirect_uri": AccessControlManager.accessControl.gitHubApiAccess.redirectUri,
                    "scope": "gist",
                    "state": "SP",
                    "allow_signup": "true"]

        case let .fetchAuthentication(code):
            return ["client_id": AccessControlManager.accessControl.gitHubApiAccess.clientId,
                    "client_secret": AccessControlManager.accessControl.gitHubApiAccess.clientSecret,
                    "code": code,
                    "redirect_uri": AccessControlManager.accessControl.gitHubApiAccess.redirectUri,
                    "state": "SP"]

        default:
            return nil
        }
    }

    var body: Body? {
        switch self {
        case let .postGistComment(values):
            return ["body": values.message]

        default:
            return nil
        }
    }

    var cachePolicy: NSURLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }

    var timeout: TimeInterval { return 20.0 }

    var header: Header { return ["Content-Type": "application/json", "Accept": "application/json"] }

    func request() -> URLRequest {
        guard
            let endpointUrl = URL(string: path, relativeTo: baseUrl),
            let endpointComponents = NSURLComponents(url: endpointUrl, resolvingAgainstBaseURL: true, parameters: parameters),
            let endpoint = endpointComponents.url else {
            fatalError("Incorrect Route Creation.\nCheck value 'Endpoint' on PList or router")
        }

        var request = URLRequest(url: endpoint)
        request.timeoutInterval = timeout
        request.httpMethod = method.rawValue

        request.cachePolicy = cachePolicy

        header.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        if !LocalStorageHelper.accessToken.isEmpty {
            request.addValue("token \(LocalStorageHelper.accessToken)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }

        return request
    }
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

public typealias Header = [String: String]
public typealias Parameters = [String: Any]
public typealias Body = [String: Any]
