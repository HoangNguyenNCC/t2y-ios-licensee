//
//  SplashViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 02/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!Defaults.isLoggedIn()) {
            let verification = Defaults.loginDefaults?.value(forKey: Keys.verificationStatus) as? Bool ?? false
            if Defaults.loginDefaults?.value(forKey: Keys.signUpMobile) == nil {
                self.performSegue(withIdentifier: "toLogin", sender: Any?.self)
            }
                //TODO
//            else if verification == false {
//                self.performSegue(withIdentifier: "verificationPending", sender: Any?.self)
//            }
            else {
                self.performSegue(withIdentifier: "toLogin", sender: Any?.self)
            }
        }
    }
}



