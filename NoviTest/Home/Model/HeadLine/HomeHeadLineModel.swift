//
//  HomeHeadLineModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

struct HomeHeadLineModel: Decodable {

    var betViews: [BetView]
}

// MARK: Extension SubModels
extension HomeHeadLineModel {

    struct BetView: Decodable {
        let competitor1: String
        let competitor2: String
        let time: String

        enum CodingKeys: String, CodingKey {
            case competitor1 = "competitor1Caption"
            case competitor2 = "competitor2Caption"
            case time = "startTime"
        }
    }
}
