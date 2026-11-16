//
//  CacheImageViewCell.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 16/11/26.
//

import UIKit

final class CacheImageViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CacheImageViewCell"
    private var loadTask: Task<Void, Never>?
    
    private let imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.backgroundColor = .secondarySystemBackground
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let metricLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = .monospacedSystemFont(ofSize: 11, weight: .semibold)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 6
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(metricLabel)
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            metricLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            metricLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            metricLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            metricLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        loadTask?.cancel()
        imageView.image = nil
        metricLabel.text = "Loading..."
        metricLabel.backgroundColor = .tertiarySystemFill
    }
    
    func configure(with url: URL) {
        
        loadTask?.cancel()
        metricLabel.text = "Loading..."
        metricLabel.backgroundColor = .tertiarySystemFill
        
        loadTask = Task { [weak self] in
        
            do {
                let result = try await ImageLoader.shared.loadImageWithMetrices(from: url)
                
                guard !Task.isCancelled else { return }
                
                self?.imageView.image = result.image
                self?.metricLabel.text = String(format: "%@ (%.1f ms)", result.source.rawValue, result.durationMs)
                
                switch result.source {
                case .memory:
                    self?.metricLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
                    self?.metricLabel.textColor = .systemGreen
                case .disk:
                    self?.metricLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
                    self?.metricLabel.textColor = .systemBlue
                case .network:
                    self?.metricLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
                    self?.metricLabel.textColor = .systemOrange
                }
                
            }catch {
                guard !Task.isCancelled else { return }
                self?.metricLabel.text = "Failed"
                self?.metricLabel.textColor = .systemRed
            }
        }
        
    }
}
