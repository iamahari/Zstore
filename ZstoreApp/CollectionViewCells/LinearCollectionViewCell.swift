//
//  MobileCollectionViewCell.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import UIKit

class LinearCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LinearCollectionViewCell"
    
    weak var delegate: ProductCollectionViewCellDelegate?
    
    
   
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
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingVew: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //------------Price View ------------//
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
        label.numberOfLines = 3
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
    
    //------Colors View---------------
    let colorsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let colorsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    var product: Products? {
      didSet {
        if let product = product {
//            productImageView.image = UIImage(named:  product.image)
//            titleLabel.text = product.name
//            priceLabel.text = product.currentPrice
//            oldPriceLabel.attributedText = Utils.markText(product.oldPrice)
//            savedPriceButton.setTitle( "Save \(product.discount)", for: .normal)
//            descriptionLabel.attributedText = Utils.getModifiedString(product.deliveryInfo)
//            setupColorsView(colors: product.colors)
//            ratingVew.addRatingsDetails(with: product)
//            savedPriceButton.isHidden = !product.showDiscontCount
//            oldPriceLabel.isHidden = !product.showDiscontCount
        }
      }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
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
            
            colorsStackView.topAnchor.constraint(equalTo: colorsContainerView.topAnchor, constant: 0),
            colorsStackView.bottomAnchor.constraint(equalTo: colorsContainerView.bottomAnchor, constant: 0),
            colorsStackView.leadingAnchor.constraint(equalTo: colorsContainerView.leadingAnchor, constant: 0)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
        descriptionLabel.addGestureRecognizer(tapGesture)

    }
    
    func updateCell(product: Products) {
        if let url = URL(string: product.imageURL)  {
            productImageView.loadImage(from: url)
        }
        titleLabel.text = product.name
        priceLabel.text = String(product.price)
        oldPriceLabel.attributedText = Utils.markText(String(product.price))
        savedPriceButton.setTitle( "Save \(5)", for: .normal)
        descriptionLabel.attributedText = Utils.getModifiedString(product.description)
        ratingVew.addRatingsDetails(with: product)
//        showOrDismissFavoriteButtonView(show: !(false))
        savedPriceButton.isHidden = !true
        oldPriceLabel.isHidden = !true
    }
    
    private func setupColorsView(colors: [String]) {
        colorsStackView.subviews.forEach({ $0.removeFromSuperview()})
        for color in colors {
            let circleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            circleImageView.image = UIImage(systemName:  "circle.fill")
            circleImageView.tintColor = UIColor.getColor(of: color)
            colorsStackView.addArrangedSubview(circleImageView)
        }
    }
    
    @objc private func didTapLabel(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel, let text = label.attributedText else { return }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: text)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        let location = gesture.location(in: label)
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < text.length,
           let linkValue = text.attribute(.link, at: characterIndex, effectiveRange: nil) as? URL {
            // Handle link tap
            UIApplication.shared.open(linkValue)
        }
    }

}
