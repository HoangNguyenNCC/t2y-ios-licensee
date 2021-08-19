//
//  Defaults.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 02/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit

class Defaults
{
    static var loginDefaults = Constant.loginDefaults
    
    static func isLoggedIn() -> Bool {
        return loginDefaults?.bool(forKey: Keys.isLoggedIn) ?? false
    }
    
    static func token() -> String {
        return loginDefaults?.string(forKey: Keys.userToken) ?? ""
    }
    
    static func fcmToken() -> String {
        return loginDefaults?.string(forKey: Keys.fcmToken) ?? ""
    }
    
    static func getUserInfo() -> EmployeeDetails? {
        return loginDefaults?.object(forKey: Keys.userObject) as? EmployeeDetails ?? nil
    }
    
    static func userProfilePhoto() -> String {
        return Constant.loginDefaults?.string(forKey: "userProfilePhoto") ?? ""
    }
    
    static func licenseeID() -> String {
        let decoder = JSONDecoder()
        var id = ""
        if let lic = Constant.loginDefaults?.value(forKey: Keys.userObject) as? Data {
            if let employee = try? decoder.decode(EmployeeDetails.self, from: lic) {
                id = employee.licenseeID!
            }
        }
        return id
    }
    
    static func getPrivileges(key: String, access: String) -> Bool {
        let decoder = JSONDecoder()
        var privilege : AccessControlList? = nil
        if let priv = Constant.loginDefaults?.value(forKey: Keys.userObject) as? Data {
            if let employee = try? decoder.decode(EmployeeDetails.self, from: priv) {
                privilege = employee.acl
                print(privilege)
                if let listAccess = privilege?[key] as? [String] {
                    if(listAccess.contains(access)) {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    static let imageCache = NSCache<NSString, UIImage>()

    static func cacheImage(key: String, url: String) -> UIImage? {
        if let image = (self.imageCache.object(forKey: key as NSString)) {
            return image
        } else {
            guard let photo = URL(string: (url)) else { return #imageLiteral(resourceName: "􀉭.png") }
            
            if let data = try? Data(contentsOf: photo) {
                if let image = UIImage(data: data)?.jpeg(.low) {
                    let compressedImage = UIImage(data: image)!
                    imageCache.setObject(compressedImage, forKey: key as NSString)
                    return compressedImage
                } else {
                    if let image = UIImage(data: data) {
                        return image
                    } else {
                        return nil
                    }
                }
            } else {
                return nil
            }
        }
    }
}
