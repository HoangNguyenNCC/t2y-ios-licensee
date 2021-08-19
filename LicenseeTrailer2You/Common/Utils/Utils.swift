//
//  Utils.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 04/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Utils {

    // MARK: Internet Connection Check
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
         
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }

    // MARK: Alert Window with Style
    static func showAlertMessageWithOkButtonAndTitle(_ strTitle: String, strMessage: String) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        let cancelBttn: UIAlertAction = UIAlertAction(title: Strings.alertCancelBttn, style: .default, handler: nil)
        alertController.addAction(cancelBttn)
        alertController.view.layer.shadowColor = UIColor.black.cgColor
        alertController.view.layer.shadowOpacity = 0.3
        alertController.view.layer.shadowRadius = 5
        alertController.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        alertController.view.layer.masksToBounds = false
        
        return alertController
    }
    
    static func convertToDesiredFormat(sdate: Date) -> String {
        let myFormat = DateFormatter()
        myFormat.dateFormat = "MM-dd"
        return myFormat.string(from: sdate)
    }
}

extension String {
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,50}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
