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
        button.titleLabel?.font = UIFont(name: FontType.medium.value, size: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        addSubview(offerView)
        offerView.addSubview(offerCollectionView)
        offerView.addSubview(offerImg)
        offerView.addSubview(offerTitle)
        offerImg.tintColor = .orange_colour
        
        offerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            offerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            offerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            offerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            offerView.heightAnchor.constraint(equalToConstant: 164)
        ])
        
        NSLayoutConstraint.activate([
            
            offerImg.leadingAnchor.constraint(equalTo: offerView.leadingAnchor,constant: 0),
            offerImg.topAnchor.constraint(equalTo: offerView.topAnchor,constant: 12),
            offerImg.heightAnchor.constraint(equalToConstant: 20),
            offerImg.widthAnchor.constraint(equalToConstant: 20),
            offerTitle.leadingAnchor.constraint(equalTo: offerImg.trailingAnchor,constant: 10),
            offerTitle.centerYAnchor.constraint(equalTo: offerImg.centerYAnchor)
                
        ])
      
        NSLayoutConstraint.activate([
            offerCollectionView.leadingAnchor.constraint(equalTo: offerView.leadingAnchor),
            offerCollectionView.trailingAnchor.constraint(equalTo: offerView.trailingAnchor),
            offerCollectionView.topAnchor.constraint(equalTo: offerTitle.bottomAnchor,constant: 11),
            offerCollectionView.bottomAnchor.constraint(equalTo: offerView.bottomAnchor),
        ])
    }
    
    func setupAppliedOfferView() {
        removeAppliedOfferBtn.addTarget(self, action: #selector(actionOnRemoveOffer(_:)), for: .touchUpInside)

        addSubview(containerView)
        containerView.addSubview(appliedLabel)
        containerView.addSubview(applledOfferValueLabel)
        containerView.addSubview(removeAppliedOfferBtn)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: offerView.bottomAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: removeAppliedOfferBtn.trailingAnchor, constant: 10),
            containerView.heightAnchor.constraint(equalToConstant: 32),
        ])
        containerViewBottomConstraints = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        containerViewBottomConstraints.isActive = true
        NSLayoutConstraint.activate([
            appliedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            appliedLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            applledOfferValueLabel.leadingAnchor.constraint(equalTo: appliedLabel.trailingAnchor, constant: 5),
            applledOfferValueLabel.centerYAnchor.constraint(equalTo: appliedLabel.centerYAnchor),
            removeAppliedOfferBtn.leadingAnchor.constraint(equalTo: applledOfferValueLabel.trailingAnchor, constant: 5),
            removeAppliedOfferBtn.centerYAnchor.constraint(equalTo: applledOfferValueLabel.centerYAnchor),
            removeAppliedOfferBtn.heightAnchor.constraint(equalToConstant: 14),
            removeAppliedOfferBtn.widthAnchor.constraint(equalToConstant: 14),

        ])
    }
    
    //MARK: Button Action
    
    @objc func actionOnRemoveOffer(_ sender: UIButton) {
        print("Removed offer")
        removeOfferTapped?(self)
        setOfferViewConstraint(isOfferAdded: false)
    }
    
    
    //MARK: Other Function
    
    func configureData(data: [CardOffers]?, isOfferAdded: Bool) {
        cardOffers = data
        offerCollectionView.reloadData()
        setOfferViewConstraint(isOfferAdded: isOfferAdded)
       
    }
    
    func setOfferViewConstraint(isOfferAdded: Bool) {
        self.containerView.isHidden = !isOfferAdded
        self.containerViewBottomConstraints.constant = isOfferAdded ? -12 : 44
        UIView.animate(withDuration: 0.5,delay: 0, options: .curveEaseInOut, animations: {
            self.containerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    

    
}
