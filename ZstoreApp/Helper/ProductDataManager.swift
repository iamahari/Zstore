import Foundation

class ProductDataManager {

    
    func fetch(completion : @escaping (productDetailsType?,Error?)->()){
        let isReachable = Reachability.isConnectedToNetwork()
        if(isReachable){
            ProductApiManager.shared.fetch { result in
                switch result {
                case .success(let productDetails) :
                    DispatchQueue.main.async {
                        ProductLocalDataManager.shared.storeProducts(productData: productDetails)
                        ProductLocalDataManager.shared.fetch { result in
                            switch result {
                            case .success(let data) :
                                completion(data,nil)
                            case .failure(let error) :
                                completion(nil,error)
                            }
                        }
                        
                    }
                case .failure(let error):
                    completion(nil,error)
                }
            }
        }else{
            ProductLocalDataManager.shared.fetch { result in
                switch result {
                case .success(let data) :
                    completion(data,nil)
                case .failure(let error) :
                    completion(nil,error)
                }
            }
        }
    }
}
