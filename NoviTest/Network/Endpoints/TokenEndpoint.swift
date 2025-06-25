//
//  TokenEndpoint.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

struct TokenEndpoint: Endpoint {

    // MARK: Initializers
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    // MARK: Variables
    let username: String
    let password: String

    // MARK: Endpoint Properties
    var path: String = "/token"
    var method: URLMethod = .get
    var requiresToken: Bool = false
    var queryItems: [String : String] { createQueryParameters() }

    // MARK: Private Custom Methods
    private func createQueryParameters() -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["username"] = username
        parameters["password"] = password
        return parameters
    }
}
