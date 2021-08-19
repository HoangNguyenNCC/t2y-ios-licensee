//
//  Reminder.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 19/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

// MARK: - Reminder
@objcMembers class Reminder: NSObject, Codable {
    let success: Bool
    let message: String
    let remindersList: [RemindersList]?

    init(success: Bool, message: String, remindersList: [RemindersList]?) {
        self.success = success
        self.message = message
        self.remindersList = remindersList
    }
}

class RemindersList: Codable {
    let itemType, itemID, itemName: String?
    let itemPhoto: Photo?
    let reminderType, expiringItemID, expiryDate, statusText: String?
    let reminderColor, invoiceID: String?
    let isPickUp: Bool?
    let pickUpLocation, dropOffLocation: LoginAddress?
    let rentedItems: [RentedItem]?
    let customerName, customerMobile: String?
    let customerAddress: LoginAddress?

    enum CodingKeys: String, CodingKey {
        case itemType
        case itemID = "itemId"
        case itemName, itemPhoto, reminderType
        case expiringItemID = "expiringItemId"
        case expiryDate, statusText, reminderColor
        case invoiceID = "invoiceId"
        case isPickUp, pickUpLocation, dropOffLocation, rentedItems, customerName, customerMobile, customerAddress
    }

    init(itemType: String?, itemID: String?, itemName: String?, itemPhoto: Photo?, reminderType: String?, expiringItemID: String?, expiryDate: String?, statusText: String?, reminderColor: String?, invoiceID: String?, isPickUp: Bool?, pickUpLocation: LoginAddress?, dropOffLocation: LoginAddress?, rentedItems: [RentedItem]?, customerName: String?, customerMobile: String?, customerAddress: LoginAddress?) {
        self.itemType = itemType
        self.itemID = itemID
        self.itemName = itemName
        self.itemPhoto = itemPhoto
        self.reminderType = reminderType
        self.expiringItemID = expiringItemID
        self.expiryDate = expiryDate
        self.statusText = statusText
        self.reminderColor = reminderColor
        self.invoiceID = invoiceID
        self.isPickUp = isPickUp
        self.pickUpLocation = pickUpLocation
        self.dropOffLocation = dropOffLocation
        self.rentedItems = rentedItems
        self.customerName = customerName
        self.customerMobile = customerMobile
        self.customerAddress = customerAddress
    }
}

// MARK: - RentedItem
struct RentedItem: Codable {
    let itemType, itemId, rentedItemType, adminRentalItemId: String?
    let itemName: String?
    let itemPhoto: Photo?
    let totalCharges: TotalCharges?
}
