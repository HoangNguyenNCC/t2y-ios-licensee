//
//  Charges.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

struct Charges : Codable{
    var totalPayableAmount : Double?
    var trailerCharges : TotalCharges?
    var upsellCharges : [upsellCharge]?
    
    func totalTaxes()->Double{
    
        var taxes = trailerCharges?.taxes ?? 0.0
           
        if let upsellTaxes = upsellCharges{
            let upsellTax = upsellTaxes.map { ($0.charges?.taxes ?? 0.0) * Double($0.quantity ?? 1)}.reduce(0, +)
               taxes += upsellTax
           }
           
           return taxes
       }
       
       func totalDlr()->Double{
           var damage = trailerCharges?.dlrCharges ?? 0.0
            if let upsellDlrs = upsellCharges{
                let upsellDlr = upsellDlrs.map { ($0.charges?.dlrCharges ?? 0.0) * Double($0.quantity ?? 1) }.reduce(0, +)
                damage += upsellDlr
            }
           return damage
       }
    
    func upsellBaseCharges()->[String:Double]{
        if let  upsell = self.upsellCharges {
            var charges = [String:Double]()
            for charge in upsell{
                charges[charge.id ?? ""] = (charge.charges?.rentalCharges ?? 0.0)
            }
            return charges
        } else {
            return [:]
        }
    }
    
}



struct TotalCharges: Codable {
    let total: Double?
    let rentalCharges: Double?
    let dlrCharges: Double?
    let t2yCommission, discount, lateFees: Double?
    let cancellationCharges : Double?
    let taxes : Double?
}

struct upsellCharge : Codable {
    var charges : TotalCharges?
    var id : String?
    var quantity : Int?
}

struct TotalChargesString: Codable {
    let total: String?
    let rentalCharges: String?
    let dlrCharges: String?
    let t2yCommission, discount, lateFees: String?
}

// MARK: - TotalByTypeList
class TotalByTypeList: Codable {
    let rentedItem, rentedItemId, rentedItemName: String
    let rentedItemPhoto: String
    let total: Double
    
    enum CodingKeys: String, CodingKey {
        case rentedItem
        case rentedItemId
        case rentedItemName, rentedItemPhoto, total
    }
    
    init(rentedItem: String, rentedItemId: String, rentedItemName: String, rentedItemPhoto: String, total: Double) {
        self.rentedItem = rentedItem
        self.rentedItemId = rentedItemId
        self.rentedItemName = rentedItemName
        self.rentedItemPhoto = rentedItemPhoto
        self.total = total
    }
}

@objcMembers class RentalCharges: NSObject, Codable {
    var pickUp, door2Door: [Door2Door]
    
    init(pickUp: [Door2Door], door2Door: [Door2Door]) {
        self.pickUp = pickUp
        self.door2Door = door2Door
    }
}

// MARK: - Door2Door
@objcMembers class Door2Door: NSObject, Codable {
    var duration, charges: Int
    
    init(duration: Int, charges: Int) {
        self.duration = duration
        self.charges = charges
    }
}

struct ChargesRequestModel : Codable {
    var trailerId : String
    var upsellItems : [String]
    var startDate : String
    var endDate : String
    var isPickup : Bool = false
}

