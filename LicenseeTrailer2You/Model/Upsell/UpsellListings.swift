//
//  UpsellListings.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 28/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let empty = try? newJSONDecoder().decode(Empty.self, from: jsonData)

import Foundation

// MARK: - Empty
struct UpsellListings: Codable {
    let success: Bool?
    let message: String?
    let upsellItemsList: [UpsellItemsList]?
}

// MARK: - UpsellItemsList
struct UpsellItemsList: Codable {
    let availability, isFeatured: Bool?
    let id, trailerID, name, type: String?
    let upsellItemsListDescription: String?
    let photos: [Photo]?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case availability, isFeatured
        case id = "_id"
        case trailerID = "trailerId"
        case name, type
        case upsellItemsListDescription = "description"
        case photos, createdAt, updatedAt
        case v = "__v"
    }
}
