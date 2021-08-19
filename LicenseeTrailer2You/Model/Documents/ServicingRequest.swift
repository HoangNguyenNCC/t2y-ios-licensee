//
//  ServicingRequest.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 07/07/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class ServicingRequest: Codable {
    let success: Bool?
    let message: String?
    let servicingList: [ServicingList]?
    
    init(success: Bool?, message: String?, servicingList: [ServicingList]?) {
        self.success = success
        self.message = message
        self.servicingList = servicingList
    }
}

class ServicingList: Codable {
    
    let itemType: String?
    let id: String?
    let serviceDate: String?
    let nextDueDate: String?
    let document: Photo?
    let licenseeId: String?
    let itemId: String?
   // let insuranceRef: String?    //TODO
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        case itemType
        case id = "_id"
        case serviceDate
        case nextDueDate
        case document
        case licenseeId
        case itemId
        case name
        //case insuranceRef
    }
    
    init(itemType: String?, id: String? , serviceDate: String?, nextDueDate: String?,document: Photo?, licenseeId: String?, itemId: String?, insuranceRef: String?, name : String?) {
        self.itemType = itemType
        self.id = id
        self.serviceDate = serviceDate
        self.nextDueDate = nextDueDate
        self.document = document
        self.licenseeId = licenseeId
        self.itemId = itemId
        self.name = name
       // self.insuranceRef = insuranceRef
    }
}
