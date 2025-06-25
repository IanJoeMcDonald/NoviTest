//
//  HeadLineCollectionCell.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import UIKit

class HeadLineCell: UICollectionViewCell, ViewCode {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewCode()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Components
    let competitor1Label: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .headline)
        view.numberOfLines = 0
        view.textColor = .label

        return view
    }()

    let competitor2Label: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .headline)
        view.numberOfLines = 0
        view.textColor = .label

        return view
    }()

    let startTimeLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .headline)
        view.textAlignment = .right
        view.numberOfLines = 0
        view.textColor = .label

        return view
    }()

    private let competitorsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = Spacing.sm.rawValue

        return view
    }()

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = Spacing.sm.rawValue
        view.layoutMargins = .init(
            top: Spacing.sm.rawValue,
            left: Spacing.sm.rawValue,
            bottom: Spacing.sm.rawValue,
            right: Spacing.sm.rawValue
        )
        view.isLayoutMarginsRelativeArrangement = true
        view.layer.borderColor = UIColor.systemRed.cgColor
        view.layer.borderWidth = Sizes.borderWidth.rawValue

        return view
    }()

    // MARK: Properties
    static let reuseIdentifier = "HeadLineCell"

    // MARK: ViewCode
    func setupViewHierarchy() {
        competitorsStackView.addArrangedSubview(competitor1Label)
        competitorsStackView.addArrangedSubview(competitor2Label)

        contentStackView.addArrangedSubview(competitorsStackView)
        contentStackView.addArrangedSubview(startTimeLabel)

        contentView.addSubview(contentStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }

    // MARK: Custom Methods
    func configure(with model: HomeHeadLineItemModel) {
        competitor1Label.text = model.competitor1
        competitor2Label.text = model.competitor2
        startTimeLabel.text = model.time
    }
}
