//
//  ProductCollectionViewCell.swift
//  Zstore
//
//  Created by Hari Prakash on 25/05/24.
//

import UIKit


class WaterFallLayoutCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "WaterFallLayoutCollectionViewCell"
    
    
   
    //--------- Top Image View -----------//
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "favorite_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    
    //---------- Add to Fav --------------//
    
    let addToFavButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let favButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "heart_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    
    
    let favButtonTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .fav_button_text_color
        label.text = "Add to Fav"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //------------ info view ------------//
    let infoStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 4
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font =  UIFont.font(with: 18, family: FontType.medium)
        label.textColor = .black_colour
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingVew: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //----------Price container View---------//
    let priceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.font(with: 20, family: FontType.semibold)
        label.textColor = .black_colour
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let oldPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.font(with: 13, family: FontType.regular)
        label.textColor = .gray_color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.font(with: 13, family: FontType.regular)
        label.textColor = .description_colour
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let savedPriceButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .green_colour
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
        button.configuration = configuration
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.font(with: 13, family: FontType.medium)
        button.titleLabel?.textColor = .white_colour
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()

    
    //MARK: Variables
    var actionOnCallBack: ((Bool) -> Void)?
    var indexPath: IndexPath?

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
        showOrDismissFavoriteButtonView(show: !(true ?? false))
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
//
            addToFavButtonView.leadingAnchor.constraint(equalTo: favButtonView.leadingAnchor,constant: 0),
            addToFavButtonView.topAnchor.constraint(equalTo: favButtonView.topAnchor, constant: 6),
//            addToFavButtonView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor,constant: 0),
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
//            favButtonView.heightAnchor.constraint(equalToConstant: 36),
//            savedPriceButton.heightAnchor.constraint(equalToConstant: 22),
            
            
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
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
//        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
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
    
    @objc func dismissFavorite() {
        actionOnCallBack?(false)
    }
    
    @objc func addFavorite() {
        actionOnCallBack?(true)
    }
    
    @objc private func didTapLabel(_ gesture: UITapGestureRecognizer) {
        //todo
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
    
    func showOrDismissFavoriteButtonView(show: Bool = true) {
        favoriteImageView.isHidden = show
        favButtonView.isHidden = !show
        addToFavButtonView.isHidden = !show
    }
}

