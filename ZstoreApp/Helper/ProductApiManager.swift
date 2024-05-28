import Foundation

class ProductApiManager {
    static let shared = ProductApiManager()
    
    private let baseUrl = "https://raw.githubusercontent.com/"
    
    func fetch(completion : @escaping (ProductDettailsApiResult)->()){
        guard let url = URL(string: "\(baseUrl)princesolomon/zstore/main/data.json") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {return}
            let decoder = JSONDecoder()
            do{
                let productData = try decoder.decode(ProductDetails.self, from: data)
                completion(.success(productData))
            }catch{
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    private init(){}
}

enum ProductDettailsApiResult {
    case success(ProductDetails)
    case failure(Error)
}
