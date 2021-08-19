//
//  Get.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class AllItems : Codable {
    var success: Bool?
    var message: String?
    var trailersList: [TrailerObject]?
    var upsellItemsList: [UpsellObject]?
    var employeeList: [EmployeeDetails]?
    
    init(success: Bool, message: String, trailersList: [TrailerObject]?, upsellItemsList: [UpsellObject]?, employeeList: [EmployeeDetails]?) {
        self.success = success
        self.message = message
        self.trailersList = trailersList
        self.upsellItemsList = upsellItemsList
        self.employeeList = employeeList
    }
}

class TrailerObject: Codable {
    let id, adminRentalItemID, name: String?
    let licensee: String?
    let photos: [Photo]?
    let rating: Int?
    let price: String?
    let vin : String?
    let trailerModel : String?
    let trailerAvailability: ItemAvailability?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case adminRentalItemID = "adminRentalItemId"
        case name, licensee, photos, rating, price, trailerAvailability
        case vin, trailerModel
    }

    init(id: String?, adminRentalItemID: String?, name: String?, licensee: String?, photo: Photo?, rating: Int?, price: String?, trailerAvailability: ItemAvailability?,vin:String,trailerModel:String?) {
        self.id = id
        self.adminRentalItemID = adminRentalItemID
        self.name = name
        self.licensee = licensee
        self.photos = [photo ?? Photo()]
        self.rating = rating
        self.price = price
        self.trailerAvailability = trailerAvailability
        self.vin = vin
        self.trailerModel = trailerModel
    }
}

class UpsellObject: Codable {
    let id, name: String?
    let licensee: String?
    let photos: [Photo]?
    let rating: Int?
    let price: String?
    let availability : Bool?
    let upsellItemAvailability: ItemAvailability?
    let adminRentalItemID: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case adminRentalItemID = "adminRentalItemId"
        case name, licensee, photos, rating, price, upsellItemAvailability, availability
    }

    init(id: String?, name: String?, licensee: String?, photos: [Photo]?, rating: Int?, price: String?, upsellItemAvailability: ItemAvailability?, adminRentalItemID: String?,availability:Bool?) {
        self.id = id
        self.name = name
        self.licensee = licensee
        self.photos = photos
        self.rating = rating
        self.price = price
        self.upsellItemAvailability = upsellItemAvailability
        self.adminRentalItemID = adminRentalItemID
        self.availability = availability
    }
}

class ItemAvailability: Codable {
    let availability: Bool?
    let ongoing, upcoming: ItemAvailabilityDetails?

    init(availability: Bool?, ongoing: ItemAvailabilityDetails?, upcoming: ItemAvailabilityDetails?) {
        self.availability = availability
        self.ongoing = ongoing
        self.upcoming = upcoming
    }
}

class ItemAvailabilityDetails: Codable {
    let rentalItemID, invoiceID, startDate, endDate: String?

    enum CodingKeys: String, CodingKey {
        case rentalItemID = "rentalItemId"
        case invoiceID = "invoiceId"
        case startDate, endDate
    }

    init(rentalItemID: String?, invoiceID: String?, startDate: String?, endDate: String?) {
        self.rentalItemID = rentalItemID
        self.invoiceID = invoiceID
        self.startDate = startDate
        self.endDate = endDate
    }
}

class EmployeeList: Codable {
    let acceptedInvite, isOwner, isMobileVerified, isEmailVerified: Bool?
    let id: String?
    let acl: AccessControlList?
    let name, mobile, email, licenseeID: String?
    let photo: Photo?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case acceptedInvite, isOwner, isMobileVerified, isEmailVerified
        case id = "_id"
        case acl, name, mobile, email
        case licenseeID = "licenseeId"
        case photo, createdAt, updatedAt
        case v = "__v"
    }

    init(acceptedInvite: Bool?, isOwner: Bool?, isMobileVerified: Bool?, isEmailVerified: Bool?, id: String?, acl: AccessControlList?, name: String?, mobile: String?, email: String?, licenseeID: String?, photo: Photo?, createdAt: String?, updatedAt: String?, v: Int?) {
        self.acceptedInvite = acceptedInvite
        self.isOwner = isOwner
        self.isMobileVerified = isMobileVerified
        self.isEmailVerified = isEmailVerified
        self.id = id
        self.acl = acl
        self.name = name
        self.mobile = mobile
        self.email = email
        self.licenseeID = licenseeID
        self.photo = photo
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.v = v
    }
}
