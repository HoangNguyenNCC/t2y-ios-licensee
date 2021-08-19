//
//  Insurance.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 13/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

// MARK: - InsuranceRequest
@objcMembers class AddInsurance: NSObject, Codable {
    var issueDate, expiryDate: String?
    var document: String

    enum CodingKeys: String, CodingKey {
        case issueDate, expiryDate, document
    }

    init(issueDate: String, expiryDate: String, document: String) {
        self.issueDate = issueDate
        self.expiryDate = expiryDate
        self.document = document
    }
}
