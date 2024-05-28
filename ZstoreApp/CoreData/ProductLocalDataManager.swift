import Foundation
import UIKit
import CoreData


class ProductLocalDataManager  {
    
    static let shared = ProductLocalDataManager()
    
    func fetch(completion: @escaping (CoreDataResult) -> Void) {
        do {
            let data = try getProducts()
            completion(.success(data))
        }catch{
            completion(.failure(error))
        }
    }

    private func getProducts() throws -> (productDetailsType) {
        let productListFetchRequest  : NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        let products = try context.fetch(productListFetchRequest)
        
        let offersOffersRequest: NSFetchRequest<CardOffers> = CardOffers.fetchRequest()
        let offersList = try context.fetch(offersOffersRequest)
        
        let categoriesFetchRequest: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()
        let catagories = try context.fetch(categoriesFetchRequest )
        
        return (catagories,offersList,products)
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func storeProducts(products : [Products]){
        products.forEach({ product in
            let products = ProductsList(context: context)
            products.id = product.id
            products.cardOfferId = product.cardOfferIDS
            products.categoryId = product.categoryID
            products.productDescription = product.description
            products.imageUrl = product.imageURL
            products.name = product.name
            products.price = product.price
            products.rating = product.rating
            products.reviewCount = Int64(product.reviewCount)
        })
    }
    
    private func storeOffers(offers : [CardOffer]){
        offers.forEach { offer in
            let offers = CardOffers(context: context)
            offers.id = offer.id
            offers.cardName = offer.cardName
            offers.imageUrl = offer.imageURL
            offers.maxDisc = offer.maxDiscount
            offers.offerDesc = offer.offerDesc
            offers.percentage = offer.percentage
            
        }
    }
    
    private func storeCategories(category : [Category]){
        category.forEach({ category in
            let categories = CategoryList(context: context)
            categories.id = category.id
            categories.layout = category.layout
            categories.name = category.name
        })
    }
    
    func storeProducts(productData : ProductDetails){
        
        if let offers = productData.cardOffers{
            storeOffers(offers: offers)
        }
        
        if let categories = productData.category {
            storeCategories(category: categories)
        }
        
        if let products = productData.products {
            storeProducts(products: products)
        }
        do {
            try context.save()
        }catch{
            print("error")
        }
    }
    private init(){}
}

enum CoreDataResult {
    case success(productDetailsType)
    case failure(Error)
}


typealias productDetailsType = ([CategoryList],[CardOffers],[ProductsList])
