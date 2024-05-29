import Foundation

class ProductDataManager {
    
    
    /// Fetches product details, either from Core Data or via an API call, depending on network connectivity and data availability.
    ///
    /// This method to check the steps
    /// 1. Checks for network connectivity.
    /// 2. If Core Data is empty, fetches data from the API, stores it in Core Data, and then re-fetches the data from Core Data.
    ///
    /// - Throws: An error if there is no network connection, or if there are any issues during data fetching or storage.
    /// - Returns: The fetched product details, either from Core Data or from the API.
    ///
    static func fetch() async throws -> ProductDetailsType {
        // Check for network connectivity.
        guard Reachability.isConnectedToNetwork() else {
            throw NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No network connection"])
        }
        
        do {
            let data = try await CoreDataManager.shared.fetch()
            
            if data.0.isEmpty {
                // If Core Data is empty, fetch data from the API and store it in Core Data.
                let productDetails = try await APIDataManager.shared.fetch()
                try await CoreDataManager.shared.storeProducts(productData: productDetails)
                // Re-fetch the data from Core Data after storing the new data.
                let newData = try await CoreDataManager.shared.fetch()
                return newData
            } else {
                return data //retuen core data value
            }
        } catch {
            throw error
        }
    }
}
