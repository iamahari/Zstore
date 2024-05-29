//
//  ViewController.swift
//  Zstore
//
//  Created by Hari Prakash on 24/05/24.
//

import UIKit


class HomeVC: UIViewController {
    
    // MARK: Create the UI components
    private let titleBarView: TitleBarView = {
        let view = TitleBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let removeAppliedOfferBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("×", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var containerView = AppUIComponents.createView(cornerRadius: 15,borderWidth: 1,borderColor: UIColor.blue.cgColor)
    private var appliedLabel = AppUIComponents.createLabel(text: "Applied: ",fontSize: 15)
    private var applledOfferValueLabel = AppUIComponents.createLabel(text: "",fontSize: 15)
    private var offerImg = AppUIComponents.createImageView(image: UIImage(systemName: "bolt.fill"),tintColor: .orangeColour)
    private var offerTitle = AppUIComponents.createLabel(text: "Offers")
    private var offerView = AppUIComponents.createView()
    var categoryCollectionView: UICollectionView!
    var productCollectionView: UICollectionView!
    
    private var filterImageView = AppUIComponents.createImageView(image: UIImage(systemName:  "filter_icon"))
    private var blurView = AppUIComponents.createView(backgroundColor: .blur_view_color)
    var filterView = AppUIComponents.createView(cornerRadius: 23)
    var filterOptionStackView = AppUIComponents.createStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 1)
    var filterTitleLabel = AppUIComponents.createLabel(text: "Filter Order: From Top to Bottom ",textColor: .description_colour, font: AppFont.font(with: 13, family: FontType.medium))
    var ratingOptionView = AppUIComponents.getFilterOptionView(leftImage: UIImage(named: "rating_icon")!, title: "Rating", rightImage: UIImage(named: "selected_icon")!, tag: 1)
    var priceOptionView = AppUIComponents.getFilterOptionView(leftImage: UIImage(named: "price_icon")!, title: "Price", rightImage: UIImage(named: "unselected_icon")!, tag: 2)
    
    
    
    //MARK: Create Constraint
    var catagoryCollectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    var layout: WaterfallLayout!
    weak var headerView: OfferCardListView?
    var viewModel = HomeVM()
    
    
    //MARK: override function
    override func viewDidLoad()  {
        super.viewDidLoad()
        self.view.backgroundColor = .whiteColour
        setupConstraintTitleBarView()
        setupConstraintCatagoryCollectionView()
        setupCollectionView()
        setupViewProductCillectionVIewContraints()
        
        bindUI()
        changeProductCollectionViewTopConstraint(to: -35)
        setupFilterView()
        Task {
            await viewModel.fetchProductDetailsAPI()
        }
        FullScreenLoader.shared.startLoading()
               
               // Simulate some asynchronous task
               DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                   // Call stopLoading to hide the loader
                   FullScreenLoader.shared.stopLoading()
               }
    }
    
    
    //MARK: Setup the constraint
    private func setupCollectionView() {
        layout = WaterfallLayout()
        layout.numberOfColumns = 2
        layout.delegate = self
        let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout:createLayout())
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        productCollectionView = searchCollectionView
        registerCollectionViewCells()
        self.view.addSubview(searchCollectionView)
    }
    
    // MARK: Setup the constraint
    func setupConstraintTitleBarView() {
        self.view.addSubview(titleBarView)
        titleBarView.setTitle("Zstore")
        titleBarView.delegate = self
        NSLayoutConstraint.activate([
            titleBarView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            titleBarView.heightAnchor.constraint(equalToConstant: 44),
            titleBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            titleBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }
    
    func setupConstraintCatagoryCollectionView() {
        categoryCollectionView = AppUIComponents.createCollectionView(layout: createCategoryLayoutSection(),dataSource: self, delegate: self,cellClass: CategoryCollectionViewCell.self,
                                                                      reuseIdentifier: CategoryCollectionViewCell.identifier )
        view.addSubview(categoryCollectionView)
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: titleBarView.bottomAnchor, constant: 12),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
        categoryCollectionView.isScrollEnabled = false
        catagoryCollectionViewHeightConstraint = categoryCollectionView.heightAnchor.constraint(equalToConstant: 74)
        catagoryCollectionViewHeightConstraint.isActive = true
    }
    
    
    private func registerCollectionViewCells() {
        productCollectionView.register(WaterFallLayoutCollectionViewCell.self, forCellWithReuseIdentifier: WaterFallLayoutCollectionViewCell.reuseIdentifier)
        productCollectionView.register(LinearCollectionViewCell.self, forCellWithReuseIdentifier: LinearCollectionViewCell.reuseIdentifier)
        productCollectionView.register(OfferCardListView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OfferCardListView.reuseIdentifier)
    }
    
    private func setupViewProductCillectionVIewContraints() {
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productCollectionView.backgroundColor = .white_colour
        NSLayoutConstraint.activate([
            
            productCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant:  10),
            productCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            productCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            productCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        productCollectionView.reloadData()
    }
    
    func setupFilterView() {
        blurView.isHidden = true
        filterView.isHidden = true
        view.addSubview(blurView)
        view.addSubview(filterImageView)
        view.addSubview(filterView)
        filterView.addSubview(filterTitleLabel)
        filterView.addSubview(ratingOptionView)
        filterView.addSubview(priceOptionView)
        
        NSLayoutConstraint.activate([
            filterImageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16),
            filterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterImageView.heightAnchor.constraint(equalToConstant: 50),
            filterImageView.widthAnchor.constraint(equalToConstant: 50 ),
            
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            blurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            blurView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            
            filterView.bottomAnchor.constraint(equalTo: filterImageView.topAnchor, constant: -16),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterView.widthAnchor.constraint(equalToConstant: 320),
            filterView.heightAnchor.constraint(equalToConstant: 147),
            
            filterTitleLabel.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -10),
            filterTitleLabel.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 10),
            filterTitleLabel.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 10),
            
            
            ratingOptionView.topAnchor.constraint(equalTo: filterTitleLabel.bottomAnchor, constant: 10),
            ratingOptionView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 0),
            ratingOptionView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: 0),
            
            priceOptionView.topAnchor.constraint(equalTo: ratingOptionView.bottomAnchor, constant: 0),
            priceOptionView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 0),
            priceOptionView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: 0),
            priceOptionView.bottomAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 0)
        ])
        filterImageView.isUserInteractionEnabled = true
        filterView.backgroundColor = .filter_view_color
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterImageTapped))
        filterImageView.addGestureRecognizer(tapGesture)
        let ratingGesture = UITapGestureRecognizer(target: self, action: #selector(ratingViewTapped))
        ratingOptionView.addGestureRecognizer(ratingGesture)
        let priceGesture = UITapGestureRecognizer(target: self, action: #selector(priceViewTapped))
        priceOptionView.addGestureRecognizer(priceGesture)
    }
    
    
    /// To create a custom layout in a linear cell
    /// - Returns: Retuen the custome linear cell layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            
            let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [item1])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            // Create header size
            if viewModel.showCardList {
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading
                )
                section.boundarySupplementaryItems = [sectionHeader]
            }
            section.interGroupSpacing = 8
            return section
        }
    }
    
    func createCategoryLayoutSection() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(30), heightDimension: .absolute(32)))
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .none, trailing: .fixed(6), bottom: .none)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            return section
        }
    }
    
    //MARK: Button Action
    @objc func actionOnRemoveOffer(_ sender: UIButton) {
        changeProductCollectionViewTopConstraint(to: -35)
        viewModel.selectedCardOffer = nil
        applledOfferValueLabel.text = ""
    }
    
    @objc func ratingViewTapped(_ gesture: UITapGestureRecognizer) {
        setFilterOption(isRating: true)
        viewModel.isFilterByRating = true
        viewModel.filterByCardOfferID(with: viewModel.selectedCardOffer?.id)
    }
    
    @objc func priceViewTapped(_ gesture: UITapGestureRecognizer) {
        setFilterOption(isRating: false)
        viewModel.isFilterByRating = false
        viewModel.filterByCardOfferID(with: viewModel.selectedCardOffer?.id)
    }
    
    @objc func filterImageTapped() {
        showOrHideFilterView(show: blurView.isHidden)
    }
    
    @objc func showOrHideFilterView(show: Bool) {
        blurView.isHidden = !show
        filterView.isHidden = !show
    }
    
    
    //MARK: Other function
    
    /// Changes the top constraint of the product collection view with animation.
    ///
    /// - Parameter constant: The new constant value for the top constraint.
    func changeProductCollectionViewTopConstraint(to constant: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// Updates the height of the category collection view based on its content.
    func updateCollectionViewHeight() {
        categoryCollectionView.layoutIfNeeded()
        let contentHeight = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
        catagoryCollectionViewHeightConstraint.constant = contentHeight
    }
    
    /// Sets the filter option for either rating or price.
    ///
    /// - Parameter isRating: A Boolean value indicating whether the filter option is for rating.
    func setFilterOption(isRating: Bool) {
        if let leftImageView = ratingOptionView.subviews.first(where: { $0.tag == 1 }) as? UIImageView {
            leftImageView.image = (isRating) ? UIImage(named: "selected_icon") :  UIImage(named: "unselected_icon")
            print("Rating tapped")
        }
        if let leftImageView = priceOptionView.subviews.first(where: { $0.tag == 2 }) as? UIImageView {
            print("Price tapped")
            leftImageView.image = (!isRating)  ? UIImage(named: "selected_icon") :  UIImage(named: "unselected_icon")
        }
    }
    
    
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int, with width: CGFloat) -> CGFloat {
        
        if !viewModel.showCardList {
            return 0
        } else {
            return 176 + (viewModel.isOfferSelected ? 44 : 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if viewModel.isWaterFallLayout {
            let isEvenCell = indexPath.row % 2 == 0
            var cellHeight: CGFloat = isEvenCell ? 300 : 350
            if !(viewModel.products?[indexPath.row].isFav ?? false) {
                cellHeight += 50
            }
            cellHeight += 30
            return cellHeight
        } else {
            return 200
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case  self.categoryCollectionView:
            return viewModel.categorys?.count ?? 0
        case self.productCollectionView:
            return viewModel.products?.count ?? 0
        default:
            return viewModel.showCardList ? (viewModel.cardOffers?.count ?? 0) : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case  self.categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            if let category = viewModel.categorys?[indexPath.row] {
                cell.configure(with: category,with: self.viewModel.searchValue?.isEmpty == false,count: viewModel.products?.count ?? 0,with: indexPath.row == viewModel.selectedCategoryIndex)
            }
            return cell
        case productCollectionView:
            if viewModel.isWaterFallLayout {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterFallLayoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WaterFallLayoutCollectionViewCell
                if let product = viewModel.products?[indexPath.row] {
                    cell.updateCell(product: product,with: viewModel.selectedCardOffer)
                }
                cell.indexPath = indexPath
                cell.titleLabel.numberOfLines = (indexPath.row%2 == 0) ? 2 : 0
                cell.descriptionLabel.numberOfLines = (indexPath.row%2 == 0) ? 2 : 0
                cell.actionOnCallBack = { [weak self] isFav in
                    self?.viewModel.products?[cell.indexPath?.row ?? 0].isFav = isFav
                    self?.productCollectionView.reloadItems(at: [indexPath])
                    
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LinearCollectionViewCell.reuseIdentifier, for: indexPath) as! LinearCollectionViewCell
                if let product = viewModel.products?[indexPath.row] {
                    cell.updateCell(product: product,with: viewModel.selectedCardOffer)
                }
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCardCollectionViewCell.identifier, for: indexPath) as! OfferCardCollectionViewCell
            guard let cardOffer = viewModel.cardOffers?[indexPath.item] else {
                return UICollectionViewCell()
            }
            var color = [CGColor]()
            if indexPath.row < viewModel.listOfGradientColor.count{
                color =  viewModel.listOfGradientColor[indexPath.row]
            }
            
            cell.configure(with: cardOffer,gradientColor: color )
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == productCollectionView,
           kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OfferCardListView.reuseIdentifier, for: indexPath) as! OfferCardListView
            headerView.offerCollectionView.delegate = self
            headerView.offerCollectionView.dataSource = self
            headerView.configureData(data:  viewModel.cardOffers, isOfferAdded: viewModel.isOfferSelected)
            headerView.applledOfferValueLabel.text = viewModel.selectedCardOffer?.cardName
            headerView.removeOfferTapped = { [weak self] view in
                self?.viewModel.isOfferSelected.toggle()
                self?.productCollectionView.collectionViewLayout.invalidateLayout()
                self?.productCollectionView.reloadData()
                self?.viewModel.filterByCardOfferID(with: nil)
                
            }
            self.headerView = headerView
            headerView.isHidden = !viewModel.showCardList
            return headerView
        }
        return UICollectionReusableView()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case  self.categoryCollectionView:
            return .zero
        default:
            return viewModel.showCardList ? CGSize(width: view.frame.size.width - 90, height: 130) : .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView:
            viewModel.actionOnSelectedCategory(index: indexPath.row)
        case productCollectionView:
            break
        default:
            viewModel.isOfferSelected = true
            headerView?.applledOfferValueLabel.text = viewModel.cardOffers?[indexPath.row].cardName
            viewModel.selectedCardOffer = viewModel.cardOffers?[indexPath.row]
            viewModel.filterByCardOfferID(with: viewModel.cardOffers?[indexPath.row].id ?? "")
            productCollectionView.collectionViewLayout.invalidateLayout()
            self.productCollectionView.reloadData()
            
        }
        
        func getHeaderCollectionView() -> OfferCardListView? {
            guard let headerView = productCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OfferCardListView.reuseIdentifier, for: IndexPath(row: 0, section: 0)) as? OfferCardListView else { return nil}
            return headerView
        }
    }
}

