//
//  RegEx.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 16/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

enum Alert {
    case success
    case failure
    case error
}

enum Valid {
    case success
    case failure(Alert, AlertMessages)
}

enum ValidationType {
    case email
    case stringWithFirstLetterCaps
    case phoneNo
    case alphabeticString
    case password
}

enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$"
    case phoneNo = "[0-9]{10}"
}

enum AlertMessages: String {
     case inValidEmail = "InvalidEmail"
     case invalidFirstLetterCaps = "First Letter should be capital"
     case inValidPhone = "Invalid Phone"
     case invalidAlphabeticString = "Invalid String"
     case inValidPSW = "Invalid Password"
        
     case emptyPhone = "Empty Phone"
     case emptyEmail = "Empty Email"
     case emptyFirstLetterCaps = "Empty Name"
     case emptyAlphabeticString = "Empty String"
     case emptyPSW = "Empty Password"
    
     func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
     }
}
