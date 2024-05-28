//
//  ProductInfoView.swift
//  Zstore
//
//  Created by Hari Prakash on 25/05/24.
//

import UIKit

class ProductInfoView: UIView {
    
    private let productNameLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let colorsStackView = UIStackView()
    private let reviewCountLabel = UILabel()
    private let currentPriceLabel = UILabel()
    private let oldPriceLabel = UILabel()
    private let discountLabel = UILabel()
    private let deliveryInfoLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Configure productNameLabel
        productNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        productNameLabel.numberOfLines = 0
        productNameLabel.textColor = .black

        // Configure ratingStackView
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 2
        
        colorsStackView.axis = .horizontal
        colorsStackView.spacing = 2

        // Configure reviewCountLabel
        reviewCountLabel.font = UIFont.systemFont(ofSize: 14)
        reviewCountLabel.textColor = .gray

        // Configure currentPriceLabel
        currentPriceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        currentPriceLabel.textColor = .systemRed

        // Configure oldPriceLabel
        oldPriceLabel.font = UIFont.systemFont(ofSize: 16)
        oldPriceLabel.textColor = .gray
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "₹64,999")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        oldPriceLabel.attributedText = attributeString

        // Configure discountLabel
        discountLabel.font = UIFont.systemFont(ofSize: 16)
        discountLabel.textColor = .systemGreen
        discountLabel.backgroundColor = .systemGray6
        discountLabel.layer.cornerRadius = 5
        discountLabel.layer.masksToBounds = true

        // Configure deliveryInfoLabel
        deliveryInfoLabel.font = UIFont.systemFont(ofSize: 14)
        deliveryInfoLabel.textColor = .gray

        // Add subviews
        addSubview(productNameLabel)
        addSubview(ratingStackView)
        addSubview(reviewCountLabel)
        addSubview(currentPriceLabel)
        addSubview(oldPriceLabel)
        addSubview(discountLabel)
        addSubview(deliveryInfoLabel)
        addSubview(colorsStackView)

        // Disable autoresizing mask translation
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        reviewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        oldPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        colorsStackView.translatesAutoresizingMaskIntoConstraints = false
        deliveryInfoLabel.numberOfLines = 0
        // Set up constraints
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            productNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            productNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            ratingStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

            reviewCountLabel.centerYAnchor.constraint(equalTo: ratingStackView.centerYAnchor),
            reviewCountLabel.leadingAnchor.constraint(equalTo: ratingStackView.trailingAnchor, constant: 4),

            currentPriceLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 8),
            currentPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

            oldPriceLabel.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor),
            oldPriceLabel.leadingAnchor.constraint(equalTo: currentPriceLabel.trailingAnchor, constant: 8),

            discountLabel.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: oldPriceLabel.trailingAnchor, constant: 8),

            deliveryInfoLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 4),
            deliveryInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            deliveryInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            colorsStackView.topAnchor.constraint(equalTo: deliveryInfoLabel.bottomAnchor, constant: 4),
            colorsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            colorsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    private func setupRatingStars(count: Double) {
        ratingStackView.subviews.forEach({ $0.removeFromSuperview()})
        for index in 0..<5 {
            let starImageView = UIImageView(image: UIImage(systemName:  "star.fill"))
            starImageView.tintColor = (index < Int(count)) ? .orange_colour : .gray_color
         
            ratingStackView.addArrangedSubview(starImageView)
            colorsStackView.addArrangedSubview(starImageView)
       
        }
//        layoutIfNeeded()
    }

    func configure(with product: Productss) {
        productNameLabel.text = product.name
        reviewCountLabel.text = "(\(product.reviewCount))"
        currentPriceLabel.text = product.currentPrice
        oldPriceLabel.text = product.oldPrice
        discountLabel.text = "Save \(product.discount)"
        deliveryInfoLabel.text = product.deliveryInfo
        setupRatingStars(count: product.rating)
    }
}

struct Productss {
    let name: String
    let rating: Double
    let `reviewCount`: Int
    let currentPrice: String
    let oldPrice: String
    let discount: String
    let deliveryInfo: String
    let image: String
    var isFav: Bool
    var colors: [String]
    var showDiscontCount: Bool
}

