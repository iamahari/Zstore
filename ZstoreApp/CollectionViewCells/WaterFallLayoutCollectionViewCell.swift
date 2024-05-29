//
//  ProductCollectionViewCell.swift
//  Zstore
//
//  Created by Hari Prakash on 25/05/24.
//

import UIKit


class WaterFallLayoutCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "WaterFallLayoutCollectionViewCell"
    
    
    // MARK: Create the UI components
    lazy var productImageView = AppUIComponents.createImageView(image: UIImage(named: "favorite_icon"),contentMode: .scaleAspectFill)
    lazy var favoriteImageView = AppUIComponents.createImageView(image: UIImage(named: "favorite_icon"),contentMode: .scaleAspectFit)
    lazy var addToFavButtonView = AppUIComponents.createView()
    lazy var favButtonView = AppUIComponents.createView()
    lazy var heartImageView = AppUIComponents.createImageView(image:  UIImage(named: "heart_icon"),contentMode: .scaleAspectFill)
    lazy var favButtonTextLabel = AppUIComponents.createLabel(text:"Add to Fav",textColor: .fav_button_text_color, textAlignment: .left,font:  UIFont.systemFont(ofSize: 13, weight: .semibold))
    let infoStackView = AppUIComponents.createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 4)
    lazy var titleLabel = AppUIComponents.createLabel(text:"",textColor: .black_colour, textAlignment: .left,font:  UIFont.font(with: 18, family: FontType.medium))

    let ratingVew: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var priceContainerView = AppUIComponents.createView()
    lazy var priceLabel = AppUIComponents.createLabel(text:"",textColor: .black_colour, textAlignment: .left,font:  UIFont.font(with: 18, family: FontType.medium))
    lazy var oldPriceLabel = AppUIComponents.createLabel(text:"",textColor:  .gray_color, textAlignment: .left,font:  UIFont.font(with: 13, family: FontType.regular))
    lazy var descriptionLabel = AppUIComponents.createLabel(text:"",textColor:  .description_colour, textAlignment: .left,font: UIFont.font(with: 13, family: FontType.regular))
    let savedPriceButton = CustomButton(backgroundColor: .green_colour,
                                         titleAlignment: .center,
                                         titleFont: UIFont.font(with: 11, family: FontType.medium),
                                         titleColor: .white_colour,
                                         contentInsets: NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8),
                                         isUserInteractionEnabled: false)
    
    //MARK: Variables
    var indexPath: IndexPath?
    
    //MARK: Callback
    var actionOnCallBack: ((Bool) -> Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(productImageView)
        contentView.addSubview(favoriteImageView)
        contentView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(ratingVew)
        infoStackView.addArrangedSubview(priceContainerView)
        infoStackView.addArrangedSubview(savedPriceButton)
        infoStackView.addArrangedSubview(descriptionLabel)
        infoStackView.addArrangedSubview(favButtonView)
        
        priceContainerView.addSubview(priceLabel)
        priceContainerView.addSubview(oldPriceLabel)
        
        favButtonView.addSubview(addToFavButtonView)
        addToFavButtonView.addSubview(heartImageView)
        addToFavButtonView.addSubview(favButtonTextLabel)
        
        infoStackView.isUserInteractionEnabled = true
        contentView.setCornerRadius(radius: 23)
        contentView.setBorder(borderWidth: 2, color: .cell_border_color)
        
        addToFavButtonView.setCornerRadius(radius: 10)
        addToFavButtonView.setBorder(borderWidth: 1, color: .fav_button_border_color)
        savedPriceButton.setCornerRadius(radius: 11)
        productImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 200),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 72),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 75),
            
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            infoStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 12),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            addToFavButtonView.leadingAnchor.constraint(equalTo: favButtonView.leadingAnchor,constant: 0),
            addToFavButtonView.topAnchor.constraint(equalTo: favButtonView.topAnchor, constant: 6),
            addToFavButtonView.bottomAnchor.constraint(equalTo: favButtonView.bottomAnchor, constant: -6),
            
            heartImageView.topAnchor.constraint(equalTo: addToFavButtonView.topAnchor, constant:  6),
            heartImageView.bottomAnchor.constraint(equalTo: addToFavButtonView.bottomAnchor, constant:  -6),
            heartImageView.leadingAnchor.constraint(equalTo: addToFavButtonView.leadingAnchor,constant: 8),
            heartImageView.heightAnchor.constraint(equalToConstant: 24),
            heartImageView.widthAnchor.constraint(equalToConstant: 24),

            favButtonTextLabel.centerYAnchor.constraint(equalTo: addToFavButtonView.centerYAnchor),
            favButtonTextLabel.leadingAnchor.constraint(equalTo: heartImageView.trailingAnchor, constant: 2),
            favButtonTextLabel.trailingAnchor.constraint(equalTo: addToFavButtonView.trailingAnchor, constant: -8),
            
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 88),
            
            ratingVew.heightAnchor.constraint(equalToConstant: 18),
            
            priceLabel.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: 0),
            priceLabel.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor, constant: 0),
            
            oldPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            oldPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor)
            
            
            
        ])
        
        addTapGestures()
        
    }
    
    
    private func addTapGestures() {
        let dimissFavTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFavorite))
        favoriteImageView.addGestureRecognizer(dimissFavTapGesture)
        
        let addFavTapGesture = UITapGestureRecognizer(target: self, action: #selector(addFavorite))
        addToFavButtonView.addGestureRecognizer(addFavTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
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
        oldPriceLabel.attributedText = Utils.markText(String(product.price))
        descriptionLabel.attributedText = Utils.getModifiedString(product.productDescription ?? "")
        ratingVew.addRatingsDetails(with: product)
        isOfferApplied(isApplied: true)
        showOrDismissFavoriteButtonView(show: !product.isFav)
        guard let selectedCardOffer = selectedCardOffer else{return}
        oldPriceLabel.attributedText = Utils.markText(Utils.formatAsIndianCurrency(product.price) ?? "")
        priceLabel.text = String(Utils.calculateDiscountedPrice(product.price, selectedCardOffer.percentage))
        savedPriceButton.setTitle( "Save \(Utils.calculateDiscountSevedPrice(product.price, selectedCardOffer.percentage))", for: .normal)
        isOfferApplied(isApplied: false)
    }
    
    func isOfferApplied(isApplied: Bool) {
        oldPriceLabel.isHidden = isApplied
        savedPriceButton.isHidden = isApplied
        
    }
    
    
    //MARK: Button Actions
    
    /// Remove  the favorite action callback.
    @objc func dismissFavorite() {
        actionOnCallBack?(false)
    }

    /// Adds the favorite action callback.
    @objc func addFavorite() {
        actionOnCallBack?(true)
    }

    /// Handles tap gestures on UILabels to open URLs if available in attributed text.
    ///
    /// - Parameter gesture: The UITapGestureRecognizer instance.
    @objc private func didTapLabel(_ gesture: UITapGestureRecognizer) {
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

    //MARK: Other function
    
    /// Shows or dismisses the favorite button view.
    ///
    /// - Parameter show: A Boolean value indicating whether to show the favorite button view. Default is `true`.
    func showOrDismissFavoriteButtonView(show: Bool = true) {
        favoriteImageView.isHidden = show
        favButtonView.isHidden = !show
        addToFavButtonView.isHidden = !show
    }
}

