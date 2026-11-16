//
//  ComponentCell.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import Foundation
import UIKit

final class ComponentCell: UITableViewCell {
    
    static let identifier = "ComponentCell"
        
        private let cardView: UIView = {
            let view = UIView()
            view.backgroundColor = .secondarySystemGroupedBackground
            view.layer.cornerRadius = 14
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let iconContainer: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let iconView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .white
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .label
            label.numberOfLines = 2
            return label
        }()
        
        private let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13.5)
            label.textColor = .secondaryLabel
            label.numberOfLines = 2
            return label
        }()
        
        private let stackTagsLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 3
            label.font = .monospacedSystemFont(ofSize: 11.5, weight: .medium)
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        private func setupUI() {
            backgroundColor = .clear
            selectionStyle = .none
            
            contentView.addSubview(cardView)
            cardView.addSubview(iconContainer)
            iconContainer.addSubview(iconView)
            
            let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, stackTagsLabel])
            textStack.axis = .vertical
            textStack.spacing = 4
            textStack.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview(textStack)
            
            NSLayoutConstraint.activate([
                cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
                cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
                cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                iconContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
                iconContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
                iconContainer.widthAnchor.constraint(equalToConstant: 44),
                iconContainer.heightAnchor.constraint(equalToConstant: 44),
                
                iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
                iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
                iconView.widthAnchor.constraint(equalToConstant: 22),
                iconView.heightAnchor.constraint(equalToConstant: 22),
                
                textStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
                textStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),
                textStack.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 14),
                textStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14)
            ])
        }
        
        func configure(with item: ComponentItem) {
            titleLabel.text = item.title
            subtitleLabel.text = item.subtitle
            stackTagsLabel.text = item.techStack.map { "#\($0)" }.joined(separator: "  ")
            stackTagsLabel.textColor = item.accentColor
            iconContainer.backgroundColor = item.accentColor
            iconView.image = UIImage(systemName: item.iconName)
        }
}

