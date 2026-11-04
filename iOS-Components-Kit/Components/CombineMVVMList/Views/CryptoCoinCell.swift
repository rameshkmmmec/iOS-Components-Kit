//
//  CryptoCoinCell.swift
//  iOS-Components-Kit
//
//  Created by Ramesh on 04/11/26.
//

import Foundation
import UIKit


final class CryptoCoinCell: UITableViewCell {
    
    static let identifier = "CryptoCoinCell"
    
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 28/255, green: 27/255, blue: 32/255, alpha: 1)
        //view.layer.cornerRadius = 12        // Rounded corners
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UI components
    private let iconImageView: UIImageView = {
        
        let imageVw = UIImageView()
        imageVw.translatesAutoresizingMaskIntoConstraints = false
        imageVw.contentMode = .scaleAspectFit
        imageVw.layer.cornerRadius = 20
        imageVw.clipsToBounds = true
        imageVw.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        return imageVw
    }()
    
    
    private let nameLabel: UILabel = {
        
        let nameLbl = UILabel()
        nameLbl.textColor = .white
        nameLbl.font = .systemFont(ofSize: 20, weight: .bold)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        return nameLbl
        
    }()
    
    
    private let detailLabel: UILabel = {
        
        let detailLbl = UILabel()
        detailLbl.textColor = UIColor(red: 139/255, green: 139/255, blue: 141/255, alpha: 11)
        detailLbl.font = .systemFont(ofSize: 17, weight: .regular)
        detailLbl.translatesAutoresizingMaskIntoConstraints = false
        return detailLbl
    }()
    
    
    private var amountLabel: UILabel = {
      
        let amountLbl = UILabel()
        amountLbl.textColor = .white
        amountLbl.font = .systemFont(ofSize: 20, weight: .bold)
        amountLbl.translatesAutoresizingMaskIntoConstraints = false
        return amountLbl
    }()
    
    
    private var precentageView: UIView = {
        
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 109/255, green: 185/255, blue: 115/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var percentageLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 13, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private var titleStackView: UIStackView = {
        
        let titleStackVw = UIStackView()
        titleStackVw.axis = .vertical
        titleStackVw.spacing = 3
        titleStackVw.alignment = .leading
        titleStackVw.translatesAutoresizingMaskIntoConstraints = false
        return titleStackVw
    }()
    
    private var priceStackView: UIStackView = {
        let priceStackVw = UIStackView()
        priceStackVw.axis = .vertical
        priceStackVw.spacing = 4
        priceStackVw.alignment = .trailing
        priceStackVw.translatesAutoresizingMaskIntoConstraints = false
        return priceStackVw
    }()
    
    private var imageLoadTask: Task<Void, Never>?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        //setupCellComponents()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("intit(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(containerView)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleStackView)
        containerView.addSubview(priceStackView)
        
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(detailLabel)
        
        precentageView.addSubview(percentageLabel)
        priceStackView.addArrangedSubview(amountLabel)
        priceStackView.addArrangedSubview(precentageView)
        
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        precentageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),       // Upar se gap
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0), // Neeche se gap
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 14),
            titleStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleStackView.trailingAnchor.constraint(lessThanOrEqualTo: priceStackView.leadingAnchor, constant: -12),
            
            priceStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            priceStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            percentageLabel.topAnchor.constraint(equalTo: precentageView.topAnchor, constant: 5),
            percentageLabel.bottomAnchor.constraint(equalTo: precentageView.bottomAnchor, constant: -5),
            percentageLabel.leadingAnchor.constraint(equalTo: precentageView.leadingAnchor, constant: 8),
            percentageLabel.trailingAnchor.constraint(equalTo: precentageView.trailingAnchor, constant: -8),
            
            containerView.topAnchor.constraint(lessThanOrEqualTo: titleStackView.topAnchor, constant: -14),
            containerView.bottomAnchor.constraint(greaterThanOrEqualTo: titleStackView.bottomAnchor, constant: 14),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 68)
            
        ])
    }
    
    func configureCell(with indexCount: Int, itemList:[CryptoModel]) {
        
        let coin = itemList[indexCount]
        
        nameLabel.text = coin.name
        detailLabel.text = coin.symbol.uppercased()
        amountLabel.text = String(format: "$%.2f", coin.current_price ?? 0)
        
        let change = coin.price_change_percentage_24h ?? 0
        let isPositive = (change >= 0)
        
        percentageLabel.text = String(format: "%@%.2f", isPositive ? "+":"", change)
        
        let primaryColor: UIColor = isPositive ? UIColor(red: 109/255, green: 185/255, blue: 115/255, alpha: 1) : .systemRed
        precentageView.backgroundColor = primaryColor.withAlphaComponent(1.0)
        
        iconImageView.setImage(from: coin.image, placeholder: UIImage(named: "coinPlaceholder"))
        
        let itemCount = itemList.count
        let cornerRedius: CGFloat = 16
        
        if itemCount == 1{
            self.containerView.roundCorners(.all, radius: cornerRedius)
        } else if indexCount == 0 {
            self.containerView.roundCorners(.top, radius: cornerRedius)
        } else if indexCount+1 == itemCount {
            self.containerView.roundCorners(.bottom, radius: cornerRedius)
        }else {
            self.containerView.layer.cornerRadius = 0
            self.containerView.layer.maskedCorners = []
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
}

