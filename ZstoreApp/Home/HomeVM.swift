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
    var apiService = Box<LoadState>(.loading)
    var categorysService =  Box<IntPair>((0,0))
    var cardOfferSerview = Box<CardOffers?>(nil)
    var productSerview = Box<Bool>(false)
    var isFilterByRating = true
    
    
    var listOfGradientColor = [[UIColor(hex: "#1A7EDA").cgColor, UIColor(hex: "#2BD1FF").cgColor],
                               [UIColor(hex: "#FFA61E").cgColor, UIColor(hex: "#FD5261").cgColor],
                               [UIColor(hex: "#F02374").cgColor, UIColor(hex: "#F51AEC").cgColor]]
    
    
    
    var isWaterFallLayout = true
    var isOfferSelected = false
    var showCardList = true
    var coredate = CoreDataManager.shared
    var selectedCategoryIndex = 0
    var products: [ProductsList]?
    var categorys: [CategoryList]?
    var cardOffers: [CardOffers]?
    var selectedCardOffer: CardOffers?
    var searchValue = ""
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     //MARK: Category filler functionality
    func actionOnSelectedCategory(index: Int) {
        let lastSelectedIndex = selectedCategoryIndex
        selectedCategoryIndex = index
        categorysService.value = (selectedCategoryIndex, lastSelectedIndex)
       
        self.isWaterFallLayout = categorys?[index].layout == "waterfall"
        filterByCardOfferID(with: selectedCardOffer?.id)
//        categoryFilteredProduct(categoryId: categorys?[index].id ?? "100023")
    }
    
    func actionOnSelectedOfferCard(_ cardOffer: CardOffers){
        selectedCardOffer = cardOffer
        cardOfferSerview.value = cardOffer
    }

    
    /// Filters the products based on the user input and updates the `products`
    /// - Parameter userInput: The search text entered by the user.
    func filterProductBySearch(with userInput: String) {
        searchValue = userInput
        
        if userInput.isEmpty {
            showCardList = true
            filterByCardOfferID(with: selectedCardOffer?.id)
//            categoryFilteredProduct(categoryId: categorys?[selectedCategoryIndex].id ?? "100023")
            
            
        }else{
            if let products = coredate.fetchProductByName(with: userInput,byID: categorys?[selectedCategoryIndex].id ?? "",isFilterByRating) {
                self.products = products
                productSerview.value = true
                showCardList = false
           }else{
               apiService.value = .error("Product not found.")
           }
        }
        categorysService.value = (selectedCategoryIndex, nil)
    }
    
    func categoryFilteredProduct(categoryId: String) {
        if let products = coredate.fetchProductById(byID: categoryId, isFilterByRating) {
            self.products = products
        } else {
            apiService.value = .error("Product not found.")
        }
        
        productSerview.value = false
    }
    
    func filterByCardOfferID(with cardId: String?){
        guard let cardId = cardId else {
            selectedCardOffer = nil
            categoryFilteredProduct(categoryId: categorys?[selectedCategoryIndex].id ?? "")
            return
        }
        if let products = coredate.fetchCardOfferById(with: cardId,byID: categorys?[selectedCategoryIndex].id ?? "",isFilterByRating) {
            self.products = products
        } else {
            apiService.value = .error("Product not found.")
        }
        productSerview.value = false
    }
    
    func updateFavList(with productId: String,isFav: Bool) {
        
        
        if let isFavAdd = coredate.updateIsFav(for: productId, to: isFav,isFilterByRating) {
            if isFavAdd.isEmpty {
                print("add fav")
            }else{
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

