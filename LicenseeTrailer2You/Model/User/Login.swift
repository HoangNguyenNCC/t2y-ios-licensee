//
//  LoginModel.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 13/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import CoreData


// MARK: - Login
class Login: Codable {
    let email, password: String
    let fcmDeviceToken : String
    
    init(email: String, password: String,fcmDeviceToken : String) {
        self.email = email
        self.password = password
        self.fcmDeviceToken = fcmDeviceToken
    }
}

@objcMembers class LoginResponse: Codable {
    let success: Bool
    let message: String
    let employeeObj: EmployeeDetails
    let licenseeObj: LicenseeDetails
    let token: String

    init(success: Bool, message: String, employeeObj: EmployeeDetails, licenseeObj: LicenseeDetails,token: String) {
        self.success = success
        self.message = message
        self.employeeObj = employeeObj
        self.licenseeObj = licenseeObj
        self.token = token
    }
}

// MARK: - EmployeeName


@objcMembers class SignUpResponse: Codable {
    let success: Bool
    let message: String
    let employeeObj: EmployeeDetails
    let licenseeObj: Licensee
    
    init(success: Bool, message: String, employeeObj: EmployeeDetails, licenseeObj: Licensee,token: String) {
        self.success = success
        self.message = message
        self.employeeObj = employeeObj
        self.licenseeObj = licenseeObj
    }
}

@objcMembers class editProfileResponse: Codable {
    let success: Bool
    let message: String
    let employeeObj: Employee2?
    
    init(success: Bool, message: String, employeeObj: Employee2) {
        self.success = success
        self.message = message
        self.employeeObj = employeeObj
    }
}

@objcMembers class editLicenseeResponse: Codable {
    let success: Bool
    let message: String
    let licenseeObj: LicenseeDetails
    
    init(success: Bool, message: String, licensee: LicenseeDetails) {
        self.success = success
        self.message = message
        self.licenseeObj = licensee
    }
}

@objcMembers class ErrorModel: Codable {
    let success: Bool
    let errorsList: [String]

    init(success: Bool, errorsList: [String]) {
        self.success = success
        self.errorsList = errorsList
    }
}

@objcMembers class SuccessModel: Codable {
    let success: Bool
    let message: String

    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}
