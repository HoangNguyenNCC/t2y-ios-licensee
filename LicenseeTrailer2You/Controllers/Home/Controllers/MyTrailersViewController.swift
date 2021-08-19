
//
//  MyTrailersViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 17/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import Kingfisher
import ProgressHUD

class MyTrailersViewController: UIViewController {
    var currentIndex = 0 {
        didSet {
            print("currentIndex is:",currentIndex)
        }
    }
    
    var selectedIndex = -1
    var trailerData : [TrailerObject] = []
    var upsellData : [UpsellObject] = []
    var employees : [EmployeeDetails] = []
    
    var trailerListings: AllItems? = nil
    var upsellListings: AllItems? = nil
    var employeeListings: AllItems? = nil
    var upsellDetails : GetUpsellDetails? = nil
    var myListings: AllItems? = nil
    let dateFormatter = DateFormatter()
    
    var currentEmployeeID : String?
    
    let menuContextElements = ["Trailer","Upsell","Employee"]
    
    @IBAction func unwindToTrailerTab(_ unwindSegue: UIStoryboardSegue) {}
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var trailerTable: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        trailerTable.dataSource = self
        trailerTable.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        ProgressHUD.show("Fetching all your trailer and upsell items")
        segment.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        
        
        loadTrailers()
        loadUpsells()
        loadEmployees()
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.tintColor = .yellow
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        trailerTable.refreshControl = self.refreshControl
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.beginRefreshing()
        switch currentIndex {
        case 0:
            loadTrailers()
        case 1:
            loadUpsells()
        case 2:
            loadEmployees()
        default:
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }        }
    }
    
    func loadTrailers(){
        if Defaults.getPrivileges(key: AccessCategory.TRAILER.localized(), access: AccessType.VIEW.rawValue) {
            ServiceController.shared.getLicenseeTrailers { (trailerListings, status, error) in
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                if status {
                    DispatchQueue.main.async {
                        self.trailerListings = trailerListings
                        self.fetchSegmentData()
                        ProgressHUD.dismiss()
                    }
                } else {
                    DispatchQueue.main.async {
                        ProgressHUD.showError(error)
                    }
                }
            }
        }
    }
    
    func loadUpsells(){
        if Defaults.getPrivileges(key: AccessCategory.UPSELL.localized(), access: AccessType.VIEW.rawValue) {
            ServiceController.shared.getLicenseeUpsell { (upsellListings, status, error) in
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                if status {
                    self.upsellListings = upsellListings
                    self.fetchSegmentData()
                } else {
                    DispatchQueue.main.async {
                        ProgressHUD.showError(error)
                    }
                }
            }
        }
    }
    
    func loadEmployees(){
        if Defaults.getPrivileges(key: AccessCategory.EMPLOYEE.localized(), access: AccessType.VIEW.rawValue) {
            ServiceController.shared.getLicenseeEmployees { (employeeListings, status, error) in
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                if status {
                    self.employeeListings = employeeListings
                    self.fetchSegmentData()
                } else {
                    DispatchQueue.main.async {
                        ProgressHUD.showError(error)
                    }
                }
            }
        }
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        currentIndex = segment.selectedSegmentIndex
        fetchSegmentData()
    }
    
    func fetchSegmentData() {
        if currentIndex == 0 {
            self.trailerData = self.trailerListings?.trailersList ?? []
        } else if currentIndex == 1 {
            self.upsellData = self.upsellListings?.upsellItemsList ?? []
        } else if currentIndex == 2 {
            self.employees = self.employeeListings?.employeeList ?? []
        }
        DispatchQueue.main.async {
            self.trailerTable.reloadData()
        }
    }
    
    func permissionAlert() {
        DispatchQueue.main.async {
            ProgressHUD.showError(Strings.permissionDataMessage)
        }
    }
    
    func dayDiff(dateA: Date, dateB: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: dateB, to: dateA).day!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC =  segue.destination as? TrailerDetailsViewController {
            detailVC.typeIndex = currentIndex
            if currentIndex == 0 {
                detailVC.trailerId = ((trailerListings?.trailersList?[selectedIndex].id!)!)
            } else if currentIndex == 1 {
                detailVC.trailerId = (upsellListings?.upsellItemsList?[selectedIndex].id!)!
            }
        }
        
        if let editUpsellVC = segue.destination as? UpsellViewController {
            editUpsellVC.operation = OperationType.edit.rawValue
            editUpsellVC.upsellId = upsellData[selectedIndex].id
            editUpsellVC.editingUpsell = self.upsellDetails
        }
        
        if let editPermissionVC = segue.destination as? PermissionsViewController {
            print("going to permissions")
            if let acl = sender as? AccessControlList {
                print("ACL is",acl)
                editPermissionVC.ACL = acl
                editPermissionVC.isUpdate = true
                editPermissionVC.employeeId = self.currentEmployeeID
            }
        }
    }
    
    func toggleAlert(index: Int) {
        var deletion = ""
        if selectedIndex == 0 {
            deletion = "Trailer"
        } else if selectedIndex == 1 {
            deletion = "Upsell"
        } else {
            deletion = "Employee"
        }
        
        let alert = UIAlertController(title: "Delete \(deletion)", message: "Are you sure you want to delete", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default , handler:{ (UIAlertAction) in
            if self.currentIndex == 0 && self.trailerData[index].id != nil {
                let deleteItem = DeleteItem(id: self.trailerData[index].id!)
                let deleteObject = try! JSONEncoder().encode(deleteItem)
                let object = self.trailerData[index]
                ServiceController.shared.deleteTrailer(trailerId: deleteObject) { ( status, message) in
                    if !status {
                        self.trailerData.append(object)
                        DispatchQueue.main.async {
                            ProgressHUD.showError(message)
                            self.trailerTable.reloadData()
                        }
                    }
                }
                self.trailerData.remove(at: index)
                DispatchQueue.main.async {
                    self.trailerTable.reloadData()
                }
            }
            
            if self.currentIndex == 1 && self.upsellData[index].id != nil {
                let deleteItem = DeleteItem(id: self.upsellData[index].id!)
                let deleteObject = try! JSONEncoder().encode(deleteItem)
                let object = self.upsellData[index]
                ServiceController.shared.deleteUpsell(upsellId: deleteObject) { ( status, message) in
                    if !status {
                        self.upsellData.append(object)
                        DispatchQueue.main.async {
                            ProgressHUD.showError(message)
                            self.trailerTable.reloadData()
                        }
                    }
                }
                self.upsellData.remove(at: index)
                DispatchQueue.main.async {
                    self.trailerTable.reloadData()
                }
            }
            
            if self.currentIndex == 2 && self.employees[index].id != nil {
                let deleteItem = DeleteItem(id: self.employees[index].id!)
                let deleteObject = try! JSONEncoder().encode(deleteItem)
                let object = self.employees[index]
                ServiceController.shared.deleteEmployee(employeeId: deleteObject) { ( status, message) in
                    if !status {
                        self.employees.append(object)
                        DispatchQueue.main.async {
                            ProgressHUD.showError(message)
                            self.trailerTable.reloadData()
                        }
                    }
                }
                self.employees.remove(at: index)
                DispatchQueue.main.async {
                    self.trailerTable.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction) in
        }))
        
        self.present(alert, animated: true)
    }
    
}

