//
//  StringExtensions.swift
//  Mailgun-In-Swift
//
//  Created by Ao Zhang on 21/11/2017.
//  Copyright © 2017 KevinAo. All rights reserved.
//

import Foundation

// MARK: - Extension to remove HTML Attributes from Strings
public extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}