extension HomeVC: TitleBarViewDelegate {
    
    func didUpdateSearchResults(_ searchText: String) {
        print("searchText ====> \(searchText)")
        viewModel.filterProductBySearch(with: searchText)
        if !searchText.isEmpty {
            viewModel.showCardList = false
        }
        
    }
    
    func didCancelSearch() {
        viewModel.showCardList = true
        viewModel.searchValue = ""
        viewModel.filterProductBySearch(with: viewModel.searchValue ?? "")
    }
    
    /// Method to change waterfall or linear layout
    func switchCollectionLayout() {
        //todo
        productCollectionView.collectionViewLayout.invalidateLayout()
        if viewModel.isWaterFallLayout {
            productCollectionView.setCollectionViewLayout(layout, animated: false, completion: {_ in
                self.productCollectionView.setContentOffset(.zero, animated: false)
            })
        } else {
            productCollectionView.setCollectionViewLayout(createLayout(), animated: false, completion: {_ in
                self.productCollectionView.setContentOffset(.zero, animated: false)
            })
        }
        self.productCollectionView.reloadData()
    }
    
    
}


//MARK: To refresh the UI compenent

extension HomeVC {
    
    private func bindUI() {
        
        
        viewModel.categorysService.bind { [unowned self] newValue in
            //            let (firstValue, secondValue) = newValue
            
            self.categoryCollectionView.reloadData()
            
            self.updateCollectionViewHeight()
        }
        
        viewModel.cardOfferSerview.bind { [unowned self] cardOffer in
            guard let cardOffer = cardOffer else {
                changeProductCollectionViewTopConstraint(to: -30)
                containerView.isHidden = true
                return
            }
            changeProductCollectionViewTopConstraint(to: 10)
            applledOfferValueLabel.text = cardOffer.cardName
            containerView.isHidden = false
            
        }
        
        viewModel.productSerview.bind {  [unowned self] isSearchFilter in
            if isSearchFilter {
                productCollectionView.reloadData()
            }else {
                switchCollectionLayout()
            }
            
        }
        
        viewModel.apiService.bind { [unowned self] in
            var loader: FullScreenLoader?
            switch $0 {
            case .loading:
                print("Start Loading")
                DispatchQueue.main.async {
                    loader?.startLoading()
                }
                
            case .populated:
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                }
            case .error(let error):
                print("Fascing the error")
                
            }
        }
        
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
