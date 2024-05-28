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
    
    
    //MARK: Create Constraint
    var catagoryCollectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    var layout: WaterfallLayout!
    var isOfferSelected = false
    var showCardList = true
    weak var headerView: OfferCardListView?
    var viewModel = HomeVM()
    
    
    //MARK: override function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .whiteColour
        setupConstraintTitleBarView()
        setupConstraintCatagoryCollectionView()
        setupCollectionView()
        setupViewProductCillectionVIewContraints()
        viewModel.fetchProductDetailsAPI()
        bindUI()
        changeProductCollectionViewTopConstraint(to: -35)
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 10
        categoryCollectionView = AppUIComponents.createCollectionView(layout: layout,dataSource: self, delegate: self,cellClass: CategoryCollectionViewCell.self,
                 reuseIdentifier: CategoryCollectionViewCell.identifier )
        view.addSubview(categoryCollectionView)
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: titleBarView.bottomAnchor, constant: 5),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        catagoryCollectionViewHeightConstraint = categoryCollectionView.heightAnchor.constraint(lessThanOrEqualToConstant:  80)
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
    
    
    
    /// To create a custom layout in a linear cell
    /// - Returns: Retuen the custome linear cell layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))

            let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [item1])
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            // Create header size
            if showCardList {
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
    
    //MARK: Button Action
    @objc func actionOnRemoveOffer(_ sender: UIButton) {
        changeProductCollectionViewTopConstraint(to: -35)
        viewModel.selectedCardOffer = nil
        applledOfferValueLabel.text = ""
    }
    
    //MARK: Other function
    func changeProductCollectionViewTopConstraint(to constant: CGFloat) {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    
    func updateCollectionViewHeight() {
        categoryCollectionView.layoutIfNeeded()
        let contentHeight = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
        catagoryCollectionViewHeightConstraint.constant = contentHeight
    }


}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int, with width: CGFloat) -> CGFloat {
           
            if !showCardList {
                print("Header height >>>>>>>> 0)")
                return 0
            } else {
                print("Header height >>>>>>>> \( 176 + (isOfferSelected ? 44 : 0)))")
                return 176 + (isOfferSelected ? 44 : 0)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        if viewModel.isWaterFallLayout {
            let isEvenCell = indexPath.row % 2 == 0
            var cellHeight: CGFloat = isEvenCell ? 300 : 350
            if !(viewModel.productDetails?.products?[indexPath.row].isFav ?? false) {
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
            return showCardList ? (viewModel.productDetails?.cardOffers?.count ?? 0) : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case  self.categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            if let category = viewModel.categorys?[indexPath.item] {
                cell.configure(with: category)
            }
            return cell
        case productCollectionView:
            if viewModel.isWaterFallLayout {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterFallLayoutCollectionViewCell.reuseIdentifier, for: indexPath) as! WaterFallLayoutCollectionViewCell
                cell.product = viewModel.products?[indexPath.row]
                if let product = viewModel.products?[indexPath.row] {
                    cell.updateCell(product: product)
                }
                
                cell.titleLabel.numberOfLines = (indexPath.row%2 == 0) ? 2 : 0
                cell.descriptionLabel.numberOfLines = (indexPath.row%2 == 0) ? 2 : 0
                cell.delegate = self
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LinearCollectionViewCell.reuseIdentifier, for: indexPath) as! LinearCollectionViewCell
                cell.product = viewModel.products?[indexPath.row]
                if let product = viewModel.products?[indexPath.row] {
                    cell.updateCell(product: product)
                }
                cell.delegate = self
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferCardCollectionViewCell.identifier, for: indexPath) as! OfferCardCollectionViewCell
            guard let cardOffer = viewModel.productDetails?.cardOffers?[indexPath.item] else {
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
                headerView.configureData(data:  viewModel.productDetails?.cardOffers, isOfferAdded: isOfferSelected)
                headerView.applledOfferValueLabel.text = viewModel.selectedCardOffer?.cardName
                headerView.removeOfferTapped = { view in
                    self.isOfferSelected.toggle()
                    self.productCollectionView.collectionViewLayout.invalidateLayout()
                    self.productCollectionView.reloadData()
                }
                self.headerView = headerView
                print("headerView refreshed ***********************")
                headerView.isHidden = !showCardList
                return headerView
            }
            return UICollectionReusableView()
            
        }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            switch collectionView {
            case  self.categoryCollectionView:
                let text = viewModel.productDetails?.category?[indexPath.row].name ?? ""
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                label.text = text
                label.sizeToFit()
                let width = label.frame.width
                return CGSize(width: width + 20, height: label.frame.height + 14)
                
            default:
                return showCardList ? CGSize(width: view.frame.size.width - 90, height: 130) : .zero
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView:
            print(indexPath.row)
            viewModel.actionOnSelectedCategory(index: indexPath.row)
        case productCollectionView:
           break
        default:
            isOfferSelected = true
            headerView?.applledOfferValueLabel.text = viewModel.cardOffers?[indexPath.row].cardName
            viewModel.selectedCardOffer = viewModel.cardOffers?[indexPath.row]
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
    }
    
    func didCancelSearch() {
        switchCollectionLayout()
    }
    
    /// Method to change waterfall or linear layout
    func switchCollectionLayout() {
        productCollectionView.collectionViewLayout.invalidateLayout()
        if viewModel.isWaterFallLayout {
            productCollectionView.setCollectionViewLayout(layout, animated: false, completion: {_ in 
                self.productCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
        } else {
            productCollectionView.setCollectionViewLayout(createLayout(), animated: false)
        }
        self.productCollectionView.reloadData()
    }


}

extension HomeVC: OfferListViewDelegate {
    func removeSelectedOffer() {
        viewModel.selectedCardOffer = nil
        self.productCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension HomeVC: ProductCollectionViewCellDelegate {
    
    func addOrRemoveFromFavList<T: UICollectionViewCell>(isAdd: Bool, _ cell: T) {
        if let indexPath = productCollectionView.indexPath(for: cell) {
            viewModel.productDetails?.products?[indexPath.row].isFav.toggle()
            productCollectionView.collectionViewLayout.invalidateLayout()
            productCollectionView.reloadData()
        }
    }
    
    
    func addOrRemoveFromFavList(isAdd: Bool,_ cell: WaterFallLayoutCollectionViewCell) {
        
    }
}


//MARK: To refresh the UI compenent

extension HomeVC {
    
    private func bindUI() {
        
        
        viewModel.categorysService.bind { newValue in
            let (firstValue, secondValue) = newValue
            if let SelectedIndex = firstValue {
                self.categoryCollectionView.reloadItems(at: [IndexPath(row: SelectedIndex, section: 0)])
                //                self.filtterCollectionView.reloadData()
            }
            if let lastSelectedIndex = secondValue {
                self.categoryCollectionView.reloadItems(at: [IndexPath(row: lastSelectedIndex, section: 0)])
            }
        }
        
        viewModel.cardOfferSerview.bind { [self] cardOffer in
            guard let cardOffer = cardOffer else {
                changeProductCollectionViewTopConstraint(to: -30)
                containerView.isHidden = true
                return
            }
            changeProductCollectionViewTopConstraint(to: 10)
            applledOfferValueLabel.text = cardOffer.cardName
            containerView.isHidden = false
            
        }
        
        viewModel.productSerview.bind {  [unowned self] isLoad in
//
            switchCollectionLayout()
        }
      
        viewModel.apiService.bind { [unowned self] in
            switch $0 {
            
            case .loading:
                print("Start Loading")
            case .populated:
                print("populate the value")
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                    self.productCollectionView.reloadData()
//                    self.offerCollectionView.reloadData()

                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    DispatchQueue.main.async {
                        self.categoryCollectionView.reloadData()
//                        self.offerCollectionView.reloadData()
                        self.updateCollectionViewHeight()
//                        self.offerCollectionView.reloadData()
                    }
                })
                
            case .error:
                print("Fascing the error")
                
            }
        }
        
    }
   
}
