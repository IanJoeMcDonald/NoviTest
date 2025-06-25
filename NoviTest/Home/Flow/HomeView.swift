//
//  HomeView.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import UIKit

class HomeView: UIView, ViewCode {

    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        setupViewCode()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Components
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none

        return view
    }()

    // MARK: ViewCode
    func setupViewHierarchy() {
        addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }
}
