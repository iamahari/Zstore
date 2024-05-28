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
    var productDetails: ProductDetails?
    var apiService = Box<LoadState>(.loading)
    var categorysService =  Box<IntPair>((0,0))
    var cardOfferSerview = Box<CardOffer?>(nil)
    var productSerview = Box<Bool>(false)
    
    
    var listOfGradientColor = [[UIColor(hex: "#1A7EDA").cgColor, UIColor(hex: "#2BD1FF").cgColor],
                               [UIColor(hex: "#FFA61E").cgColor, UIColor(hex: "#FD5261").cgColor],
                               [UIColor(hex: "#F02374").cgColor, UIColor(hex: "#F51AEC").cgColor]]
    var isWaterFallLayout = false
    var allProducts: [Products]?
    var products: [Products]?
    var categorys: [Category]?
    var cardOffers: [CardOffer]?
    var selectedCardOffer: CardOffer?
    
    
    
//     MARK: Category filler functionality
    
    func actionOnSelectedCategory(index: Int) {
        guard var categorys = categorys else { return }
        
        let lastSelectedIndex = categorys.firstIndex { $0.isSelected == true }
        // MARK: Deselect the previously selected category
        if let lastSelectedIndex = lastSelectedIndex {
            categorys[lastSelectedIndex].isSelected?.toggle()
        }
        // MARK: Select the new category
        categorys[index].isSelected?.toggle()
        categoryFilteredProduct(category: categorys[index])
        self.categorys = categorys
        
        categorysService.value = (index, lastSelectedIndex)
    }
    
    func actionOnSelectedOfferCard(_ cardOffer: CardOffer){
        selectedCardOffer = cardOffer
        cardOfferSerview.value = cardOffer
    }
    
    
    func categoryFilteredProduct(category: Category) {
        
        let filteredProduct = allProducts?.filter({ product in
            product.categoryID == category.id
        })
        
        isWaterFallLayout = category.layout == "waterfall"
        
        products = filteredProduct
        productSerview.value = true
        
    }
    
}


// MARK: API Call

extension HomeVM {
    
    func fetchProductDetailsAPI() {
        apiService.value = .loading
        ProductDataManager().fetch { productDetails, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let (categories,offers,products) = productDetails else {return}
        }
//        guard let url = URL(string: "https://raw.githubusercontent.com/princesolomon/zstore/main/data.json") else { return }
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Data task error: \(error.localizedDescription)")
//                return
//            }
//            guard let data = data else { return }
//            do {
//                let decoder = JSONDecoder()
//                let model = try decoder.decode(ProductDetails.self, from: data)
//                DispatchQueue.main.async {
//                    self.productDetails = model
//                    self.products = model.products
//                    self.allProducts = model.products
//                    self.categorys = model.category
//                    self.cardOffers = model.cardOffers
//                    
//                }
//                self.apiService.value = .populated
//            } catch {
//                print("Decoding error: \(error.localizedDescription)")
//                self.apiService.value = .error
//            }
//        }
//        task.resume()
    }
    
}



