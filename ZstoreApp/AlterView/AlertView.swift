//
//  AlertView.swift
//  Zstore
//
//  Created by Hari Prakash on 29/05/24.
//

import Foundation
import UIKit

class FullScreenLoader: UIView {
    
    static let shared = FullScreenLoader()
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLoader()
    }
    
    private func setupLoader() {
        // Configure activity indicator view
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .gray
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)
        
        // Center activity indicator view
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startLoading() {
        // Start animating the activity indicator
        activityIndicatorView.startAnimating()
        // Show the loader view
        isHidden = false
    }
    
    func stopLoading() {
        // Stop animating the activity indicator
        activityIndicatorView.stopAnimating()
        // Hide the loader view
        isHidden = true
    }
}
