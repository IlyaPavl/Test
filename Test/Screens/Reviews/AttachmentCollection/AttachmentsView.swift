//
//  AttachmentsView.swift
//  Test
//
//  Created by Илья Павлов on 01.03.2025.
//


import UIKit

final class AttachmentsView: UIView {
    
    private enum Section {
        case main
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let photosSpacing = 8.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Метод обновляет данные в NSDiffableDataSource, добавляя новые элементы (urls)
    func update(with urls: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(urls)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

private extension AttachmentsView {
    
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return AttachmentsView.createLayout()
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <UICollectionViewCell, String> { (cell, indexPath, url) in
            let config = AttachmentsConfig(attachmentURL: url)
            cell.contentConfiguration = config
        }
        
        
        dataSource = UICollectionViewDiffableDataSource
        <Section, String>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    static func createLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(photoSize.width),
            heightDimension: .absolute(photoSize.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = photosSpacing
        
        return section
    }
}
