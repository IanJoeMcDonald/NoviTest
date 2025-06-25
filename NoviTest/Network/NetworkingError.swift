//
//  NetworkingError.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Foundation

enum NetworkingError: Error {
    case decodingFailed(innerError: DecodingError)
    case encodingFailed(innerError: EncodingError)
    case invalidStatusCode(statusCode: Int)
    case otherError(innerError: Error)
    case requestFailed(innerError: URLError)
    case requiredTokenNotFound
}
