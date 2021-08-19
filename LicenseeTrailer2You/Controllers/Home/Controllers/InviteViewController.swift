//
//  InviteViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 23/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD
import iOSDropDown


class InviteViewController: UIViewController {

    @IBOutlet weak var sendInviteBttn: UIButton!
    @IBOutlet weak var addPermissionBttn: UIButton!

    @IBOutlet weak var employeeType: DropDown!
    @IBOutlet weak var employeeEmailTextField: UITextField!
    
    var permissions: [String:[String]] = [:]
    var acl : ACL?
    
    var EmployeeTypes : [String] = ["Individual", "Company"]
    var EType :  EmployeeType = .employee

    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.EmployeeTypes = EmployeeType.allCases.map{ $0.rawValue }
        }
    
    override func viewDidLayoutSubviews() {
        addPermissionBttn.layer.cornerRadius = 8
        employeeEmailTextField.formatField()
        employeeType.formatField()
        employeeType.optionArray = EmployeeTypes
        employeeType.selectedRowColor = UIColor.lightGray
        sendInviteBttn.layer.cornerRadius = 14
    }
    
    @IBAction func sendInviteBttnTapped(_ sender: Any) {
        if valid() {
         sendInvite()
        }
    }
    
    func valid()->Bool {
        if employeeEmailTextField.text?.isEmpty ?? true {
            ProgressHUD.showError("Email empty")
            return false
        }
        
        if permissions.count <= 0 {
            ProgressHUD.showError("Permissions empty")
            return false
        }
        
        if employeeType.text?.isEmpty ?? true {
            ProgressHUD.showError("Enter employee type")
            return false
        }
        
        return true
    }
    
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "backToProfile", sender: Any?.self)
    }
    
    
    func sendInvite() {
        let emp =  EmployeeTypes[employeeType.selectedIndex ?? 0]

        self.EType = EmployeeType(rawValue: emp)!
        
        let inviteBody = Invite(email: employeeEmailTextField.text!, acl: permissions, type: EType)
        let inviteObject = try! JSONEncoder().encode(inviteBody)
        ProgressHUD.show("Sending Invite")
        
        PostController.shared.sendInvitation(inviteObject: inviteObject) { (message, status) in
            if status {
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess(message)
                    self.performSegue(withIdentifier: "backToProfile", sender: Any?.self)
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(message)
                }
            }
        }
    }
    
    @IBAction func addPermissionBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "choosePermissions", sender: Any?.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "choosePermissions" {
                if let permissionVC = segue.destination as? PermissionsViewController {
                    permissionVC.permissionsDelegate = self
                    permissionVC.givenPermissions = permissions
                }
            }
        }
    }
}

extension InviteViewController: PermissionsDelegate {
    func getPermissions(permissions: [String:[String]]) {
        self.permissions = permissions
    }
}


