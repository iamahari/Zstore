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

    
    
    func fetchProductById(byID id: String) -> [ProductsList]? {
        let fetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@", id)
        
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch products by id: \(error)")
            return nil
        }
    }
    
    func fetchProductByName(with productName: String,byID id: String) -> [ProductsList]? {
        let fetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        let categoryPredicate = NSPredicate(format: "categoryId == %@", id)
        let namePredicate = NSPredicate(format: "name CONTAINS[cd] %@", productName)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, namePredicate])
        fetchRequest.predicate = compoundPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch products by id: \(error)")
            return nil
        }
    }
    
    func fetchCardOfferById(with cardOfferId: String,byID id: String) -> [ProductsList]? {
        let fetchRequest: NSFetchRequest<ProductsList> = ProductsList.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "categoryId == %@", id)
        let cardOfferPredicate = NSPredicate(format: "cardOfferId CONTAINS[cd] %@", cardOfferId)
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[categoryPredicate,cardOfferPredicate])

        fetchRequest.predicate = combinedPredicate
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results,"res",results.count)
            return results
        } catch {
            print("Failed to fetch products by cardOfferId: \(error)")
            return nil
        }
    }
    
    //    func fetchItemsFormFolder(folderId: Int64) -> [FolderContainerItem] {
    //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
    //
    //        let viewContext = appDelegate.persistentContainer.viewContext
    //
    //        let fetchRequest = NSFetchRequest<FolderContainerEntity>(entityName: "FolderContainerEntity")
    //
    //        let predicate = NSPredicate(format: "id == %@", "\(folderId)")
    //        fetchRequest.predicate = predicate
    //
    //        do {
    //            let folders = try viewContext.fetch(fetchRequest)
    //            let data = folders.map { item in
    //                FolderContainerItem(id: item.id, path: item.path ?? "",type: item.type ?? "", name: item.name ?? "")
    //
    //            }
    //            return data
    //
    //        } catch let error as NSError {
    //            print("Data fetch failed",error)
    //        }
    //
    //        return []
    //    }
    
}






//MARK: To store the value api value to local
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
