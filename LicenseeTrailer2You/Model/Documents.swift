//
//  Documents.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 06/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class Documents: Codable {
    let success: Bool
    let message: String
    let documentsList: [DocumentsList]

    init(success: Bool, message: String, documentsList: [DocumentsList]) {
        self.success = success
        self.message = message
        self.documentsList = documentsList
    }
}

// MARK: - DocumentsList
class DocumentsList: Codable {
    let _id, typeOfDocument, licenseeName: String
    let doc: String

    enum CodingKeys: String, CodingKey {
        case _id
        case typeOfDocument, licenseeName, doc
    }

    init(id: String, typeOfDocument: String, licenseeName: String, doc: String) {
        self._id = id
        self.typeOfDocument = typeOfDocument
        self.licenseeName = licenseeName
        self.doc = doc
    }
}
