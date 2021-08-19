//
//  Invoice.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 05/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class Invoice: Codable {
    let success: Bool?
    let message: String?
    let rentalObj: RentalObj?

    init(success: Bool?, message: String?, rentalObj: RentalObj?) {
        self.success = success
        self.message = message
        self.rentalObj = rentalObj
    }
}

struct RentalObj: Codable {
    let total: Double?
    let isTrackingPickUp, isTrackingDropOff: Bool?
    let isApproved: Int?
    let rentalStatus, _id: String?
    let transactionAuthAmount, transactionActionAmount: Int?
    let approvedBy: String?
    let rentedItems: [RentedItem]?
    let doChargeDLR: Bool?
    let rentalPeriod: RentalPeriod?
    let description: String?
    let pickUpLocation: LoginAddress?
    let licenseeId: String?
    let dropOffLocation: LoginAddress?
    let bookedByUserId: String?
    let isPickUp: Bool?
    let totalCharges: TotalCharges?
    let invoiceNumber: Int?
    let invoiceReference: String?
    let revisions: [Revision]?
    let invoiceId: String?
    let bookedByUser: UserDetails?
    let userRating : Int?
    
    func calculateCharges(_ row : Int)->Double{
        let revision = revisions?.last?.charges
        if row == 0{
            return (revision?.trailerCharges?.total ?? 0.0)
        } else{
            let upsell = revision?.upsellCharges![row-1]
            let upsellCharge = (upsell?.charges?.total ?? 0.0)*Double(upsell?.quantity ?? 1)
            return upsellCharge
        }
    }
}

struct Revision: Codable {
    let revisionType: String?
    let isApproved: Int?
    let approvedBy: String?
    let transactionAmount: Int?
    let id, start, end, requestOn: String?
    let requestUpdatedOn: String?
    let totalCharges: TotalCharges?
    let approvedOn: String?
    let charges : Charges?

    enum CodingKeys: String, CodingKey {
        case revisionType, isApproved, approvedBy, transactionAmount
        case id = "revisionId"
        case start, end, requestOn, requestUpdatedOn, totalCharges, approvedOn, charges
    }
}

// MARK: - RentalPeriod
class RentalPeriod: Codable {
    let start, end: String?

    init(start: String?, end: String?) {
        self.start = start
        self.end = end
    }
}

// MARK: - RentedItem
class RentedItemDetails: Codable {
    let units: Int?
    let id, itemType, itemID: String?
    let totalCharges: TotalCharges?
    let rentedItemType, itemName: String?
    let itemPhoto: String?

    enum CodingKeys: String, CodingKey {
        case units
        case id = "_id"
        case itemType
        case itemID = "itemId"
        case totalCharges, rentedItemType, itemName, itemPhoto
    }

    init(units: Int?, id: String?, itemType: String?, itemID: String?, totalCharges: TotalCharges?, rentedItemType: String?, itemName: String?, itemPhoto: String?) {
        self.units = units
        self.id = id
        self.itemType = itemType
        self.itemID = itemID
        self.totalCharges = totalCharges
        self.rentedItemType = rentedItemType
        self.itemName = itemName
        self.itemPhoto = itemPhoto
    }
}

class UserDetails: Codable {
    let name, mobile: String?
    let photo: Photo?
    let address: LoginAddress?
    let driverLicense: DriverLicenseInvoice?

    init(name: String?, mobile: String?, photo: Photo?, address: LoginAddress?, driverLicense: DriverLicenseInvoice?) {
        self.name = name
        self.mobile = mobile
        self.photo = photo
        self.address = address
        self.driverLicense = driverLicense
    }
}


class DriverLicenseInvoice: Codable {
    let verified: Bool?
    let id, card: String?
    let accepted: Bool?
    let expiry, state: String?
    let scan: Photo?

    enum CodingKeys: String, CodingKey {
        case verified
        case id = "_id"
        case card, accepted, expiry, state, scan
    }

    init(verified: Bool?, id: String?, card: String?, accepted: Bool?, expiry: String?, state: String?, scan: Photo?) {
        self.verified = verified
        self.id = id
        self.card = card
        self.accepted = accepted
        self.expiry = expiry
        self.state = state
        self.scan = scan
    }
}
