//
//  OfferListView.swift
//  Zstore
//
//  Created by Hari Prakash on 27/05/24.
//

import UIKit


class OfferCardListView: UICollectionReusableView{
    
    static let reuseIdentifier = "OfferListView"
    
    // MARK: Create the UI components
    
    private var offerView = AppUIComponents.createView()
    private var offerTitle = AppUIComponents.createLabel(text: "Offers",textColor: .orangeColour, font: UIFont.font(with: 18, family: FontType.bold))
    private var appliedLabel = AppUIComponents.createLabel(text: "Applied:",textColor: .fav_button_text_color,fontSize: 14)
    var applledOfferValueLabel = AppUIComponents.createLabel(text: "",textColor: .blue_colour,fontSize: 14)
    private var offerImg = AppUIComponents.createImageView(image: UIImage(systemName: "bolt.fill"), contentMode: .scaleAspectFit)
    private var containerView = AppUIComponents.createView(cornerRadius: 15,borderWidth: 1,borderColor: UIColor.blue_colour.cgColor)
    var offerCollectionView: UICollectionView!
    var containerViewBottomConstraints: NSLayoutConstraint!
    let removeAppliedOfferBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("×", for: .normal)
        button.setTitleColor(.blue_colour, for: .normal)
        button.titleLabel?.font = UIFont(name: FontType.medium.value, size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var appliedContainerOuterView = AppUIComponents.createView()
    
    // MARK: Variables
    var cardOffers: [CardOffers]?
    
    // MARK: delegate and callback
    
//    weak var delegate: OfferListViewDelegate?
    var removeOfferTapped: ((OfferCardListView) -> Void?)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        setupOfferCollectionView()
        setupAppliedOfferView()
    }
    
    
    //MARK: Setup the constraint
    
    func setupOfferCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        offerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        offerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        offerCollectionView.showsHorizontalScrollIndicator = false
        offerCollectionView.showsVerticalScrollIndicator = false
        offerCollectionView.backgroundColor = .clear
        
        offerCollectionView.register(OfferCardCollectionViewCell.self, forCellWithReuseIdentifier: OfferCardCollectionViewCell.identifier)
        
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(offerView)
        mainStackView.addArrangedSubview(appliedContainerOuterView)
        offerView.addSubview(offerCollectionView)
        offerView.addSubview(offerImg)
        offerView.addSubview(offerTitle)
        
        offerImg.tintColor = .orange_colour
    
        offerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            offerView.heightAnchor.constraint(equalToConstant: 164)
        ])
        
        NSLayoutConstraint.activate([
            
            offerImg.leadingAnchor.constraint(equalTo: offerView.leadingAnchor,constant: 0),
            offerImg.centerYAnchor.constraint(equalTo: offerTitle.centerYAnchor),
            offerImg.heightAnchor.constraint(equalToConstant: 20),
            offerImg.widthAnchor.constraint(equalToConstant: 20),
            
            offerTitle.leadingAnchor.constraint(equalTo: offerImg.trailingAnchor,constant: 6),
            offerTitle.heightAnchor.constraint(equalToConstant: 22),
            offerTitle.topAnchor.constraint(equalTo: offerView.topAnchor,constant: 11),
        ])
      
        NSLayoutConstraint.activate([
            offerCollectionView.topAnchor.constraint(equalTo: offerTitle.bottomAnchor,constant: 11),
            offerCollectionView.bottomAnchor.constraint(equalTo: offerView.bottomAnchor),
            offerCollectionView.leadingAnchor.constraint(equalTo: offerView.leadingAnchor),
            offerCollectionView.trailingAnchor.constraint(equalTo: offerView.trailingAnchor),
        ])
    }
    
    func setupAppliedOfferView() {
        removeAppliedOfferBtn.addTarget(self, action: #selector(actionOnRemoveOffer(_:)), for: .touchUpInside)

        appliedContainerOuterView.addSubview(containerView)
        containerView.addSubview(appliedLabel)
        containerView.addSubview(applledOfferValueLabel)
        containerView.addSubview(removeAppliedOfferBtn)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: appliedContainerOuterView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: appliedContainerOuterView.leadingAnchor, constant: 0),
            containerView.centerYAnchor.constraint(equalTo: appliedContainerOuterView.centerYAnchor),
            containerView.bottomAnchor.constraint(equalTo: appliedContainerOuterView.bottomAnchor, constant: 0),
            appliedContainerOuterView.heightAnchor.constraint(equalToConstant: 32),
        ])
       
        NSLayoutConstraint.activate([
            appliedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            appliedLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            appliedLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            appliedLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
            
            applledOfferValueLabel.leadingAnchor.constraint(equalTo: appliedLabel.trailingAnchor, constant: 6),
            applledOfferValueLabel.centerYAnchor.constraint(equalTo: appliedLabel.centerYAnchor),
            
            removeAppliedOfferBtn.leadingAnchor.constraint(equalTo: applledOfferValueLabel.trailingAnchor, constant: 2),
            removeAppliedOfferBtn.centerYAnchor.constraint(equalTo: applledOfferValueLabel.centerYAnchor,constant: -1),
            removeAppliedOfferBtn.heightAnchor.constraint(equalToConstant: 23),
            removeAppliedOfferBtn.widthAnchor.constraint(equalToConstant: 23),
            removeAppliedOfferBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5)
        ])
    }
    
    // MARK: - Button Actions
    
    /// Handles the action when the remove offer button is tapped.
    ///
    /// - Parameter sender: The button that triggered the action.
    @objc func actionOnRemoveOffer(_ sender: UIButton) {
        removeOfferTapped?(self)
        setOfferViewConstraint(isOfferAdded: false)
    }

    // MARK: - Other funtion

    /// Configures the view with the provided data and sets the offer view constraint.
    ///
    /// - Parameters:
    ///   - data: An optional array of `CardOffers` to be displayed.
    ///   - isOfferAdded: A Boolean indicating whether an offer has been added.
    func configureData(data: [CardOffers]?, isOfferAdded: Bool) {
        cardOffers = data
        offerCollectionView.reloadData()
        setOfferViewConstraint(isOfferAdded: isOfferAdded)
    }

    // MARK: - View Constraints

    /// Sets the constraints for the offer view based on whether an offer has been added.
    ///
    /// - Parameter isOfferAdded: A Boolean indicating whether an offer has been added.
    func setOfferViewConstraint(isOfferAdded: Bool) {
        self.appliedContainerOuterView.isHidden = !isOfferAdded
//        self.containerViewBottomConstraints.constant = isOfferAdded ? -12 : 44
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.appliedContainerOuterView.layoutIfNeeded()
        }, completion: nil)
    }
    
    

    
}
