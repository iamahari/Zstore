//
//  UIColor+Extension.swift
//  Zstore
//
//  Created by Hari Prakash on 24/05/24.
//

import UIKit

extension UIColor {
    
    static let gray_color = UIColor(named: "gray_colour")!
    static let orange_colour = UIColor(named: "orange_colour")!
    static let white_colour = UIColor(named: "white_colour")!
    static let black_colour = UIColor(named: "black_colour")!
    static let description_colour = UIColor(named: "description_colour")!
    static let cell_border_color = UIColor(named: "cell_border_color")!
    static let fav_button_text_color = UIColor(named: "fav_button_text_color")!
    static let fav_button_border_color = UIColor(named: "fav_button_border_color")!
    static let green_colour = UIColor(named: "green_colour")!
    static let blue_colour = UIColor(named: "blue_colour")!
    static let blur_view_color = UIColor(named: "blur_view_color")!
    static let filter_view_color = UIColor(named: "filter_view_color")!

    
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0.4...1),
                       green: .random(in: 0.4...1),
                       blue: .random(in: 0.4...1),
                       alpha: 1)
    }
    
    static func  getColor(of color: String) -> UIColor {
        switch color {
            
        case "black":
            return .black_colour
        case "white":
            return .white_colour
        case "gray":
            return .gray_color
        case "silver":
            return .black_colour
        case "maroon":
            return .black_colour
        case "red":
            return .red
        case "purple":
            return .purple
        case "green":
            return .green_colour
        case "yellow":
            return .yellow
        case "blue":
            return .blue
        case "teal":
            return .systemTeal
        
            
        default:
            return .black
        }
    }
}
