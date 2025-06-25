//
//  HomeViewController.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Combine
import UIKit

class HomeViewController: UIViewController {

    // MARK: Initializers
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Properties
    private let customView = HomeView()
    private let viewModel: HomeViewModel
    private var cancellable: AnyCancellable?
    private var sections: [HomeSectionModel] = []

    // MARK: View Lifecycle
    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancellable()
        setupNavigationButtons()
        setupTableView()
        viewModel.fetchInformation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.endGameUpdateTimer()
    }

    // MARK: Private Custom Methods
    private func setupCancellable() {
        cancellable = viewModel.$state.sink { [weak self] state in self?.handleViewModelState(state) }
    }

    private func setupNavigationButtons() {
        navigationItem.hidesBackButton = true
    }

    private func setupTableView() {
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        customView.tableView.register(GamesCell.self, forCellReuseIdentifier: GamesCell.reuseIdentifier)
        customView.tableView.register(
            CollectionViewTableCell.self,
            forCellReuseIdentifier: CollectionViewTableCell.reuseIdentifier
        )
    }

    private func handleViewModelState(_ state: HomeViewModel.State) {
        switch state {
        case .initial: break
        case let .isLoading(isLoading): customView.isLoading(isLoading)
        case .scrollCollectionView:
            guard let cell = customView.tableView.cellForRow(
                at: .init(row: 0, section: 0)
            ) as? CollectionViewTableCell else { return }
            cell.scrollToNextItem()
        case let .updateTableView(with: sections):
            self.sections = sections
            customView.tableView.reloadData()
        case let .updateTableViewSection(with: section):
            guard let index = sections.firstIndex(where: { $0.type == section.type }) else { return }
            sections[index] = section
            customView.tableView.reloadSections(IndexSet([index]), with: .automatic)
        }
    }
}

// MARK: Extension Data Source
extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section].type {
        case .headLine: 1
        case .game: sections[section].gameItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].type {
        case .headLine:
            let items = sections[indexPath.section].headLineItems
            return dequeueCollectionViewTableCell(tableView, indexPath: indexPath, with: items)
        case .game:
            let item = sections[indexPath.section].gameItems[indexPath.row]
            return dequeueGamesCell(tableView, indexPath: indexPath, with: item)

        }
    }

    func dequeueGamesCell(
        _ tableView: UITableView,
        indexPath: IndexPath,
        with item: HomeGameItemModel
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GamesCell.reuseIdentifier,
            for: indexPath
        ) as? GamesCell else {
            fatalError("Unable to dequeue GamesCell")
        }

        cell.configure(with: item)

        return cell
    }

    func dequeueCollectionViewTableCell(
        _ tableView: UITableView,
        indexPath: IndexPath,
        with items: [HomeHeadLineItemModel]
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewTableCell.reuseIdentifier,
            for: indexPath
        ) as? CollectionViewTableCell else {
            fatalError("Unable to dequeue CollectionViewTableCell")
        }

        cell.configure(with: items)
        
        return cell
    }
}

// MARK: Extension Delegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: 100
        default: UITableView.automaticDimension
        }
    }
}
