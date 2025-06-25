//
//  HomeViewModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Combine
import Foundation

class HomeViewModel {

    // MARK: Initializer
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }


    // MARK: Properties
    @Published private(set) var state: State = .initial
    private let networkManager: NetworkManager
    private var sections: [HomeSectionModel] = []
    private var gameTimer: Timer?
    private var runCount = 0

    // MARK: Custom Methods
    func fetchInformation(updated: Bool = false) {
        state = .isLoading(true)
        Task {
            do {
                async let headLineItems = fetchHeadLineItems(updated: updated)
                async let gameItems = fetchGameItems(updated: updated)

                sections = await [
                    .init(type: .headLine, headLineItems: try headLineItems),
                    .init(type: .game, gameItems: try gameItems)
                ]

                if !updated {
                    startGameUpdateTimer()
                }

                await MainActor.run {

                    self.state = .isLoading(false)
                    self.state = .updateTableView(with: sections)
                }

            } catch let error {
                // Proper error handling should be implemented
                print(error)
                await MainActor.run {
                    self.state = .isLoading(false)
                }
            }
        }
    }

    func endGameUpdateTimer() {
        gameTimer?.invalidate()
    }

    // MARK: Private Custom Methods
    private func fetchHeadLineItems(updated: Bool) async throws -> [HomeHeadLineItemModel] {
        let headLinesEndpoint: Endpoint = if updated { UpdatedHeadLinesEndpoint() } else { HeadLinesEndpoint() }
        let headLinesModel: [HomeHeadLineModel] = try await networkManager.performRequest(for: headLinesEndpoint)

        let headLineItems = headLinesModel.flatMap { headLine in
            headLine.betViews.map { HomeHeadLineItemModel(fromDTO: $0) }
        }

        return headLineItems
    }

    private func fetchGameItems(updated: Bool) async throws -> [HomeGameItemModel] {
        let gamesEndpoint: Endpoint = if updated { UpdatedGamesEndpoint() } else { GamesEndpoint() }
        let gamesModel: [HomeGameModel] = try await networkManager.performRequest(for: gamesEndpoint)

        let gameItems = gamesModel.flatMap { game in
            game.betViews.flatMap { betView in
                betView.competitions.flatMap { competition in
                    competition.events.map { HomeGameItemModel(fromDTO: $0)
                    }
                }
            }
        }

        return gameItems
    }

    private func startGameUpdateTimer() {
        gameTimer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            runCount += 1
            if runCount % 5 == 0 {
                self.state = .scrollCollectionView
            }

            if runCount == 10 {
                runCount = 0
                self.fetchInformation(updated: true)
            } else {
                self.updateTime()
            }
        }

        guard let gameTimer else  { return }
        RunLoop.main.add(gameTimer, forMode: RunLoop.Mode.default)
    }

    private func updateTime() {
        guard let gameSection = sections.first(where: { $0.type == .game }) else { return }
        let newItems = gameSection.gameItems.map { $0.createIncrementedVersion() }

        gameSection.gameItems = newItems

        state = .updateTableViewSection(with: gameSection)
    }
}

// MARK: State Enum
extension HomeViewModel {

    enum State {
        case initial
        case isLoading(Bool)
        case scrollCollectionView
        case updateTableView(with: [HomeSectionModel])
        case updateTableViewSection(with: HomeSectionModel)
    }
}
