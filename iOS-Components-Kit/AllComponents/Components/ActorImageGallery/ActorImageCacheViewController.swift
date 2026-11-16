//
//  ActorImageCacheViewController.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit


final class ActorImageCacheViewController: UIViewController {
    
    private let imageURLs: [URL] = (1...24).compactMap { index in
        URL(string: "https://picsum.photos/id/\(index + 10)/400/400")
    }
    
    private lazy var collectionView: UICollectionView = {
        let spacing: CGFloat = 12
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - (spacing * 3) / 2)
        layout.itemSize = CGSize(width: width, height: width + 32)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let collectionVw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVw.backgroundColor = .systemBackground
        collectionVw.translatesAutoresizingMaskIntoConstraints = false
        collectionVw.dataSource = self
        collectionVw.register(CacheImageViewCell.self, forCellWithReuseIdentifier: CacheImageViewCell.reuseIdentifier)
        return collectionVw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Actor Image Cache"
        view.backgroundColor = .systemBackground
        
        setupNavigationActions()
        setupBasicDetails()
    }
    
    private func setupNavigationActions() {
        let reloadAction = UIAction(title: "Reload Grid", image: UIImage(systemName: "arrow.clockwise")) { [weak self] _ in
            self?.collectionView.reloadData()
        }
        let clearRAMAction = UIAction(title: "Clear Memory Only", image: UIImage(systemName: "memorychip")) { [weak self] _ in
            Task {
                await ImageLoader.shared.clearMemoryCache()
                self?.collectionView.reloadData()
            }
        }
        let clearAllAction = UIAction(title: "Clear All Cache", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            Task {
                await ImageLoader.shared.clearAllCache()
                self?.collectionView.reloadData()
            }
        }
        
        let menu = UIMenu(title: "Cache Controls", children: [reloadAction, clearRAMAction, clearAllAction])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
    }
    
    func setupBasicDetails(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ActorImageCacheViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CacheImageViewCell.reuseIdentifier,
            for: indexPath
        ) as? CacheImageViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLs[indexPath.item])
        return cell
        
    }
    
    
    
}
