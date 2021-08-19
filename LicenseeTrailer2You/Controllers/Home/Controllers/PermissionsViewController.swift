//
//  PermissionsViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 23/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

protocol PermissionsDelegate {
    func getPermissions(permissions: [String:[String]])
}

class PermissionsViewController: UIViewController {
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectView = UIVisualEffectView()
    var addStatus = false
    var deleteStatus = false
    var updateStatus = false
    var viewStatus = false
    var category = ""
    
    @IBOutlet weak var privilege: UILabel!
    @IBOutlet weak var createBttn: UIButton!
    @IBOutlet weak var viewBttn: UIButton!
    @IBOutlet weak var updateBttn: UIButton!
    @IBOutlet weak var deleteBttn: UIButton!
    @IBOutlet weak var addPrivilegeBttn: UIButton!
    @IBOutlet weak var cancelBttn: UIButton!
    @IBOutlet weak var privilegeDescriptionView: UIView!
    
    var givenPermissions : [String:[String]] = [:]
    var myPermissions: [String] = []
    var permissionSets : [String:[String]] = [:]
    var ACL : AccessControlList?
    var employeeId : String?
    var isUpdate : Bool = false
    
    @IBOutlet weak var addPermissionBttn: UIButton!
    @IBOutlet weak var permissionTable: UITableView!
    
    var permissionsDelegate: PermissionsDelegate?
    
