//
//  Invite.swift
//
//
//  Created by Pranav Karnani on 23/03/20.
//

import Foundation

class Invite: Codable {
    let email: String
    let acl: [String:[String]]
    let type : String
    
    init(email: String, acl: [String:[String]],type:EmployeeType ) {
        self.email = email
        self.acl = acl
        self.type = type.rawValue
    }
}

class UpdateACL : Codable {
    let employeeId : String
    let acl : [String:[String]]
    
    init(employeeId: String, acl: [String:[String]]) {
        self.acl = acl
        self.employeeId = employeeId
    }
}

enum EmployeeType : String, CaseIterable{
    case employee = "employee"
    case representative = "representative"
    case director = "director"
    case executive = "executive"
}

class InviteResponse: Codable {
    let success: Bool
    let message: String
    
    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}

struct ACL: Codable {
    let success: Bool?
    let message: String?
    let accessControlList: AccessControlList?
}

// MARK: - AccessControlList
struct AccessControlList: Codable {
    let trailer, upsell, insurance, servicing: [String]?
    let reminders, financials, documents, rentalstatus: [String]?
    let block, employees: [String]?
    
    enum CodingKeys: String, CodingKey {
        case trailer = "TRAILER"
        case upsell = "UPSELL"
        case insurance = "INSURANCE"
        case servicing = "SERVICING"
        case reminders = "REMINDERS"
        case financials = "FINANCIALS"
        case documents = "DOCUMENTS"
        case rentalstatus = "RENTALSTATUS"
        case block = "BLOCK"
        case employees = "EMPLOYEES"
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "TRAILER" : trailer,
            "UPSELL" : upsell,
            "INSURANCE" : insurance,
            "SERVICING" : servicing,
            "REMINDERS" : reminders,
            "FINANCIALS" : financials,
            "DOCUMENTS" : documents,
            "RENTALSTATUS": rentalstatus,
            "BLOCK": block,
            "EMPLOYEES": employees
        ]
    }
}

extension AccessControlList: PropertyReflectable {}

protocol PropertyReflectable { }

extension PropertyReflectable {
    subscript(key: String) -> Any? {
        let m = Mirror(reflecting: self)
        for child in m.children {
            if child.label == key { return child.value }
        }
        return nil
    }
}
