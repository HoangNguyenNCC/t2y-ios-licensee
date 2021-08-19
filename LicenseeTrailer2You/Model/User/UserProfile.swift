//
//  UserProfile.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 09/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class UserProfile: Codable {
    var success: Bool
    var message: String
    var employeeObj: EmployeeDetails?
    var licenseeObj: ProfileLicensee?

    init(success: Bool, message: String, employeeObj: EmployeeDetails?, licenseeObj: ProfileLicensee?) {
        self.success = success
        self.message = message
        self.employeeObj = employeeObj
        self.licenseeObj = licenseeObj
    }
}

struct ProfileLicensee: Codable {
    var name, mobile, email: String?
    var address: LoginAddress?
    var logo: Photo?
    var proofOfIncorporation: ProofOfIncorporation?
    var workingDays, workingHours: String?
    var payment: Payment?
    var isMobileVerified, isEmailVerified: Bool?
}



struct Payment: Codable {
    var accountNumber, bsbNumber, taxId: String?
}

struct ProofOfIncorporation: Codable {
    var doc: String?
    var dictionaryRepresentation: [String:Any] {
        return [
            "doc":doc
        ]
    }
    
}

struct EditProfile: Codable {
    var email: String?
    var name: String?
    var mobile: String?
    var photo: String?
    var driverLicense: DriverLicense?
    var employeeId: String?
}

class LicenseeDetails: Codable {
    var isMobileVerified, isEmailVerified: Bool?
    var businessType: String?
    var radius: Int?
    var availability: Bool?
    var workingDays: [String]?
    var workingHours, id, mobile: String?
    var proofOfIncorporation: Photo?
    var address: LoginAddress?
    var bsbNumber, accountNumber, email: String?
    var logo: Photo?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case isMobileVerified, isEmailVerified, businessType, radius, availability, workingDays, workingHours
        case id = "_id"
        case mobile, proofOfIncorporation, address, bsbNumber, accountNumber, email, logo, name
    }

    init(isMobileVerified: Bool?, isEmailVerified: Bool?, businessType: String?, radius: Int?, availability: Bool?, workingDays: [String]?, workingHours: String?, id: String?, mobile: String?, proofOfIncorporation: Photo?, address: LoginAddress?, bsbNumber: String?, accountNumber: String?, email: String?, logo: Photo?, name: String?) {
        self.isMobileVerified = isMobileVerified
        self.isEmailVerified = isEmailVerified
        self.businessType = businessType
        self.radius = radius
        self.availability = availability
        self.workingDays = workingDays
        self.workingHours = workingHours
        self.id = id
        self.mobile = mobile
        self.proofOfIncorporation = proofOfIncorporation
        self.address = address
        self.bsbNumber = bsbNumber
        self.accountNumber = accountNumber
        self.email = email
        self.logo = logo
        self.name = name
    }
}

struct DeleteItem: Codable {
    var id: String
}