extension MyTrailersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentIndex == 0 {
            return trailerData.count
        } else if currentIndex == 1 {
            return upsellData.count
        } else {
            return employees.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! RequestCell
        cell.requestCard.makeCard()
        cell.requestCard.makeBorder()
        cell.trailerImage.setup()
        
        if currentIndex == 0 {
            cell.trailerImage.kf.setImage(with: URL(string: trailerData[indexPath.row].photos?.first?.data ?? ""))
            cell.trailerName.text = trailerData[indexPath.row].name
            if let ongoing = trailerData[indexPath.row].trailerAvailability?.ongoing {
                cell.deadline.text = "\(dayDiff(dateA: dateFormatter.date(from: ongoing.endDate!)!, dateB: Date())) Days"
                cell.deadlineDescription.text = "Rental expiry"
                cell.deadlineDescription.backgroundColor = .systemRed
            } else if let upcoming = trailerData[indexPath.row].trailerAvailability?.upcoming {
                cell.deadline.text = "\(dayDiff(dateA: dateFormatter.date(from: upcoming.startDate!)!, dateB: Date())) Days"
                cell.deadlineDescription.text = "Upcoming rental"
                cell.deadlineDescription.backgroundColor = .systemBlue
            } else {
                cell.deadline.text = "Free"
                cell.deadlineDescription.text = "No bookings"
                cell.deadlineDescription.backgroundColor = .systemGreen
            }
        } else if currentIndex == 1 {
            cell.trailerImage.kf.setImage(with: URL(string: upsellData[indexPath.row].photos?.first?.data ?? ""))
            cell.trailerName.text = upsellData[indexPath.row].name
            if let ongoing = upsellData[indexPath.row].upsellItemAvailability?.ongoing {
                cell.deadline.text = "\(dayDiff(dateA: dateFormatter.date(from: ongoing.endDate!)!, dateB: Date())) Days"
                cell.deadlineDescription.text = "Rental expiry"
                cell.deadlineDescription.backgroundColor = .systemRed
            } else if let upcoming = upsellData[indexPath.row].upsellItemAvailability?.upcoming {
                cell.deadline.text = "\(dayDiff(dateA: Date(), dateB: dateFormatter.date(from: upcoming.startDate!)!)) Days"
                cell.deadlineDescription.text = "Upcoming rental"
                cell.deadlineDescription.backgroundColor = .systemBlue
            } else {
                cell.deadline.text = ""
                let available = (upsellData[indexPath.row].availability ?? false)
                cell.deadlineDescription.text = available ? "Available" : "Unavailable"
                cell.deadlineDescription.backgroundColor = available ? .systemGreen : .systemRed
            }
        } else {
            if let photo = employees[indexPath.row].photo?.data {
                cell.trailerImage.kf.setImage(with: URL(string: photo))
            }
            cell.deadline.text = ""
            cell.trailerName.text = employees[indexPath.row].name ?? ""
            if (employees[indexPath.row].isEmailVerified ?? false) && (employees[indexPath.row].isMobileVerified ?? false) {
                cell.deadlineDescription.text = "Verified"
                cell.deadlineDescription.backgroundColor = .green
            } else {
                cell.deadlineDescription.text = "Not Verified"
                cell.deadlineDescription.backgroundColor = .red
            }
        }
        cell.deadlineDescription.layer.cornerRadius = 6
        cell.deadlineDescription.padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        cell.deadlineDescription.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if currentIndex == 0 {
            self.performSegue(withIdentifier: "trailerDetails", sender: Any?.self)
        } else if currentIndex == 1 {
            if Defaults.getPrivileges(key: AccessCategory.UPSELL.localized(), access: AccessType.EDIT.rawValue) {
                ServiceController.shared.getUpsellDetails(upsellId: upsellData[selectedIndex].id!) { (upsellObject, status, message) in
                    DispatchQueue.main.async {
                        if status {
                            self.upsellDetails = upsellObject
                            self.selectedIndex = indexPath.row
                            self.performSegue(withIdentifier: "editUpsell", sender: Any?.self)
                        } else {
                            ProgressHUD.showError(message!)
                        }
                    }
                }
            }
        } else if currentIndex == 2 {
            let employee = employees[indexPath.row]
            
            let alert = UIAlertController(title: "Employee", message: "choose option", preferredStyle: .actionSheet)
            let view = UIAlertAction(title: "Employee Details", style: .default) { (a) in
                let storyboard = AppStoryboard.main.instance
                let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileDetailsViewController") as! ProfileDetailsViewController
                profileVC.employee = employee
                self.present(profileVC, animated: true, completion: nil)
            }
            
            let acl = UIAlertAction(title: "Edit ACL", style: .default) { (a) in
                self.currentEmployeeID = employee.id
                self.performSegue(withIdentifier: "editemployee", sender: employee.acl)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (s) in }
            
            view.isEnabled = Defaults.getPrivileges(key: AccessCategory.EMPLOYEE.localized(), access: AccessType.VIEW.rawValue)
                        
            acl.isEnabled = Defaults.getPrivileges(key: AccessCategory.EMPLOYEE.localized(), access: AccessType.EDIT.rawValue)
            
            

            alert.addAction(view)
            alert.addAction(acl)
            alert.addAction(cancel)
            
            
            if !(employee.isOwner ?? true) {
            self.present(alert, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if currentIndex == 0 {
            if Defaults.getPrivileges(key: AccessCategory.TRAILER.localized(), access: AccessType.DELETE.rawValue) {
                return true
            } else {
                return false
            }
        }
            
        else if currentIndex == 1 {
            if Defaults.getPrivileges(key: AccessCategory.UPSELL.localized(), access: AccessType.DELETE.rawValue) {
                return true
            } else {
                return false
            }
        }
            
        else {
            if Defaults.getPrivileges(key: AccessCategory.EMPLOYEE.localized(), access: AccessType.DELETE.rawValue) {
                let employee = employees[indexPath.row]
                if employee.isOwner ?? false {
                    return false
                }
                return true
            } else {
                return false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let callAction = UIContextualAction(style: .normal, title: "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.toggleAlert(index: indexPath.row)
        })
        callAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.systemRed)
        return UISwipeActionsConfiguration(actions: [callAction])
    }
}
