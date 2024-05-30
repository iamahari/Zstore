//
//  HomeVM.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import Foundation
import UIKit


class HomeVM {
    typealias IntPair = (Int?, Int?)
    
    //MARK: Call back service
    var apiService = Box<LoadState>(.loading)
    var categorysService =  Box<IntPair>((0,0))
    var productSerview = Box<Bool>(false)
    
    //MARK: Variable
    var isFilterByRating = true
    var isWaterFallLayout = true
    var isOfferSelected = false
    var showCardList = true
    var coredate = CoreDataManager.shared
    var selectedCategoryIndex = 0
    var products: [ProductsList]?
    var categorys: [CategoryList]?
    var cardOffers: [CardOffers]?
    var selectedCardOffer: CardOffers?
    var searchValue: String?
    var listOfGradientColor = [[UIColor(hex: "#1A7EDA").cgColor,
                                UIColor(hex: "#2BD1FF").cgColor],
                               [UIColor(hex: "#FFA61E").cgColor, 
                                UIColor(hex: "#FD5261").cgColor],
                               [UIColor(hex: "#F02374").cgColor,
                                UIColor(hex: "#F51AEC").cgColor]]
    
    /// Performs actions when a category is selected.
    ///
    /// - Parameter index: The index of the selected category.
    func actionOnSelectedCategory(index: Int) {
        let lastSelectedIndex = selectedCategoryIndex
        selectedCategoryIndex = index
        categorysService.value = (selectedCategoryIndex, lastSelectedIndex)
        self.isWaterFallLayout = categorys?[index].layout == "waterfall"
        filterByCardOfferID(with: selectedCardOffer?.id)
    }

    /// Filters products based on user search input.
    ///
    /// - Parameter userInput: The user's search input.
    func filterProductBySearch(with userInput: String) {
        searchValue = userInput
        
        if userInput.isEmpty {
            showCardList = true
            filterByCardOfferID(with: selectedCardOffer?.id)
        } else {
            if let products = coredate.fetchProductByName(with: userInput, byID: categorys?[selectedCategoryIndex].id ?? "", isFilterByRating) {
                self.products = products
                productSerview.value = true
                showCardList = false
            } else {
                apiService.value = .error("Product not found.")
            }
        }
        categorysService.value = (selectedCategoryIndex, nil)
    }

    /// Filters products by category ID.
    ///
    /// - Parameter categoryId: The ID of the category.
    func categoryFilteredProduct(categoryId: String) {
        if let products = coredate.fetchProductById(byID: categoryId, isFilterByRating) {
            self.products = products
        } else {
            apiService.value = .error("Product not found.")
        }
        
        productSerview.value = false
    }

    /// Filters products by card offer ID.
    ///
    /// - Parameter cardId: The ID of the card offer.
    func filterByCardOfferID(with cardId: String?) {
        guard let cardId = cardId else {
            selectedCardOffer = nil
            categoryFilteredProduct(categoryId: categorys?[selectedCategoryIndex].id ?? "")
            return
        }
        if let products = coredate.fetchCardOfferById(with: cardId, byID: categorys?[selectedCategoryIndex].id ?? "", isFilterByRating) {
            self.products = products
        } else {
            apiService.value = .error("Product not found.")
        }
        productSerview.value = false
    }

    /// Updates the favorite list for a product.
    ///
    /// - Parameters:
    ///   - productId: The ID of the product.
    ///   - isFav: A Boolean value indicating whether the product is marked as favorite.
    func updateFavList(with productId: String, isFav: Bool) {
        if let isFavAdd = coredate.updateIsFav(for: productId, to: isFav, isFilterByRating) {
            if !isFavAdd.isEmpty {
                apiService.value = .error(isFavAdd)
            }
        }
    }
}


// MARK: API Call

extension HomeVM {
    
    func fetchProductDetailsAPI() async{
        apiService.value = .loading
        
        do {
            let fetchedData = try await ProductDataManager.fetch()
            let (categories,offers,_) = fetchedData
            DispatchQueue.main.async {
                self.cardOffers = offers
                self.categorys = categories
                self.categoryFilteredProduct(categoryId: categories[self.selectedCategoryIndex].id ?? "")
                self.apiService.value = .populated
            }
            
        } catch {
            apiService.value = .error("Error fetching data: \(error)")
        }
    }
    
}

