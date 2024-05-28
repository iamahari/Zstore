import Foundation
import CoreData


extension CardOffers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardOffers> {
        return NSFetchRequest<CardOffers>(entityName: "CardOffers")
    }

    @NSManaged public var id: String?
    @NSManaged public var percentage: Double
    @NSManaged public var cardName: String?
    @NSManaged public var offerDesc: String?
    @NSManaged public var maxDisc: String?
    @NSManaged public var imageUrl: String?

}

extension CardOffers : Identifiable {

}
