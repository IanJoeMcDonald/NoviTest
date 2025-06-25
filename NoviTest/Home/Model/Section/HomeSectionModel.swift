//
//  HomeSectionModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

class HomeSectionModel {

    // MARK: Initializers
    init(type: HomeSectionType, gameItems: [HomeGameItemModel] = [], headLineItems: [HomeHeadLineItemModel] = []) {
        self.type = type
        self.gameItems = gameItems
        self.headLineItems = headLineItems
    }

    // MARK: Properties
    let type: HomeSectionType
    var gameItems: [HomeGameItemModel]
    var headLineItems: [HomeHeadLineItemModel]
}
