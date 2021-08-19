//
//  Add.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit

@objcMembers class AddTrailer: Codable {
    var id: String?
    var name, vin, type, welcomeDescription: String?
    var size, capacity, tare: String?
    var age: Int?
    var photos: [String]?
    var licenseeID: String?
    var insurance: AddInsurance?
    var service: AddService?
    var linkedUpsell: [String]?
    var adminRentalItemId: String?
    var trailerModel : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, vin, type
        case welcomeDescription = "description"
        case size, capacity, tare, age, photos, trailerModel
        case licenseeID = "licenseeId"
        case insurance, service, linkedUpsell
        case adminRentalItemId
    }

    init(id: String?, name: String?, vin: String?, type: String?, description: String?, size: String?, capacity: String?, tare: String?, age: Int?, photos: [String]?, licenseeID: String?, insurance: AddInsurance?, service: AddService?, linkedUpsell: [String]?, adminRentalItemId: String?,trailerModel:String?) {
        self.id = id
        self.name = name
        self.vin = vin
        self.type = type
        self.welcomeDescription = description
        self.size = size
        self.capacity = capacity
        self.tare = tare
        self.age = age
        self.photos = photos
        self.licenseeID = licenseeID
        self.insurance = insurance
        self.service = service
        self.linkedUpsell = linkedUpsell
        self.adminRentalItemId = adminRentalItemId
        self.trailerModel = trailerModel
    }
}

