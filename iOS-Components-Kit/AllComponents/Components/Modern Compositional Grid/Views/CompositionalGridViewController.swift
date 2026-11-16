//
//  CompositionalGridViewController.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

final class CompositionalGridViewController: UIViewController {
    
    private var selectedCategoryId: String = "all"
    private var categories: [CategoryModel] = [
        CategoryModel(id: "all", name: "All", icon: "square.grid.2x2.fill", isSelected: true),
        CategoryModel(id: "nature", name: "Nature", icon: "leaf.fill", isSelected: false),
        CategoryModel(id: "arch", name: "Architecture", icon: "building.2.fill", isSelected: false),
        CategoryModel(id: "tech", name: "Tech", icon: "cpu.fill", isSelected: false)
    ]
    
    private let banners: [BannerModel] = [
        BannerModel(title: "Compositional Layout", subtitle: "Multi-section orthogonal scrolling", imageURL: "https://picsum.photos/id/1015/600/300", accentHex: .systemIndigo),
        BannerModel(title: "Diffable DataSource", subtitle: "Zero-crash animated snapshots", imageURL: "https://picsum.photos/id/1018/600/300", accentHex: .systemTeal),
        BannerModel(title: "Actor Image Cache", subtitle: "Powered by Swift Concurrency", imageURL: "https://picsum.photos/id/1025/600/300", accentHex: .systemOrange)
    ]
    
    private var allAssets: [AssetModel] = [
        AssetModel(title: "Alpine Ridge", categoryId: "nature", priceTag: "Featured", imageURL: "https://picsum.photos/id/1036/400/400"),
        AssetModel(title: "Glass Pavilion", categoryId: "arch", priceTag: "New", imageURL: "https://picsum.photos/id/1040/400/400"),
        AssetModel(title: "Circuit Core", categoryId: "tech", priceTag: "Pro", imageURL: "https://picsum.photos/id/1060/400/400"),
        AssetModel(title: "Misty Forest", categoryId: "nature", priceTag: "Popular", imageURL: "https://picsum.photos/id/1043/400/400"),
        AssetModel(title: "Metro Bridge", categoryId: "arch", priceTag: "Trending", imageURL: "https://picsum.photos/id/1048/400/400"),
        AssetModel(title: "Studio Desk", categoryId: "tech", priceTag: "Editor Pick", imageURL: "https://picsum.photos/id/1070/400/400")
    ]
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CompositionalLayoutFactory.createLayout())
        cv.backgroundColor = .systemGroupedBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        return cv
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<GridSection, GridItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Compositional Grid"
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "shuffle"),
            style: .plain,
            target: self,
            action: #selector(didTapShuffle)
        )
        
        setupLayout()
        configureDataSource()
        applySnapshot(animatingDifferences: false)
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        // Banner Cell Registration
        let bannerReg = UICollectionView.CellRegistration<UICollectionViewCell, BannerModel> { cell, _, banner in
            var config = UIListContentConfiguration.subtitleCell()
            config.text = banner.title
            config.textProperties.font = .systemFont(ofSize: 20, weight: .bold)
            config.textProperties.color = .white
            config.secondaryText = banner.subtitle
            config.secondaryTextProperties.color = .white.withAlphaComponent(0.85)
            cell.contentConfiguration = config
            cell.backgroundConfiguration = {
                
                var bg = UIBackgroundConfiguration.listCell()
                bg.backgroundColor = banner.accentHex
                bg.cornerRadius = 16
                return bg
            }()
        }
        
        // Category Chip Registration
        let categoryReg = UICollectionView.CellRegistration<UICollectionViewCell, CategoryModel> { cell, _, category in
            var config = UIListContentConfiguration.cell()
            config.text = category.name
            config.textProperties.font = .systemFont(ofSize: 13, weight: .semibold)
            config.textProperties.color = category.isSelected ? .white : .label
            config.image = UIImage(systemName: category.icon)
            config.imageProperties.tintColor = category.isSelected ? .white : .systemIndigo
            config.imageProperties.maximumSize = CGSize(width: 15, height: 15)
            config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            cell.contentConfiguration = config
            
            var bg = UIBackgroundConfiguration.listCell()
            bg.backgroundColor = category.isSelected ? .systemIndigo : .secondarySystemGroupedBackground
            bg.cornerRadius = 18
            cell.backgroundConfiguration = bg
        }
        
        // Grid Asset Cell Registration
        let assetReg = UICollectionView.CellRegistration<GridAssetCell, AssetModel> { cell, _, asset in
            cell.configure(with: asset)
        }
        
        dataSource = UICollectionViewDiffableDataSource<GridSection, GridItem>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .banner(let banner):
                return collectionView.dequeueConfiguredReusableCell(using: bannerReg, for: indexPath, item: banner)
            case .category(let category):
                return collectionView.dequeueConfiguredReusableCell(using: categoryReg, for: indexPath, item: category)
            case .asset(let asset):
                return collectionView.dequeueConfiguredReusableCell(using: assetReg, for: indexPath, item: asset)
            }
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<GridSection, GridItem>()
        snapshot.appendSections(GridSection.allCases)
        
        snapshot.appendItems(banners.map { .banner($0) }, toSection: .featured)
        snapshot.appendItems(categories.map { .category($0) }, toSection: .categories)
        
        let filtered = selectedCategoryId == "all"
            ? allAssets
            : allAssets.filter { $0.categoryId == selectedCategoryId }
        snapshot.appendItems(filtered.map { .asset($0) }, toSection: .items)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    @objc private func didTapShuffle() {
        allAssets.shuffle()
        applySnapshot(animatingDifferences: true)
    }
}

extension CompositionalGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath),
              case .category(let tappedCategory) = item else { return }
        
        selectedCategoryId = tappedCategory.id
        categories = categories.map { cat in
            var updated = cat
            updated.isSelected = (cat.id == tappedCategory.id)
            return updated
        }
        applySnapshot(animatingDifferences: true)
    }
}


