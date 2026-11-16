//
//  GridAssetCell.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

// MARK: - Grid Asset Cell (Uses ActorImageCache)
 final class GridAssetCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .tertiarySystemFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 11, weight: .medium)
        label.textColor = .systemIndigo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 14
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 140),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            badgeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            badgeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            badgeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelImageLoad()
        imageView.image = nil
    }
    
    func configure(with asset: AssetModel) {
        titleLabel.text = asset.title
        badgeLabel.text = asset.priceTag
        imageView.setImage(from: asset.imageURL)
    }
}
