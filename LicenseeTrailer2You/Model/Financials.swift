//
//  Financials.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation


class Financials: Codable {
    let success: Bool
    let message: String
    let finances: [FinancialsObj]
    
    init(success: Bool, message: String, finances: [FinancialsObj]) {
        self.success = success
        self.message = message
        self.finances = finances
    }
}

// MARK: - FinancialsObj
class FinancialsObj: Codable {
    var isLicenseePaid : Bool
    var _id:  String
    var adminPayment : AdminPayment?
    var customerId:  String
    var licenseeId:  String
    var bookingId:  String
    var rentalId:  String
    var incoming : [incomingAmount]
    var outgoing : [incomingAmount]
    var trailerDetails : TrailerDetail
    
    func calculatePrice()->Double{
        if self.isLicenseePaid {
            return self.adminPayment?.transfer.amount ?? 0.0
        } else {
            let income = self.incoming.map{ $0.amount }.reduce(0, +)
            let out = self.outgoing.map{ $0.amount }.reduce(0, +)
            return income - out
        }
    }
}

class AdminPayment : Codable{
    var remarks : String
    var transfer : Transfer
}

class Transfer : Codable {
    var amount : Double
}

class TrailerDetail : Codable {
    var _id : String
    var name : String
    var photos : [Photo]
}


class incomingAmount: Codable{
    var _id : String
    var revisionType : String
    var amount : Double
    var revisedAt : String
}
