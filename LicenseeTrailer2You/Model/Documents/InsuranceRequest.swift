//
//  InsuranceRequest.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 06/07/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class InsuranceRequest: Codable {
    let success: Bool?
    let message: String?
    let insuranceList: [InsuranceList]?
    
    init(success: Bool?, message: String?, insuranceList: [InsuranceList]?) {
        self.success = success
        self.message = message
        self.insuranceList = insuranceList
    }
}

class InsuranceList: Codable {
    
    let itemType: String?
    let id: String?
    let issueDate: String?
    let expiryDate: String?
    let document: Photo?
    let licenseeId: String?
    let itemId: String?
    let insuranceRef: String?
    
    enum CodingKeys: String, CodingKey {
        case itemType
        case id = "_id"
        case issueDate
        case expiryDate
        case document
        case licenseeId
        case itemId
        case insuranceRef
    }
    
    init(itemType: String?, id: String? , issueDate: String?, expiryDate: String?,document: Photo?, licenseeId: String?, itemId: String?, insuranceRef: String?) {
        self.itemType = itemType
        self.id = id
        self.issueDate = issueDate
        self.expiryDate = expiryDate
        self.document = document
        self.licenseeId = licenseeId
        self.itemId = itemId
        self.insuranceRef = insuranceRef
    }
}
