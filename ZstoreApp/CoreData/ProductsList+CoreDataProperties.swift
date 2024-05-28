import Foundation
import CoreData


extension ProductsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductsList> {
        return NSFetchRequest<ProductsList>(entityName: "ProductsList")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var reviewCount: Int64
    @NSManaged public var price: Double
    @NSManaged public var categoryId: String?
    @NSManaged public var cardOfferId: [String]?
    @NSManaged public var imageUrl: String?
    @NSManaged public var productDescription: String?

}

extension ProductsList : Identifiable {

}
