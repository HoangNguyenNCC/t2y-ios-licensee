//
//  Details.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class EmployeeDetails: Codable {
    var acceptedInvite, isOwner, isMobileVerified, isEmailVerified: Bool?
    var isDeleted: Bool?
    var id, mobile, email,country: String?
    var photo: Photo?
    var name: String?
    var driverLicense: DriverLicense?
    var licenseeID: String?
    var acl: AccessControlList?
    var address : EmployeeAddress?
    var ratingCount : Int?
    
    enum CodingKeys: String, CodingKey {
        case acceptedInvite, isOwner, isMobileVerified, isEmailVerified, isDeleted
        case id = "_id"
        case mobile, email, photo, name, driverLicense
        case licenseeID = "licenseeId"
        case acl
        case address
        case country
        case ratingCount
    }
    
    init(acceptedInvite: Bool?, isOwner: Bool?, isMobileVerified: Bool?, isEmailVerified: Bool?, isDeleted: Bool?, id: String?, mobile: String?, email: String?,country : String? ,photo: Photo?, name: String?, driverLicense: DriverLicense?, licenseeID: String?, acl: AccessControlList?, address : EmployeeAddress?,ratingCount:Int?) {
        self.acceptedInvite = acceptedInvite
        self.isOwner = isOwner
        self.isMobileVerified = isMobileVerified
        self.isEmailVerified = isEmailVerified
        self.isDeleted = isDeleted
        self.id = id
        self.mobile = mobile
        self.email = email
        self.photo = photo
        self.name = name
        self.driverLicense = driverLicense
        self.licenseeID = licenseeID
        self.acl = acl
        self.address = address
        self.country = country
        self.ratingCount = ratingCount
    }
}

struct Photo: Codable{
    var contentType : String?
    var data : String?
}

struct DriverLicense : Codable {
    var card: String?
    var expiry: String?
    var state: String?
    var scan: Photo?
}

struct EmployeeAddress : Codable {
    let city: String
    let country: String
    let pincode: String
    let state:String
    let text: String
    let location: EmployeeLocation
}

struct EmployeeAddressResponse : Codable {
    let city: String
    let country: String
    let pincode: String
    let state:String
    let text: String
    let coordinates: EmployeeLocation
}

struct EmployeeLocation : Codable {
    let coordinates: [Double]
}
