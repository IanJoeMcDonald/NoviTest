//
//  NetworkManager.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Foundation

class NetworkManager {

    // MARK: Initializer
    init(basePath: String?) {
        self.basePath = basePath
    }

    // MARK: Properties
    private let basePath: String?
    private var authenticationToken: String?

    // MARK: Custom Methods
    func performRequest<T>(for endpoint: Endpoint) async throws -> T where T : Decodable {
        if endpoint.requiresToken && authenticationToken == nil {
            throw NetworkingError.requiredTokenNotFound
        }
        
        do {
            // Create Request
            var request = try createURLRequest(for: endpoint)

            if endpoint.requiresToken {
                request.setValue(authenticationToken, forHTTPHeaderField: "Authorization")
            }

            // Perform Request
            let (data, response) = try await URLSession.shared.data(for: request)

            // Validate Response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkingError.invalidStatusCode(statusCode: -1)
            }

            guard (200...299).contains(statusCode) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }

            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkingError.decodingFailed(innerError: error)
        } catch let error as EncodingError {
            throw NetworkingError.encodingFailed(innerError: error)
        } catch let error as URLError {
            throw NetworkingError.requestFailed(innerError: error)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw NetworkingError.otherError(innerError: error)
        }
    }

    func updateAuthorizationToken(with token: LoginTokenModel) {
        guard let type = token.tokenType, let accessToken = token.accessToken else {
            return
        }
        
        authenticationToken = "\(type) \(accessToken)"
    }

    // MARK: Private Custom Methods
    private func createURLRequest(for endpoint: Endpoint) throws -> URLRequest {
        let validURL = try endpoint.createURL(basePath: basePath)

        var request = URLRequest(url: validURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
