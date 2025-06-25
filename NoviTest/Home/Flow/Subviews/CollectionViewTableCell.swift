//
//  CollectionViewTableCell.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import UIKit

class CollectionViewTableCell: UITableViewCell, ViewCode {

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCode()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Components
    let collectionView: UICollectionView =  {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: Properties
    static let reuseIdentifier = "CollectionViewTableCell"
    private var items = [HomeHeadLineItemModel]()

    // MARK: ViewCode
    func setupViewHierarchy() {
        contentView.addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ]
        )
    }

    func setupAdditionalConfiguration() {
        selectionStyle = .none
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.register(HeadLineCell.self, forCellWithReuseIdentifier: HeadLineCell.reuseIdentifier)
    }


    // MARK: Custom Methods
    func configure(with models: [HomeHeadLineItemModel]) {
        self.items = models
        collectionView.reloadData()
    }

    func scrollToNextItem() {
        let visibleIndexPaths = collectionView.visibleCells.compactMap { collectionView.indexPath(for: $0) }

        var highestVisibleIndexPath = IndexPath(item: 0, section: 0)
        visibleIndexPaths.forEach {
            if $0.item > highestVisibleIndexPath.item {
                highestVisibleIndexPath = $0
            }
        }

        // When at the first or last cell position, only one other cell is on screen
        // normally there are 3 cells on screen.
        // If there are two cells on screen validate that the highest cell is not the last cell
        if visibleIndexPaths.count == 2 && highestVisibleIndexPath.item == items.count - 1 {
            highestVisibleIndexPath = IndexPath(item: 0, section: highestVisibleIndexPath.section)
        }

        collectionView.scrollToItem(at: highestVisibleIndexPath, at: .left, animated: true)
    }


    // MARK: Private Custom Methods
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )

            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            layoutItem.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: Spacing.sm.rawValue,
                bottom: 0,
                trailing: Spacing.sm.rawValue
            )

            let layoutGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.93),
                heightDimension: .estimated(100)
            )
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
            return layoutSection
        }

        return layout
    }
}

// MARK: Extension DataSource
extension CollectionViewTableCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HeadLineCell.reuseIdentifier,
            for: indexPath
        ) as? HeadLineCell else {
            fatalError("Unable to dequeue HeadLineCollectionCell")
        }

        cell.configure(with: items[indexPath.item])

        return cell
    }
}
