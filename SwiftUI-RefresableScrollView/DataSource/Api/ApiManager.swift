//
//  ApiManager.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import Foundation
import Alamofire

struct AlamofireConfiguration {

    static var session: Session {
        return Session.default
    }
}

public enum RequestIdentifier {
    case defaultApi
    case authenticateApi
}

enum Endpoint {
    case pokemon

    private var baseUrl: URL {
        switch self {
        case .pokemon: return URL(string: "https://pokeapi.co")!
        }
    }

    func api(version: ApiVersion = .v1_0) -> String {
        return baseUrl.absoluteString.appending(version.path)
    }
}

enum ApiVersion {
    case v1_0
    case v2_0
    case custom(version: String)

    var path: String {
        switch self {
        case .v1_0: return "/api/v1"
        case .v2_0: return "/api/v2"
        case .custom(let version): return version
        }
    }
}

class ApiManager {

    // MARK: - Properties
    static let shared = ApiManager()
    private var session: Session

    // MARK: - Init

    init(session: Session = AlamofireConfiguration.session) {
        self.session = session
    }

    // MARK: - Config
    typealias CompletionDataResponse = (AFDataResponse<Any>) -> Void
    @discardableResult
    func apiRequest(
        _ method: HTTPMethod,
        identifier: RequestIdentifier = .defaultApi,
        endpoint: Endpoint = .pokemon,
        apiVersion: ApiVersion = .v1_0,
        path: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: [String: String] = [:],
        timeout: Double = 60
    ) -> DataRequest {
        guard var urlComponents = URLComponents(string: endpoint.api(version: apiVersion) + path) else { fatalError() }
        var headers = [String: String]()
        headers.merge(defaultCookie(with: urlComponents)) { $1 }

        return session.request(
            urlComponents,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: .init(headers)
        ) {
            $0.timeoutInterval = timeout
        }
    }
}

extension ApiManager {
    private func defaultCookie(with urlComponents: URLComponents) -> [String: String] {
        do {
            guard let cookies = HTTPCookieStorage.shared.cookies(for: try urlComponents.asURL()) else { return [:] }
            return HTTPCookie.requestHeaderFields(with: cookies)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

}
