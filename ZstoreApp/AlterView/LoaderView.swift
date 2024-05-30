//
//  AlertView.swift
//  Zstore
//
//  Created by Hari Prakash on 29/05/24.
//

import Foundation
import UIKit

class FullScreenLoader {
    
    static let shared = FullScreenLoader()
    
    private var activityIndicatorView: UIActivityIndicatorView!
    private var overlayBackgroundView: UIView!
    
    
    func setUpLoaderView(viewController: UIViewController) {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .gray
        activityIndicatorView.center = viewController.view.center
        activityIndicatorView.hidesWhenStopped = true
//        overlayBackgroundView = UIView()
//        overlayBackgroundView.frame = viewController.view.frame
//        overlayBackgroundView.backgroundColor = .black
//        overlayBackgroundView.alpha = 0.4
//        overlayBackgroundView.addSubview(activityIndicatorView)
        viewController.view.addSubview(activityIndicatorView)
    }
    
    func startLoading() {
        // Start animating the activity indicator
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func stopLoading() {
        // Stop animating the activity indicator
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
}
