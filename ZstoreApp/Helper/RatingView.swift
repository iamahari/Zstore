//
//  RatingsView.swift
//  Zstore
//
//  Created by Hari Prakash on 25/05/24.
//

import UIKit


class RatingView: UIView {
    
    let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(with: 13, family: FontType.semibold)
        label.textColor = .orange_colour
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(with: 13, family: FontType.regular)
        label.textColor = .gray_color
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(ratingCountLabel)
        addSubview(ratingStackView)
        addSubview(reviewCountLabel)
        
        NSLayoutConstraint.activate([
            ratingCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            ratingStackView.leadingAnchor.constraint(equalTo: ratingCountLabel.trailingAnchor, constant: 6),
            ratingStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            reviewCountLabel.leadingAnchor.constraint(equalTo: ratingStackView.trailingAnchor, constant: 6),
            reviewCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            reviewCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
    }
    
    private func setupRatingStars(count: Double) {
        ratingStackView.subviews.forEach({ $0.removeFromSuperview()})
        for index in 0..<5 {
            let starImageView = UIImageView(frame: .init(x: 0, y: 0, width: 10, height: 10))
            starImageView.image = UIImage(systemName:  "star.fill")
            starImageView.tintColor = (index < Int(count)) ? .orange_colour : .gray_color
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    
    func addRatingsDetails(with product: Products) {
        reviewCountLabel.text = "(\(product.reviewCount))"
        ratingCountLabel.text = "\(product.rating)"
        setupRatingStars(count: product.rating)
    }
    
}
