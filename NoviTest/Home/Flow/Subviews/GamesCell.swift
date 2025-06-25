//
//  GamesCell.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import UIKit

class GamesCell: UITableViewCell, ViewCode {

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCode()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Components
    let competitor1Label: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .headline)
        view.textAlignment = .left
        view.numberOfLines = 0
        view.textColor = .label

        return view
    }()

    let elapsedTimeLabel: UILabel = {
        let view = UILabel()
        view.font = .monospacedSystemFont(ofSize: 17, weight: .semibold)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label

        return view
    }()

    let competitor2Label: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .headline)
        view.textAlignment = .right
        view.numberOfLines = 0
        view.textColor = .label

        return view
    }()

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.spacing = Spacing.sm.rawValue

        return view
    }()

    private let dividerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label

        return view
    }()

    // MARK: Properties
    static let reuseIdentifier = "GamesCell"

    // MARK: ViewCode
    func setupViewHierarchy() {
        contentStackView.addArrangedSubview(competitor1Label)
        contentStackView.addArrangedSubview(elapsedTimeLabel)
        contentStackView.addArrangedSubview(competitor2Label)

        contentView.addSubview(contentStackView)
        contentView.addSubview(dividerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.sm.rawValue),
                contentStackView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: Spacing.sm.rawValue
                ),
                contentStackView.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -Spacing.sm.rawValue
                ),

                dividerView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: Spacing.sm.rawValue),
                dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.sm.rawValue),
                dividerView.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -Spacing.sm.rawValue
                ),
                dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                dividerView.heightAnchor.constraint(equalToConstant: Sizes.dividerHeight.rawValue)
            ]
        )
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
        selectionStyle = .none
    }

    // MARK: Custom Methods
    func configure(with model: HomeGameItemModel) {
        competitor1Label.text = model.competitor1
        competitor2Label.text = model.competitor2
        elapsedTimeLabel.text = model.time
    }
}
