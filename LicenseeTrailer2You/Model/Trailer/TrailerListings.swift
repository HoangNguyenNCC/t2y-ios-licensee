//
//  TrailerListings.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 28/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

import Foundation

// MARK: - Empty
struct TrailerListings: Codable {
    let success: Bool?
    let message: String?
    var trailersList: [TrailerSelection]?
}

// MARK: - TrailersList
struct TrailerSelection: Codable {
    let features: [String]?
    let isFeatured, availability: Bool?
    let id, name, type, trailersListDescription, trailerModel: String?
    let size, capacity, tare: String?
    let photos: [Photo]?
    var trailerLicensee : [String]?
    
    enum CodingKeys: String, CodingKey {
        case features, isFeatured, availability
        case id = "_id"
        case name, type
        case trailersListDescription = "description"
        case size, capacity, tare, photos, trailerModel
        case trailerLicensee
    }
}
