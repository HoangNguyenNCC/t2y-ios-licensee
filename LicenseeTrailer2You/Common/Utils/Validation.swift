//
//  Validation.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 16/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class Validation: NSObject {
    
    public static let shared = Validation()
    
    func isValidString(text: String, regex: RegEx) -> Bool {
        if text.isEmpty {
            return false
        } else if isValidRegEx(text, regex) != true {
            return false
        }
        return true
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}
