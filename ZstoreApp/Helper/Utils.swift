//
//  Utils.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import UIKit



class Utils {
        
    /// Modifies a given string to include bold and linked text.
      ///
      /// - Parameter originalString: The original string to modify.
      /// - Returns: An optional NSAttributedString with modifications applied.
      static func getModifiedString(_ originalString: String) -> NSAttributedString? {
          var cleanedString = originalString
          
          let receivedString = getBoldAndLinkText(originalString)
          cleanedString = cleanedString.replacingOccurrences(of: receivedString.2, with: "")
          cleanedString = cleanedString.removeSpecialCharacter()
          return modifyString(in: cleanedString, receivedString.0, receivedString.1, receivedString.2)
      }
      
      /// Adds a strikethrough to the given text.
      ///
      /// - Parameter text: The text to modify.
      /// - Returns: A NSMutableAttributedString with a strikethrough applied.
      static func markText(_ text: String) -> NSMutableAttributedString {
          let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
          attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
          return attributeString
      }
      
      /// Modifies the given text by adding bold and link attributes.
      ///
      /// - Parameters:
      ///   - text: The text to modify.
      ///   - boldSubstring: The substring to make bold.
      ///   - linkText: The text to link.
      ///   - linkURL: The URL for the link.
      /// - Returns: An NSAttributedString with the modifications applied.
      static func modifyString(in text: String, _ boldSubstring: String, _ linkText: String, _ linkURL: String) -> NSAttributedString {
          let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor : UIColor.description_colour])
          
          if let boldRange = text.range(of: boldSubstring) {
              let nsRange = NSRange(boldRange, in: text)
              attributedString.addAttribute(.font, value: AppFont.font(with: 13, family: FontType.bold), range: nsRange)
          }
          
          if let linkRange = text.range(of: linkText), let url = URL(string: linkURL) {
              let nsRange = NSRange(linkRange, in: text)
              attributedString.addAttributes([
                  .foregroundColor: UIColor.blue,
                  .underlineStyle: NSUnderlineStyle.single.rawValue,
                  .link: url
              ], range: nsRange)
          }
          
          return attributedString
      }
      
      /// Extracts bold and link text from the given input string.
      ///
      /// - Parameter input: The input string.
      /// - Returns: A tuple to returns bold text, link text, and link URL.
      static func getBoldAndLinkText(_ input: String) -> (String, String, String) {
          let boldPattern = "\\*\\*(.*?)\\*\\*"
          let linkPattern = "\\[(.*?)\\]\\((.*?)\\)"
          
          let regex = try! NSRegularExpression(pattern: "\(boldPattern)|\(linkPattern)", options: [])
          
          var boldText = ""
          var linkText = ""
          var linkURL = ""
          
          let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
          
          for match in matches {
              if let boldRange = Range(match.range(at: 1), in: input) {
                  boldText = String(input[boldRange])
              } else if let linkTextRange = Range(match.range(at: 2), in: input), let linkURLRange = Range(match.range(at: 3), in: input) {
                  linkText = String(input[linkTextRange])
                  linkURL = String(input[linkURLRange])
              }
          }
          return (boldText, linkText, linkURL)
      }
      
      /// Opens a link when a tap gesture is recognized.
      ///
      /// - Parameter gesture: The tap gesture recognizer.
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
              UIApplication.shared.open(linkValue)
          }
      }
  
    static func formatAsIndianCurrency(_ amount: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_IN")
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 0

        let roundedAmount = round(amount)

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
