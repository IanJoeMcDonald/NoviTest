//
//  LoginTokenModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Foundation

struct LoginTokenModel: Decodable {

    let accessToken: String?
    let tokenType: String?

    enum CodingKeys: String, CodingKey {

        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
