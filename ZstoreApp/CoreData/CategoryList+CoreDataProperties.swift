import Foundation
import CoreData


extension CategoryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryList> {
        return NSFetchRequest<CategoryList>(entityName: "CategoryList")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var layout: String?

}

extension CategoryList : Identifiable {

}
