//
//  Rating.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 29/10/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation


class RatingResponse: Codable {
    let success: Bool?
    let message: String?
}

class RatingRequest: Codable {
    let rating: Int
    let invoiceId: String
    
    init(rating:Int,invoiceId:String){
        self.rating = rating
        self.invoiceId = invoiceId
    }
}
