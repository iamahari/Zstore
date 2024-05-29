import Foundation
import UIKit
import CoreData


enum CoreDataResult {
    case success(ProductDetailsType)
    case failure(Error)
}


typealias ProductDetailsType = ([CategoryList],[CardOffers],[ProductsList])

class CoreDataManager  {
    
    static let shared = CoreDataManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init(){}
}



//MARK: fetch the coredata
extension CoreDataManager {
    
    
    /// To fetch the all data form muliple entities
    /// - Returns: Retuen tubles data it's containse product,crad offer, categories
    func fetch() async throws -> ProductDetailsType {
            let data = try await getProducts()
            return data
        }

        private func getProducts() async throws -> ProductDetailsType {
            let productListFetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
            let products = try await context.perform {
                try self.context.fetch(productListFetchRequest)
            }

            let offersFetchRequest: NSFetchRequest<CardOffers> = CardOffers.fetchRequest()
            let offersList = try await context.perform {
                try self.context.fetch(offersFetchRequest)
            }

            let categoriesFetchRequest: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            categoriesFetchRequest.sortDescriptors = [sortDescriptor]
            let categories = try await context.perform {
                try self.context.fetch(categoriesFetchRequest)
            }

            return (categories, offersList, products)
        }

    
    
    /// Fetches products by category ID.
    /// - Parameters:
    ///   - id: The ID of the category to filter products by.
    ///   - isRating: Boolean indicating if the products should be sorted by rating (true) or by price (false).
    /// - Returns: An array of `ProductsList` objects if fetch is successful, otherwise nil.
    func fetchProductById(byID id: String, _ isRating: Bool) -> [ProductsList]? {
        let fetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@", id)
        
        if isRating {
            let sortDescriptor = NSSortDescriptor(key: "rating", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        } else {
            let sortDescriptor = NSSortDescriptor(key: "price", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch products by id: \(error)")
            return nil
        }
    }

    /// Fetches products by name and category ID.
    /// - Parameters:
    ///   - productName: The name of the product to filter by.
    ///   - id: The ID of the category to filter products by.
    ///   - isRating: Boolean indicating if the products should be sorted by rating (true) or by price (false).
    /// - Returns: An array of `ProductsList` objects if fetch is successful, otherwise nil.
    func fetchProductByName(with productName: String, byID id: String, _ isRating: Bool) -> [ProductsList]? {
        let fetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        let categoryPredicate = NSPredicate(format: "categoryId == %@", id)
        let namePredicate = NSPredicate(format: "name CONTAINS[cd] %@", productName)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, namePredicate])
        fetchRequest.predicate = compoundPredicate
        if isRating {
            let sortDescriptor = NSSortDescriptor(key: "rating", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        } else {
            let sortDescriptor = NSSortDescriptor(key: "price", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch products by name: \(error)")
            return nil
        }
    }

    /// Fetches products by card offer ID and category ID.
    /// - Parameters:
    ///   - cardOfferId: The ID of the card offer to filter by.
    ///   - id: The ID of the category to filter products by.
    ///   - isRating: Boolean indicating if the products should be sorted by rating (true) or by price (false).
    /// - Returns: An array of `ProductsList` objects if fetch is successful, otherwise nil.
    func fetchCardOfferById(with cardOfferId: String, byID id: String, _ isRating: Bool) -> [ProductsList]? {
        let fetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        let categoryPredicate = NSPredicate(format: "categoryId == %@", id)
        let cardOfferPredicate = NSPredicate(format: "cardOfferId CONTAINS[cd] %@", cardOfferId)
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, cardOfferPredicate])
        if isRating {
            let sortDescriptor = NSSortDescriptor(key: "rating", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        } else {
            let sortDescriptor = NSSortDescriptor(key: "price", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        fetchRequest.predicate = combinedPredicate
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results, "res", results.count)
            return results
        } catch {
            print("Failed to fetch products by cardOfferId: \(error)")
            return nil
        }
    }

    /// Updates the favorite status of a product.
    /// - Parameters:
    ///   - productId: The ID of the product to update.
    ///   - isFav: The new favorite status.
    ///   - isRating: Boolean indicating if the products should be sorted by rating (true) or by price (false).
    /// - Returns: A string indicating success or error message.
    func updateIsFav(for productId: String, to isFav: Bool, _ isRating: Bool) -> String? {
        let fetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", productId)
        if isRating {
            let sortDescriptor = NSSortDescriptor(key: "rating", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        } else {
            let sortDescriptor = NSSortDescriptor(key: "price", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }

        do {
            let results = try context.fetch(fetchRequest)
            
            if let product = results.first {
                product.isFav = isFav
                try context.save()
                return ""
            } else {
                return "No product found for product ID"
            }
        } catch {
            return "Failed to fetch or update product"
        }
    }

    
}






// MARK: Store the API value to Core Data
extension CoreDataManager {
    
    
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
    
    
    private func storeProducts(products : [Products]){
        products.forEach({ product in
            let products = ProductsList(context: context)
            products.id = product.id
            products.cardOfferId = product.cardOfferIDS.joined(separator: ",")
            products.colors = product.colors?.joined(separator: ",")
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
}
