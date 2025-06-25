//
//  URLMethod.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

enum URLMethod: Equatable {

    case custom(String)
    case delete
    case get
    case patch
    case post
    case put

    var rawValue: String {
        switch self {
        case let .custom(value): value.uppercased(with: .current)
        case .delete: "DELETE"
        case .get: "GET"
        case .patch: "PATCH"
        case .post: "POST"
        case .put: "PUT"
        }
    }
}
