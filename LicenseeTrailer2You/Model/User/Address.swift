//
//  Address.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

struct AddressRequest : Codable {
    var country: String?
    var text: String?
    var pincode: String?
    var coordinates : [Double]?
    var city : String?
    var state : String?
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "country" : country,
            "text" : text,
            "pincode" : pincode,
            "coordinates" : coordinates,
            "city" : city,
            "state" : state
        ]
    }
}

class Address: Codable {
    let text, pincode: String
    let coordinates: [Double]
    let state : String
    let city : String

    init(text: String, pincode: String, coordinates: [Double],city:String,state:String) {
        self.text = text
        self.pincode = pincode
        self.coordinates = coordinates
        self.city = city
        self.state = state
    }
}


class LoginAddress: Codable {
    let text, pincode: String
    let coordinates: [Double]

    init(text: String, pincode: String, coordinates: [Double],city:String,state:String) {
        self.text = text
        self.pincode = pincode
        self.coordinates = coordinates
    }
}


class TestAddress: Codable {
    let coordinates: [Double]

    init(coordinates: [Double]) {
        self.coordinates = coordinates
    }
}
