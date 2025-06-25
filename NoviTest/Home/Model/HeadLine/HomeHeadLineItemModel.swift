//
//  HomeHeadLineItemModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

struct HomeHeadLineItemModel: Hashable {

    let competitor1: String
    let competitor2: String
    let time: String
}

// MARK: Extension Initiailizers
extension HomeHeadLineItemModel {

    init(fromDTO dto: HomeHeadLineModel.BetView) {
        self.competitor1 = dto.competitor1
        self.competitor2 = dto.competitor2
        self.time = dto.time
    }
}
