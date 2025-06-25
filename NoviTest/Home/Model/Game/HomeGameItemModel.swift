//
//  HomeGameItemModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Foundation

struct HomeGameItemModel: Hashable {

    // MARK: Properties
    let competitor1: String
    let competitor2: String
    var timeInterval: TimeInterval

    var time: String {
        Self.createTimeString(from: timeInterval)
    }

    // MARK: Custom Methods
    func createIncrementedVersion() -> Self {
        .init(competitor1: self.competitor1, competitor2: self.competitor2, timeInterval: self.timeInterval + 1)
    }

    // MARK: Private Custom Methods
    static private func createTimeString(from timeInterval: TimeInterval) -> String {
        var dateComponents = Calendar.current.dateComponents(in: .current, from: Date())
        dateComponents.hour = 0
        dateComponents.second = 0
        dateComponents.minute = 0
        dateComponents.nanosecond = 0

        var date = Calendar.current.date(from: dateComponents)
        date = date?.addingTimeInterval(timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        return dateFormatter.string(from: date ?? Date())
    }
}

// MARK: Extension Initializers
extension HomeGameItemModel {

    init(fromDTO dto: HomeGameModel.Event) {
        self.competitor1 = dto.additionalCaptions.competitor1
        self.competitor2 = dto.additionalCaptions.competitor2
        self.timeInterval = dto.liveData.elapsedSeconds
    }
}
