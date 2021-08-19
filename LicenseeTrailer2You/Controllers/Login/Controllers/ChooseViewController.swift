//
//  ChooseViewController.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 29/06/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class ChooseViewController: UIViewController {
    
    @IBOutlet weak var ownercard: UIView!
    @IBOutlet weak var employeecard: UIView!
    
    @IBOutlet weak var ownerlogo: UIImageView!
    @IBOutlet weak var employeelogo: UIImageView!
    
    var type : Signuptype?
    
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .light
        
        ownercard.makeCard()
        ownercard.makeBorder()
        employeecard.makeCard()
        employeecard.makeBorder()
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
    
    
    @IBAction func ButtonClicked(_ sender: UIButton) {
        animateButton(sender.tag == 0 ? ownercard : employeecard)
        self.type = Signuptype.init(rawValue: sender.tag)
    }
    
    func animateButton(_ view : UIView){
        
        let view2 = view == ownercard ? employeecard : ownercard
        
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view2?.transform = .identity
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        },
                       completion: { Void in()  }
        )
        
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        if let type = self.type{
            performSegue(withIdentifier: "touser", sender: type)
        } else {
            ProgressHUD.showError("Please select one option")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SignUpViewController {
            let vc = segue.destination as! SignUpViewController
            vc.type = sender as! Signuptype
        }
    }
    
}

enum Signuptype : Int {
    case owner = 0
    case employee = 1
    case licensee = 2
    
    var stringValue : String {
        return (self.rawValue == 2) ? "licensee" : "employee"
    }
}
