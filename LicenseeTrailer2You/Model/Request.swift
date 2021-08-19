//
//  Request.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 23/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class RentalRequest: Codable {
    let success: Bool?
    let message: String?
    let requestList: [RequestList]?

    init(success: Bool?, message: String?, requestList: [RequestList]?) {
        self.success = success
        self.message = message
        self.requestList = requestList
    }
}

class RequestList: Codable {
    let rentalID: String?
    let invoiceNumber: Int?
    let invoiceReference: String?
    let total: Double?
    let deliveryType, rentalPeriodStart, rentalPeriodEnd: String?
    let rentedItems: [RentalItem]?
    let licenseeID, licenseeName: String?
    let licenseeAddress: LoginAddress?
    let customerID, customerName: String?
    let customerPhoto: String?
    let customerAddress: LoginAddress?
    let isApproved: Int?
    let requestType: String?
    let todayPickup, todayDropOff: Bool?
    let revisionId: String?

    enum CodingKeys: String, CodingKey {
        case rentalID = "rentalId"
        case invoiceNumber, invoiceReference, total, deliveryType, rentalPeriodStart, rentalPeriodEnd, rentedItems
        case licenseeID = "licenseeId"
        case licenseeName, licenseeAddress
        case customerID = "customerId"
        case customerName, customerPhoto, customerAddress, isApproved, requestType
        case todayPickup, todayDropOff
        case revisionId
    }

    init(rentalID: String?, invoiceNumber: Int?, invoiceReference: String?, total: Double?, deliveryType: String?, rentalPeriodStart: String?, rentalPeriodEnd: String?, rentedItems: [RentalItem]?, licenseeID: String?, licenseeName: String?, licenseeAddress: LoginAddress?, customerID: String?, customerName: String?, customerPhoto: String?, customerAddress: LoginAddress?, isApproved: Int?, requestType: String?, todayPickup: Bool?, todayDropOff:Bool?, revisionId: String?) {
        self.rentalID = rentalID
        self.invoiceNumber = invoiceNumber
        self.invoiceReference = invoiceReference
        self.total = total
        self.deliveryType = deliveryType
        self.rentalPeriodStart = rentalPeriodStart
        self.rentalPeriodEnd = rentalPeriodEnd
        self.rentedItems = rentedItems
        self.licenseeID = licenseeID
        self.licenseeName = licenseeName
        self.licenseeAddress = licenseeAddress
        self.customerID = customerID
        self.customerName = customerName
        self.customerPhoto = customerPhoto
        self.customerAddress = customerAddress
        self.isApproved = isApproved
        self.requestType = requestType
        self.todayDropOff = todayDropOff
        self.todayPickup = todayPickup
        self.revisionId = revisionId
    }
}

class RentalItem: Codable {
    var name: String?
    var photo: Photo?
    var itemID, itemType: String?

    enum CodingKeys: String, CodingKey {
        case name, photo
        case itemID = "itemId"
        case itemType
    }

    init(name: String?, photo: Photo?, itemID: String?, itemType: String?) {
        self.name = name
        self.photo = photo
        self.itemID = itemID
        self.itemType = itemType
    }
}


class RequestApproval: Codable {
    let rentalId, revisionId, approvalStatus: String?

    enum CodingKeys: String, CodingKey {
        case rentalId
        case revisionId
        case approvalStatus
    }

    init(rentalId: String?, revisionId: String?,  approvalStatus: String) {
        self.rentalId = rentalId
        self.revisionId = revisionId
        self.approvalStatus = approvalStatus
    }
}
