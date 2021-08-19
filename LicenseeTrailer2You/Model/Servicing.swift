//
//  Servicing.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 13/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

// MARK: - ServicingRequest
@objcMembers class AddService: NSObject, Codable {
    var name, serviceDate: String
    var nextDueDate : String
    var document: String

    enum CodingKeys: String, CodingKey {
        case name, serviceDate, nextDueDate, document
    }

    init(name: String, serviceDate: String, nextDueDate: String, document: String) {
        self.name = name
        self.serviceDate = serviceDate
        self.nextDueDate = nextDueDate
        self.document = document
    }
}
