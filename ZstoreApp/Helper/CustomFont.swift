//
//  CustomFont.swift
//  Zstore
//
//  Created by Hari Prakash on 24/05/24.
//

import Foundation
import UIKit


typealias AppFont = UIFont


enum FontType: FontFamily {
    case regular
    case bold
    case medium
    case semibold
    var value: String {
        switch self {
        case .regular: return "SFProText-Regular"
        case .bold: return "SFProDisplay-Bold"
        case .medium: return "SFProText-Medium"
        case .semibold: return "SFProText-Semibold"
        }
    }
}


extension AppFont {
    static func font(with size: CGFloat, family: FontFamily?) -> AppFont {
        guard let family = family,
              let requiredFont = UIFont(name: family.value, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return requiredFont
    }
}
