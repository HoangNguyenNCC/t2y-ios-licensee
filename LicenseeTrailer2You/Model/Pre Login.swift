//
//  Password.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class ForgotPassword: Codable {
    let email: String
    let platform : String
    
    init(email: String) {
        self.email = email
        self.platform = "ios"
    }
}

class ResetPassword: Codable {
    let token, password: String
    
    init(token: String, password: String) {
        self.token = token
        self.password = password
    }
}

class ChangePassword: Codable {
    let oldPassword, newPassword: String
    
    init(newPassword: String, oldPassword: String) {
        self.newPassword = newPassword
        self.oldPassword = oldPassword
    }
}

class VerifyOTP: Codable {
    let otp, email: String
       
    init(otp: String, email: String) {
        self.otp = otp
        self.email = email
    }
}
