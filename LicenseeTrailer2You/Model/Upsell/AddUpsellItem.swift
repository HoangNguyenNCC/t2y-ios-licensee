//
//  Add.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

@objcMembers class AddUpsellItem: Codable {
    var _id: String?
    var name: String
    var photos: [String]
    var description : String
    var availability: Bool
    var type: String
    var trailerModel: String?
    var quantity : Int
    var adminRentalItemId: String

    init(_id: String?, name: String, photos: [String], description: String, availability: Bool, type: String, trailerModel: String?, quantity: Int, adminRentalItemId: String) {
        self.name = name
        self.photos = photos
        self.description = description
        self.availability = availability
        self.type = type
        self.trailerModel = trailerModel
        self.quantity = quantity
        self.adminRentalItemId = adminRentalItemId
        self._id = _id
    }
}
