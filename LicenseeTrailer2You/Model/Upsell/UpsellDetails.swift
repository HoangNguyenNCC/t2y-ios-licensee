//
//  Details.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class GetUpsellDetails: Codable {
    var success: Bool?
    var message: String?
    var upsellItemObj: UpsellDetails?
    
    init(success: Bool?, message: String?, upsellItemObj: UpsellDetails?) {
        self.success = success
        self.message = message
        self.upsellItemObj = upsellItemObj
    }
}

class UpsellDetails : Codable {
    var availability: Bool
    var _id, name, description: String
    var photos: [Photo]
    var rating: Int
    var quantity: Int?
    var adminRentalItemId: String?
    var trailerModel : String?

    init(availability: Bool, id: String, name: String, description: String, photos: [Photo], rating: Int, quantity: Int?, adminRentalItemId: String?,trailerModel:String?) {
        self.availability = availability
        self._id = id
        self.name = name
        self.description = description
        self.photos = photos
        self.rating = rating
        self.quantity = quantity
        self.adminRentalItemId = adminRentalItemId
        self.trailerModel = trailerModel
    }
}
