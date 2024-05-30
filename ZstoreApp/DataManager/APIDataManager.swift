import Foundation

class APIDataManager {
    static let shared = APIDataManager()
    
    private let baseUrl = "https://raw.githubusercontent.com/"
    
    ///  To ftech the product form API
    /// - Returns: To retuen the result or throws error
    func fetch() async throws -> ProductDetails {
          guard let url = URL(string: "\(baseUrl)princesolomon/zstore/main/data.json") else {
              throw URLError(.badURL)
          }

          var request = URLRequest(url: url)
          request.httpMethod = "GET"

          let (data, response) = try await URLSession.shared.data(for: request)

          guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
              throw URLError(.badServerResponse)
          }

          let decoder = JSONDecoder()
          let productData = try decoder.decode(ProductDetails.self, from: data)
          
          return productData
      }
    
    private init(){}
}

enum ProductDettailsApiResult {
    case success(ProductDetails)
    case failure(Error)
}
