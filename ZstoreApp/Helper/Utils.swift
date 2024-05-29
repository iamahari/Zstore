//
//  Utils.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import UIKit



class Utils {
        
    static func getModifiedString(_ originalString: String) -> NSAttributedString? {
        print("originalString >>>>> \(originalString)")
        var cleanedString = originalString
        
        let receivedString = getBoldAndLinkText(originalString)
        cleanedString = cleanedString.replacingOccurrences(of: receivedString.2, with: "")
        cleanedString = cleanedString.removeSpecialCharacter()
        return modifyString(in: cleanedString, receivedString.0, receivedString.1, receivedString.2 )
    }
    
    static func markText(_ text: String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    static func modifyString(in text: String,_ boldSubstring: String,_  linkText: String,_  linkURL: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor : UIColor.description_colour])
        
        if let boldRange = text.range(of: boldSubstring) {
            let nsRange = NSRange(boldRange, in: text)
            attributedString.addAttribute(.font, value: AppFont.font(with: 13, family: FontType.bold), range: nsRange)
        }
        
        if let boldRange = text.range(of: linkText),
            let URL = URL(string: linkURL) {
            let nsRange = NSRange(boldRange, in: text)
            print("link text added >>>>>>>>>>>>>>>>>>>>>>")
            attributedString.addAttributes([
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .link: linkURL
            
            ], range: nsRange)
            attributedString.accessibilityValue
//            attributedString.setValue(linkURL, forKey: "link_value")
        }
        
        return attributedString
    }
    
    static func getBoldAndLinkText(_ input: String) -> (String, String, String) {
        _ = NSMutableAttributedString(string: "")
        
        let boldPattern = "\\*\\*(.*?)\\*\\*"
        let linkPattern = "\\[(.*?)\\]\\((.*?)\\)"
        
        let regex = try! NSRegularExpression(pattern: "\(boldPattern)|\(linkPattern)", options: [])
        
        var lastIndex = input.startIndex
        
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        print("matches count >>> \(matches.count)")
        var boldText = ""
        var linkText = ""
        var linkURL = ""
        for match in matches {
            if let boldRange = Range(match.range(at: 1), in: input) {
                boldText = String(input[boldRange])
            } else if let linkTextRange = Range(match.range(at: 2), in: input), let linkURLRange = Range(match.range(at: 3), in: input) {
                linkText = String(input[linkTextRange])
                linkURL = String(input[linkURLRange])
//                print("linkText >>> \(linkText)")
            }
        }
        
        print("boldText >>> \(boldText)")
        print("linkText >>> \(linkText)")
        print("linkURL >>> \(linkURL)")
        return (boldText, linkText, linkURL)
    }
    
    static func openLink(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel, let text = label.attributedText else { return }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: text)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        let location = gesture.location(in: label)
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < text.length,
           let linkValue = text.attribute(.link, at: characterIndex, effectiveRange: nil) as? URL {
            // Handle link tap
            UIApplication.shared.open(linkValue)
        }
    }
    
    
    static func formatAsIndianCurrency(_ amount: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_IN")
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0 // Ensure no decimal places are shown

        // Round the double value to the nearest integer
        let roundedAmount = round(amount)

        // Format the rounded value as a currency string
        if let roundedCurrencyString = formatter.string(from: NSNumber(value: roundedAmount)) {
            return roundedCurrencyString
        }
        return nil
    }
   static func calculateDiscountedPrice(_ originalPrice: Double, _ discountPercentage: Double) -> String {
        let discountAmount = originalPrice * (discountPercentage / 100)
        let finalPrice = originalPrice - discountAmount
       return formatAsIndianCurrency(finalPrice.rounded()) ?? ""
    }
    
    static func calculateDiscountSevedPrice(_ originalPrice: Double, _ discountPercentage: Double) -> String {
        let savedPrice = originalPrice * (discountPercentage / 100)
        return formatAsIndianCurrency(savedPrice.rounded()) ?? ""
    }

}
