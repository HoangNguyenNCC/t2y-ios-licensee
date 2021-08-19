//
//  BlockRental.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 12/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

struct BlockRental: Codable {
    var id: String?
    var items: [BlockedItem]?
    var startDate: String?
    var endDate: String?
}

struct BlockedItem: Codable {
    var itemType: String?
    var itemId: String?
    var units: Int?
}
