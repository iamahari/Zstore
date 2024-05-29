import Foundation

class ProductDataManager {
    
    
    static func fetch() async throws -> ProductDetailsType {
        guard Reachability.isConnectedToNetwork() else {
            throw NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No network connection"])
        }

        do {
            let data = try await CoreDataManager.shared.fetch()

            if data.0.isEmpty {
                let productDetails = try await ProductApiManager.shared.fetch()
                try await CoreDataManager.shared.storeProducts(productData: productDetails)
                let newData = try await CoreDataManager.shared.fetch()
                return newData
            } else {
                return data
            }
        } catch {
            throw error
        }
    }
}
