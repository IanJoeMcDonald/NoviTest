//
//  Endpoint.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Foundation

protocol Endpoint {

    var path: String { get }
    var queryItems: [String: String] { get }
    var method: URLMethod { get }
    var headers: [String: String] { get }
    var requiresToken: Bool { get }
    var body: Data? { get }

    func createURL(basePath: String?) throws -> URL
}

extension Endpoint {

    var queryItems: [String: String] { [:] }
    var headers: [String: String] { [:] }
    var body: Data? { nil }
    var requiresToken: Bool { true }

    func createURL(basePath: String? = nil) throws -> URL {
        let fullPath = (basePath ?? "").appending(self.path)
        var urlComponents = URLComponents(string: fullPath)
        if !queryItems.isEmpty {
            urlComponents?.queryItems = self.queryItems.map { key, value in URLQueryItem(name: key, value: value) }
        }
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        return url
    }
}
