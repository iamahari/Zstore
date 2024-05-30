//
//  UIImageView+Extension.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import UIKit


extension UIImageView {
    
    
    /// To load the url image
    /// - Parameter url: image URl
    func loadImage(from url: URL) {
        let cacheKey = url.absoluteString
        
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
            
    
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        dataTask.resume()
    }
}
