//
//  Details.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class GetTrailerDetails: Codable {
    var success: Bool
    var message: String
    var trailerObj: TrailerDetails?
    var upsellItemsList: [LinkedUpsell]?

    init(success: Bool, message: String, trailerObj: TrailerDetails?, upsellItemsList: [LinkedUpsell]?) {
        self.success = success
        self.message = message
        self.trailerObj = trailerObj
        self.upsellItemsList = upsellItemsList
    }
}

class TrailerDetails: Codable {
    var features: [String]
    var availability, isFeatured: Bool
    var id, name, vin, type: String
    var description, size, capacity, tare: String
    var age: Int
    var rentalCharges: RentalCharges
    var dlrCharges: Double?
    var licenseeID: String
    var photos: [Photo]
    var createdAt, updatedAt: String
    var rating: Int
    var price: String
    var rentalsList: [RentalsList]
    var insurance: [TrailerInsurance]?
    var servicing: [TrailerService]?
    var adminRentalItemId : String?
    var trailerModel : String?

    enum CodingKeys: String, CodingKey {
        case features, availability, isFeatured
        case id = "_id"
        case name, vin, type
        case description
        case size, capacity, tare, age, rentalCharges, dlrCharges
        case licenseeID = "licenseeId"
        case photos, createdAt, updatedAt
        case rating, price, rentalsList, trailerModel
        case insurance, servicing, adminRentalItemId
    }

    init(features: [String], availability: Bool, isFeatured: Bool, id: String, name: String, vin: String, type: String, description: String, size: String, capacity: String, tare: String, age: Int, rentalCharges: RentalCharges, dlrCharges: Double?, licenseeID: String, photos: [Photo], createdAt: String, updatedAt: String, rating: Int, price: String, rentalsList: [RentalsList], insurance: [TrailerInsurance]?, servicing: [TrailerService]?, adminRentalItemId: String?,trailerModel:String?) {
        self.features = features
        self.availability = availability
        self.isFeatured = isFeatured
        self.id = id
        self.name = name
        self.vin = vin
        self.type = type
        self.description = description
        self.size = size
        self.capacity = capacity
        self.tare = tare
        self.age = age
        self.rentalCharges = rentalCharges
        self.dlrCharges = dlrCharges
        self.licenseeID = licenseeID
        self.photos = photos
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.rating = rating
        self.price = price
        self.rentalsList = rentalsList
        self.insurance = insurance
        self.servicing = servicing
        self.adminRentalItemId = adminRentalItemId
        self.trailerModel = trailerModel
    }
}

struct TrailerInsurance: Codable {
    var _id: String?
    var document: Photo?
    var expiryDate : String
    var issueDate : String
}

struct TrailerService: Codable {
    var _id: String?
    var document: Photo?
    var nextDueDate : String
    var serviceDate : String
    var name : String
    var itemId : String
    var itemType : String
}

class LinkedUpsell: Codable {
    var _id, name, licensee: String
    var photo: Photo
    var rating: Int
    var price: String

    enum CodingKeys: String, CodingKey {
        case _id
        case name, licensee, photo, rating, price
    }

    init(id: String, name: String, licensee: String, photo: Photo, rating: Int, price: String) {
        self._id = id
        self.name = name
        self.licensee = licensee
        self.photo = photo
        self.rating = rating
        self.price = price
    }
}

class RentalsList: Codable {
    var invoiceId: String?
    var bookedByUser: RentingUser?
    var status: String?
    var start, end: String

    init(invoiceId: String?, bookedByUser: RentingUser?, status: String?, start: String, end: String) {
        self.start = start
        self.end = end
        self.invoiceId = invoiceId
        self.bookedByUser = bookedByUser
        self.status = status
    }
}

class RentingUser: Codable {
    var name: String?
    var photo: Photo?
    
    init(name: String?, photo: Photo?) {
        self.name = name
        self.photo = photo
    }
}
