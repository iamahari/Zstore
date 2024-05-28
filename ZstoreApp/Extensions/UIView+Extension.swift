//
//  UIView+Extension.swift
//  Zstore
//
//  Created by Hari Prakash on 24/05/24.
//

import UIKit

extension UIView {
    
    func add(view: UIView, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: right).isActive = true
        
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom).isActive = true
        
    }
    
    func setBorder(borderWidth: CGFloat, color: UIColor) {
        layer.borderWidth  = borderWidth
        layer.borderColor = color.cgColor
    }
    
    func setCornerRadius(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addLinearGradientBackground(colors: [CGColor]) {
            if let sublayers = layer.sublayers {
                for sublayer in sublayers where sublayer is CAGradientLayer {
                    sublayer.removeFromSuperlayer()
                }
            }

            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = colors
            layer.insertSublayer(gradientLayer, at: 0)
        }
}

class GradientViews: UIView {
    
    var gradientColors: [CGColor] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove existing gradient layer if any
        if let sublayers = layer.sublayers {
            for sublayer in sublayers where sublayer is CAGradientLayer {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColors
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
