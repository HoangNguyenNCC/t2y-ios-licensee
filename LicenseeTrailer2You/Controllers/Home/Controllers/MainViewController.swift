//
//  MainViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 14/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
 
        ServiceController.shared.getUserDetails { (user, status, message) in
            if status {
                DispatchQueue.main.async {
                    print(Defaults.token())
                    self.performSegue(withIdentifier: "fetched", sender: Any?.self)
                }
            } else {
                let token = Defaults.fcmToken()
                let loginDetails = Login(email: Defaults.loginDefaults?.value(forKey: Keys.userEmail) as? String ?? "", password: Defaults.loginDefaults?.value(forKey: Keys.userPassword) as? String ?? "", fcmDeviceToken: token)
                do {
                    let loginObject = try! JSONEncoder().encode(loginDetails)
                            
                    PostController.shared.login(loginObject: loginObject) { (loginResponse, status, error) in
                        if status {
                            if loginResponse?.message == "Please enter valid credentials"{
                                 //TODO login
                            } else {
                            let encoder = JSONEncoder()
                            if let encoded = try? encoder.encode(loginResponse?.employeeObj) {
                                Constant.loginDefaults?.set(encoded, forKey: Keys.userObject)
                            }
                            if let encoded = try? encoder.encode(loginResponse?.licenseeObj) {
                                Constant.loginDefaults?.set(encoded, forKey: Keys.licenseeObject)
                            }
                                    
                            Constant.loginDefaults?.set(true, forKey: Keys.isLoggedIn)
                            Constant.loginDefaults?.set(loginResponse?.token, forKey: Keys.userToken)
                            print(Defaults.token())
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "fetched", sender: Any?.self)
                            }
                            }
                        } else {
                            //TODO login page
                        }
                    }
                }
            }
        }
    }
}
