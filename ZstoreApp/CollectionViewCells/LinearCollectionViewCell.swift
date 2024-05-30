//
//  MobileCollectionViewCell.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import UIKit

class LinearCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LinearCollectionViewCell"
    
    // MARK: Create the UI components
    lazy var productImageView = AppUIComponents.createImageView(contentMode: .scaleAspectFill)
    lazy var favoriteImageView = AppUIComponents.createImageView(image: UIImage(named: "favorite_icon"),contentMode: .scaleAspectFill)
    let infoStackView = AppUIComponents.createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 4)
    let colorsStackView =  AppUIComponents.createStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4)
    lazy var titleLabel = AppUIComponents.createLabel(text:"",textColor: .black_colour, textAlignment: .left,font: UIFont.font(with: 18, family: FontType.semibold))
    lazy var ratingVew: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var priceContainerView = AppUIComponents.createView()
    lazy var priceLabel = AppUIComponents.createLabel(text:"",textColor: .black_colour, textAlignment: .left,font: UIFont.font(with: 20, family: FontType.semibold))
    lazy var oldPriceLabel = AppUIComponents.createLabel(text:"",textColor: .gray_color, textAlignment: .left,font: UIFont.font(with: 13, family: FontType.regular))
    lazy var descriptionLabel = AppUIComponents.createLabel(text:"",textColor: .description_colour, textAlignment: .left,font:  UIFont.font(with: 13, family: FontType.regular))
    lazy var createTextView = AppUIComponents.createTextView()
    let savedPriceButton = CustomButton(backgroundColor: .green_colour,
                                         titleAlignment: .center,
                                        titleFont: UIFont.systemFont(ofSize: 5),
                                         titleColor: .white_colour,
                                         contentInsets: NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8),
                                         isUserInteractionEnabled: false)
    lazy var colorsContainerView = AppUIComponents.createView()
    
    // MARK: Overide function
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup the constraint
    private func setupViews() {
        titleLabel.numberOfLines = 3
        priceLabel.numberOfLines = 3
        oldPriceLabel.numberOfLines = 3
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(productImageView)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(ratingVew)
        infoStackView.addArrangedSubview(priceContainerView)
        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(colorsContainerView)
        
        priceContainerView.addSubview(priceLabel)
        priceContainerView.addSubview(oldPriceLabel)
        priceContainerView.addSubview(savedPriceButton)
        colorsContainerView.addSubview(colorsStackView)
        
        infoStackView.isUserInteractionEnabled = true

        savedPriceButton.backgroundColor = .green_colour
        savedPriceButton.setCornerRadius(radius: 11)
        productImageView.setCornerRadius(radius: 13)
        
        NSLayoutConstraint.activate([
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.heightAnchor.constraint(equalToConstant: 90),
            productImageView.widthAnchor.constraint(equalToConstant: 90),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            
            infoStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor,constant: 10),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 88),
            
            ratingVew.heightAnchor.constraint(equalToConstant: 18),
            
            
            priceLabel.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: 0),
            priceLabel.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor, constant: 0),
            
            oldPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            oldPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            
            savedPriceButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            savedPriceButton.leadingAnchor.constraint(equalTo: oldPriceLabel.trailingAnchor, constant: 4),
            savedPriceButton.heightAnchor.constraint(equalToConstant: 22),
            
            colorsStackView.topAnchor.constraint(equalTo: colorsContainerView.topAnchor, constant: 0),
            colorsStackView.bottomAnchor.constraint(equalTo: colorsContainerView.bottomAnchor, constant: 0),
            colorsStackView.leadingAnchor.constraint(equalTo: colorsContainerView.leadingAnchor, constant: 0)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        descriptionLabel.addGestureRecognizer(tapGesture)

    }
    
    /// Updates the cell UI with product details and card offers.
    ///
    /// - Parameters:
    ///   - product: The `ProductsList` object containing product details.
    ///   - selectedCardOffer: The `CardOffers` object representing the selected card offer.
    func updateCell(product: ProductsList,with selectedCardOffer: CardOffers?) {
        if let url = URL(string: product.imageUrl ?? "")  {
            productImageView.loadImage(from: url)
        }
        titleLabel.text = product.name
        priceLabel.text = String(Utils.formatAsIndianCurrency(product.price) ?? "")
        descriptionLabel.attributedText = Utils.getModifiedString(product.productDescription ?? "")
        ratingVew.addRatingsDetails(with: product)
        if let color = product.colors {
            let colorsArray = color.split(separator: ",").map { String($0) }
            setupColorsView(colors: colorsArray)
        }
        isOfferApplied(isApplied: true)
        guard let selectedCardOffer = selectedCardOffer else{return}
        oldPriceLabel.attributedText = Utils.markText(Utils.formatAsIndianCurrency(product.price) ?? "")
        priceLabel.text = String(Utils.calculateDiscountedPrice(product.price, selectedCardOffer.percentage))
        savedPriceButton.setTitle( "Save \(Utils.calculateDiscountSevedPrice(product.price, selectedCardOffer.percentage))", for: .normal)
        isOfferApplied(isApplied: false)
       
    }
    
   
    
    /// Adjusts the visibility of UI elements based on whether an offer is applied.
    ///
    /// - Parameters:
    ///   - isApplied: A boolean value indicating whether an offer is applied.
    func isOfferApplied(isApplied: Bool) {
        oldPriceLabel.isHidden = isApplied
        savedPriceButton.isHidden = isApplied
    }

    /// Sets up the color view with the provided colors.
    ///
    /// - Parameter colors: An array of strings representing colors.
    private func setupColorsView(colors: [String]) {
        colorsStackView.subviews.forEach({ $0.removeFromSuperview()})
        for color in colors {
            let circleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            circleImageView.image = UIImage(systemName:  "circle.fill")
            circleImageView.tintColor = UIColor.getColor(of: color)
            colorsStackView.addArrangedSubview(circleImageView)
        }
    }

    /// Handles tap gestures on UILabels to open URLs if available in attributed text.
    ///
    /// - Parameter gesture: The UITapGestureRecognizer instance.
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        let text = label.attributedText?.string ?? ""
        
        for index in  0..<text.count {
            let attributes = label.attributedText!.attributes(at: index, effectiveRange: nil)
            if let url = attributes[.link] as? URL {
                UIApplication.shared.open(url)
                return
            } else if let urlString = attributes[.link] as? String, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
                return
            }
        }
    }
}
