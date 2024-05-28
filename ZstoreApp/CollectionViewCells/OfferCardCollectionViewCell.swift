//
//  OfferCollectionViewCell.swift
//  Zstore
//
//  Created by Hari Prakash on 25/05/24.
//

import Foundation
import UIKit


class OfferCardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CashbackCollectionViewCell"
    
    // MARK: create the UI components
    private let titleLabel = AppUIComponents.createLabel(text: "",textColor: .white, fontSize: 16)
    private let subtitleLabel = AppUIComponents.createLabel(text: "",textColor: .white, fontSize: 12)
    private let cashbackLabel = AppUIComponents.createLabel(text: "",textColor: .white, fontSize: 16)
    private let imageView = AppUIComponents.createImageView(contentMode: .scaleAspectFit)
    private let containerView = AppUIComponents.createView(backgroundColor: .black,cornerRadius: 10 )
    private let overflowView = AppUIComponents.createView(backgroundColor: .clear,clipsToBounds: false)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        contentView.addSubview(overflowView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(cashbackLabel)
        overflowView.addSubview(imageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup the constraint
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: overflowView.leadingAnchor, constant: -20)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: overflowView.leadingAnchor, constant: -5)
        ])
        
        cashbackLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashbackLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cashbackLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            cashbackLabel.trailingAnchor.constraint(equalTo: overflowView.leadingAnchor, constant: -20)
        ])
        
        overflowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overflowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overflowView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            overflowView.widthAnchor.constraint(equalToConstant: 90),
            overflowView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: overflowView.trailingAnchor, constant: 20), // Adjust the constant for overflow
            imageView.centerYAnchor.constraint(equalTo: overflowView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90)
        ])
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.layoutIfNeeded()
    }
    
    //MARK: Update the cell
    func configure(with offer: CardOffer,gradientColor: [CGColor]) {
        titleLabel.text = offer.cardName
        subtitleLabel.text = offer.offerDesc
        cashbackLabel.text = offer.maxDiscount
        if let url = URL(string: offer.imageURL)  {
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 13
            imageView.loadImage(from: url)
        }
        containerView.addLinearGradientBackground(colors: gradientColor)
        contentView.layer.cornerRadius = 16
    }
}


