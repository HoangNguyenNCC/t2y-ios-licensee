//
//  Constants.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 02/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedContext = appDelegate.persistentContainer.viewContext

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

class Constant {
    public static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    public static let loginDefaults = UserDefaults.init(suiteName: "loginDefaults")
}


enum AppStoryboard: String {
    case main = "Main"
    case login = "Login"
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

class NetworkErrors {
   public static let unknownError = "Unknown Error"
   public static let connectionError = "Not connected to the Internet"
   public static let invalidCredentials = "Invalid Credentials"
   public static let invalidRequest = "Invalid Request"
   public static let notFound = "Resource not found"
   public static let invalidResponse = "Invalid Response"
   public static let serverError = "Server Error"
   public static let serverUnavailable = "Server Error"
   public static let timeOut = "Request timed out"
   public static let unsuppotedURL = "Invalid Request"
}

class Notifications {
    public static let cameraNotification = "CameraPermission"
}

enum VerificationStatus: String {
    case pending = "Pending"
    case verified = "Verified"
}

enum Category : String {
    case trailer = "Trailer"
    case upsell = "Upsell"
}

enum OperationType : String {
    case edit = "edit"
    case add = "add"
    case delete = "delete"
}

func DebugRequest(_ url : String, request : Data, response : Data){
    let req = try? JSONSerialization.jsonObject(with: request)
    let res = try? JSONSerialization.jsonObject(with: response)
    
    print("====================================================")
    print("URL: ",url)
    print("\n")
    print("==============      REQUEST BODY      ==============")
    print("\n")
    print(req)
    print("\n")
    print("==============      RESPONSE BODY     ==============")
    print("\n")
    print(res)
    print("\n")
    print("====================================================")
}

func getDebugRequest(_ url : String, response : Data){
    let res = try? JSONSerialization.jsonObject(with: response)
    
    print("====================================================")
    print("URL: ",url)
    print("\n")
    print("==============      RESPONSE BODY     ==============")
    print("\n")
    print(res)
    print("\n")
    print("====================================================")
}
