//
//  UIButton+Extension.swift
//  Zstore
//
//  Created by Hari Prakash on 29/05/24.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    init(backgroundColor: UIColor, titleAlignment: NSTextAlignment, titleFont: UIFont, titleColor: UIColor, contentInsets: NSDirectionalEdgeInsets, isUserInteractionEnabled: Bool) {
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = backgroundColor
        configuration.contentInsets = contentInsets
        self.configuration = configuration
        
        titleLabel?.textAlignment = titleAlignment
        titleLabel?.font = titleFont
        titleLabel?.textColor = titleColor
        
        translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