    override func viewDidLoad() {
        print(givenPermissions)
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        privilegeDescriptionView.alpha = 0
        falseInteraction()
        self.view.sendSubviewToBack(privilegeDescriptionView)
        permissionTable.dataSource = self
        permissionTable.delegate = self
        
        if let _ = ACL {
            self.addPrivilegeBttn.setTitle("Update privileges", for: .normal)
        }
        
        ServiceController.shared.getACL { (access, status) in
            if status {
                self.permissionSets = access!
                for(key,_) in access! {
                    self.myPermissions.append(key)
                    if let values = self.ACL?.dictionaryRepresentation[key] as? [String]{
                        print("value")
                        self.givenPermissions[key] = values
                    } else {
                        if self.givenPermissions[key] == nil {
                            self.givenPermissions[key] = []
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.permissionTable.reloadData()
                }
            } else {
                ProgressHUD.showError(NetworkErrors.serverError)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        addPermissionBttn.layer.cornerRadius = 8
        privilegeDescriptionView.layer.cornerRadius = 8
        addPrivilegeBttn.layer.cornerRadius = 8
        createBttn.layer.cornerRadius = 8
        viewBttn.layer.cornerRadius = 8
        updateBttn.layer.cornerRadius = 8
        deleteBttn.layer.cornerRadius = 8
    }
    
    @IBAction func cancelBttnTapped(_ sender: Any) {
        falseInteraction()
    }
    
    @IBAction func createBttnTapped(_ sender: Any) {
        if !addStatus {
            createBttn.backgroundColor = #colorLiteral(red: 0, green: 0.8980392157, blue: 0.5529411765, alpha: 1)
            addStatus = true
            self.givenPermissions[category]?.append("ADD")
        } else {
            createBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
            addStatus = false
            self.givenPermissions[category]?.removeAll(where: { (item) -> Bool in
                item == "ADD"
            })
        }
    }
    
    @IBAction func viewBttnTapped(_ sender: Any) {
        if !viewStatus {
            viewBttn.backgroundColor = .systemBlue
            viewStatus = true
            self.givenPermissions[category]?.append("VIEW")
        } else {
            viewBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
            viewStatus = false
            self.givenPermissions[category]?.removeAll(where: { (item) -> Bool in
                item == "VIEW"
            })
        }
    }
    
    @IBAction func deleteBttnTapped(_ sender: Any) {
        if !deleteStatus {
            deleteBttn.backgroundColor = .red
            deleteStatus = true
            self.givenPermissions[category]?.append("DELETE")
        } else {
            deleteBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
            deleteStatus = false
            self.givenPermissions[category]?.removeAll(where: { (item) -> Bool in
                item == "DELETE"
            })
        }
    }
    
    @IBAction func updateBttnTapped(_ sender: Any) {
        if !updateStatus {
            updateBttn.backgroundColor = .orange
            updateStatus = true
            self.givenPermissions[category]?.append("UPDATE")
        } else {
            updateBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
            updateStatus = false
            self.givenPermissions[category]?.removeAll(where: { (item) -> Bool in
                item == "UPDATE"
            })
        }
    }
    
    @IBAction func addPermissionBttnTapped(_ sender: Any) {
        if isUpdate{
            updateACL()
        } else {
        self.permissionsDelegate?.getPermissions(permissions: givenPermissions)
        dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addPrivilegeBttnTapped(_ sender: Any) {
        falseInteraction()
        if(addStatus) {
            givenPermissions[category]?.append("ADD")
        }
        if(viewStatus) {
            givenPermissions[category]?.append("VIEW")
        }
        if(updateStatus) {
            givenPermissions[category]?.append("UPDATE")
        }
        if(deleteStatus) {
            givenPermissions[category]?.append("DELETE")
        }
        DispatchQueue.main.async {
            self.permissionTable.reloadData()
        }
    }
    
    func updateACL(){
        var params = multipartRepresentation
        params["reqBody[employeeId]"] = employeeId!
        PostController.shared.updateACL(data: params) { (success, error) in
            if success { self.dismiss(animated: true, completion: nil) } else {
            
            }
        }
    }
    
    var multipartRepresentation : [String:String]{
        var params = [String:String]()
        for (k,v) in givenPermissions{
            for i in v{
                params["reqBody[\(k)][\(v.firstIndex(of: i)!)]"] = i
            }
        }
        return params
    }
    
    func setupView(type: String) {
        privilege.text = type
        category = type
        enableInteraction(category: type)
    }
    
    func falseInteraction() {
        addStatus = false
        deleteStatus = false
        updateStatus = false
        viewStatus = false
        
        createBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
        viewBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
        deleteBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
        updateBttn.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
        
        blurEffectView.removeFromSuperview()
        
        createBttn.isUserInteractionEnabled = false
        updateBttn.isUserInteractionEnabled = false
        deleteBttn.isUserInteractionEnabled = false
        viewBttn.isUserInteractionEnabled = false
        
        createBttn.alpha = 0
        viewBttn.alpha = 0
        deleteBttn.alpha = 0
        updateBttn.alpha = 0
        
        addPrivilegeBttn.isUserInteractionEnabled = false
        privilegeDescriptionView.alpha = 0
        self.view.sendSubviewToBack(privilegeDescriptionView)
    }
    
    func enableInteraction(category: String) {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        updateBttn.isUserInteractionEnabled = true
        deleteBttn.isUserInteractionEnabled = true
        viewBttn.isUserInteractionEnabled = true
        addPrivilegeBttn.isUserInteractionEnabled = true
        privilegeDescriptionView.alpha = 1
        
        let options = permissionSets[category]
        if options?.contains("ADD") ?? true {
            createBttn.isUserInteractionEnabled = true
            createBttn.alpha = 1
        }
        if options?.contains("VIEW") ?? true {
            viewBttn.isUserInteractionEnabled = true
            viewBttn.alpha = 1
        }
        if options?.contains("UPDATE") ?? true {
            updateBttn.isUserInteractionEnabled = true
            updateBttn.alpha = 1
        }
        if options?.contains("DELETE") ?? true {
            deleteBttn.isUserInteractionEnabled = true
            deleteBttn.alpha = 1
        }
        
        self.view.bringSubviewToFront(privilegeDescriptionView)
        self.checkIfSelected(category: category)
    }
    
    func checkIfSelected(category: String) {
        let status = givenPermissions[category]
        
        if status?.contains("ADD") ?? false{
            addStatus = true
            createBttn.backgroundColor = #colorLiteral(red: 0, green: 0.8980392157, blue: 0.5529411765, alpha: 1)
        }
        if status?.contains("VIEW") ?? false {
            viewStatus = true
            viewBttn.backgroundColor = .systemBlue
        }
        if status?.contains("UPDATE") ?? false {
            updateStatus = true
            updateBttn.backgroundColor = .orange
        }
        if status?.contains("DELETE") ?? false  {
            deleteStatus = true
            deleteBttn.backgroundColor = .red
        }
    }
}

extension PermissionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPermissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "permissioncell", for: indexPath) as! PermissionCell
        cell.permissionCard.layer.cornerRadius = 8
        cell.permissionLabel.text = myPermissions[indexPath.row]
        
        if givenPermissions[myPermissions[indexPath.row]]?.contains("ADD") ?? false {
            cell.addIndicator.isHidden = false
        } else {
            cell.addIndicator.isHidden = true
        }
        
        if givenPermissions[myPermissions[indexPath.row]]?.contains("VIEW") ?? false {
            cell.viewIndicator.isHidden = false
        } else {
            cell.viewIndicator.isHidden = true
        }
        
        if givenPermissions[myPermissions[indexPath.row]]?.contains("UPDATE") ?? false {
            cell.updateIndicator.isHidden = false
        } else {
            cell.updateIndicator.isHidden = true
        }
        
        if givenPermissions[myPermissions[indexPath.row]]?.contains("DELETE") ?? false {
            cell.deleteIndicator.isHidden = false
        } else {
            cell.deleteIndicator.isHidden = true
        }
        
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(myPermissions[indexPath.row])
        setupView(type: myPermissions[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
