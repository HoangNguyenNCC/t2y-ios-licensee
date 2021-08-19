//
//  SignUp.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class SignUp: Codable {
    let employee: Employee
    let licensee: Licensee
    
    init(employee: Employee, licensee: Licensee) {
        self.employee = employee
        self.licensee = licensee
    }
}

// MARK: - Employee
class Employee: Codable {
    let name: String
    let mobile: String
    let email : String
    let password: String?
    let photo: String
    let dob : String
    let driverLicense: DriverLicense
    var address : AddressRequest
    
    init(name: String, mobile: String, email: String, password: String?, photo: String,dob : String ,driverLicense: DriverLicense, address : AddressRequest ) {
        self.name = name
        self.mobile = mobile
        self.email = email
        self.password = password
        self.photo = photo
        self.driverLicense = driverLicense
        self.address = address
        self.dob = dob
    }
}

// MARK: - Licensee
class Licensee: Codable {
    var name, email, mobile: String?
    var address: Address?
    var proofOfIncorporation, logo: String
    var workingDays: [String]
    var workingHours: String?
    var bsbNumber, accountNumber,taxId: String?
    var country: String?
    var businessType: String?
    
    
    init(name: String?, email: String?, mobile: String?, address: Address?, proofOfIncorporation: String, logo: String, bsbNumber: String?,accountNumber: String?, workingDays: [String]?, workingHours: String?, country: String?,businessType:String?) {
        self.name = name
        self.email = email
        self.mobile = mobile
        self.address = address
        self.proofOfIncorporation = proofOfIncorporation
        self.logo = logo
        self.bsbNumber = bsbNumber
        self.accountNumber = accountNumber
        self.workingDays = workingDays ?? []
        self.workingHours = workingHours
        self.country = country
        self.businessType = businessType
    }
 
    //TODO
//    var params : [String:String] {
//        let param =  [
//            "reqBody[licensee][name]": name ?? "",
//            "reqBody[licensee][email]": email ?? "",
//            "reqBody[licensee][mobile]": mobile ?? "",
//            "reqBody[licensee][country]": country ?? "",
//            "reqBody[licensee][businessType]": businessType ?? "",
//            "reqBody[licensee][address][text]": address?.text ?? "",
//            "reqBody[licensee][address][pincode]": address?.pincode,
//            "reqBody[licensee][address][coordinates][0]": address?.coordinates.first?.StringValue ?? "",
//            "reqBody[licensee][address][coordinates][1]": address?.coordinates.last?.StringValue ?? "",
//            "reqBody[licensee][address][city]": address?.city ?? "",
//            "reqBody[licensee][address][state]": address?.state ?? "",
//            "reqBody[licensee][address][country]": country ?? "",
//            "reqBody[licensee][bsbNumber]": bsbNumber ?? "",
//            "reqBody[licensee][accountNumber]": accountNumber ?? "",
//            "reqBody[licensee][url]": "YOLO", //TODO,
//            "reqBody[licensee][taxId]": taxId ?? "",
//            "reqBody[licensee][workingHours]": workingHours ?? ""
//            ] as [String:String]
//
//        return param
//    }
    
    
    
}


struct OTPVerification: Codable {
    var mobile: String?
    var country: String?
    var otp: String?
    var user: String?
}

struct OTPResend: Codable {
    var mobile: String?
    var country: String?
    var user: String?
}

struct EmailVerification : Codable {
    var email: String?
    var user: String?
}


class Employee2: Codable {
    let name: String
    let mobile: String
    let email : String
    let password: String?
    let dob : String
    let driverLicense: DriverLicense
    var address : AddressRequest
    
    init(name: String, mobile: String, email: String, password: String?,dob : String ,driverLicense: DriverLicense, address : AddressRequest ) {
        self.name = name
        self.mobile = mobile
        self.email = email
        self.password = password
        self.driverLicense = driverLicense
        self.address = address
        self.dob = dob
    }
}
