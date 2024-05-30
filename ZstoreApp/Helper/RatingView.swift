//
//  RatingsView.swift
//  Zstore
//
//  Created by Hari Prakash on 25/05/24.
//

import UIKit


class RatingView: UIView {
    
    // MARK: Create the UI components
    let ratingCountLabel = AppUIComponents.createLabel(text: "",textColor: .orange_colour, font: UIFont.font(with: 11, family: FontType.semibold))
    let reviewCountLabel = AppUIComponents.createLabel(text: "",textColor: .gray_color, font:UIFont.font(with: 11, family: FontType.semibold))
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Override function
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Setup the constraint
    private func setupView() {
        addSubview(ratingCountLabel)
        addSubview(ratingStackView)
        addSubview(reviewCountLabel)
        
        NSLayoutConstraint.activate([
            ratingCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            ratingStackView.leadingAnchor.constraint(equalTo: ratingCountLabel.trailingAnchor, constant: 6),
//            ratingStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            ratingStackView.heightAnchor.constraint(equalToConstant: 14),
            ratingStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingStackView.widthAnchor.constraint(equalToConstant: 74),
            
            reviewCountLabel.leadingAnchor.constraint(equalTo: ratingStackView.trailingAnchor, constant: 6),
            reviewCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }
    
    /// Sets up the star rating views based on the given rating count.
    ///
    /// - Parameter count: The rating value to determine the number of filled stars.
    /// This method creates five star image views, filling them based on the `count` value.
    private func setupRatingStars(count: Double) {
        ratingStackView.subviews.forEach({ $0.removeFromSuperview()})
        for index in 0..<5 {
            let starImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
            starImageView.image = UIImage(systemName:  "star.fill")
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.contentMode = .scaleToFill
            // Set the star color based on the rating count
            starImageView.tintColor = (index < Int(count)) ? .orange_colour : .gray_color
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    /// Updates the UI elements with the product's rating and review details.
    ///
    /// - Parameter product: The product whose rating and review details are to be displayed.
    /// This method sets the review count, rating count, and updates the star rating view.
    func addRatingsDetails(with product: ProductsList) {
        reviewCountLabel.text = "(\(product.reviewCount))"
        ratingCountLabel.text = "\(product.rating)"
        setupRatingStars(count: product.rating)
    }
    
}
