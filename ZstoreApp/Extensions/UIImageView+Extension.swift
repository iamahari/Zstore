//
//  UIImageView+Extension.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import UIKit


extension UIImageView {
    
    
    /// To load the url image and store to catch image also
    /// - Parameter url: image URl
    func loadImage(from url: URL) {
        let cacheKey = url.absoluteString
        
        // Check if the image is already in the cache
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                return
            }
            
            ImageCache.shared.setImage(downloadedImage, forKey: cacheKey)// Cache the downloaded image
    
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        dataTask.resume()
    }
}


/// To store the catch image
class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
