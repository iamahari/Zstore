//
//  String+Extension.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import Foundation


extension String {
    
    func removeSpecialCharacter() -> String {
        var removedString = self
        removedString = removedString.replacingOccurrences(of: "**", with: "")
        removedString = removedString.replacingOccurrences(of: "(", with: "")
        removedString = removedString.replacingOccurrences(of: ")", with: "")
        removedString = removedString.replacingOccurrences(of: "[", with: "")
        removedString = removedString.replacingOccurrences(of: "]", with: "")
        
        return removedString
    }
}
