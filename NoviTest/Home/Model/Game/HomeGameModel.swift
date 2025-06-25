//
//  HomeGameModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

struct HomeGameModel: Decodable {

    let betViews: [BetView]
}

// MARK: Extension SubModels
extension HomeGameModel {

    struct BetView: Decodable {
        let competitions: [Competition]
    }

    struct Competition: Decodable {

        let events: [Event]
    }

    struct Event: Decodable {

        let additionalCaptions: AdditionalCaptions
        let liveData: LiveData
    }

    struct AdditionalCaptions: Decodable {

        let competitor1: String
        let competitor2: String
    }

    struct LiveData: Decodable {

        let elapsedSeconds: Double
    }
}
