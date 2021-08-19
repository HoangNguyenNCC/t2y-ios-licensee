//
//  ReminderViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 10/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import Kingfisher
import ProgressHUD
import CoreLocation

class ReminderViewController: UIViewController {
    
    var reminders : Reminder?
    let dateFormatter = DateFormatter()
    var selectedIndex = -1
    var invoiceDetails: Invoice? = nil
    
    @IBAction func unwindToReminderTab(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var reminderTable: UITableView!
    
    func dayDiff(dateA: Date, dateB: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: dateB, to: dateA).day!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        reminderTable.dataSource = self
        reminderTable.delegate = self
        getReminders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controller = 3
    }
    
    func getReminders() {
        if Defaults.getPrivileges(key: AccessCategory.REMINDERS.localized(), access: AccessType.VIEW.rawValue) {
            ProgressHUD.show("Fetching your latest reminders for the day")
            ServiceController.shared.getReminders { (reminderList, status, error) in
                if status {
                    self.reminders = reminderList
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        self.reminderTable.reloadData()
                    }
                } else {
                    ProgressHUD.showError(error ?? "Error")
                }
            }
        } else {
            ProgressHUD.showError(Strings.permissionDataMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RequestDetailsViewController {
            vc.invoiceDetails = invoiceDetails
            if(reminders?.remindersList?[selectedIndex].reminderType == "Today's DropOff") {
                vc.drop = true
            } else if (reminders?.remindersList?[selectedIndex].reminderType == "Today's Pickup"){
                vc.pickup = true
            }
        }
    }
}

extension ReminderViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders?.remindersList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderCell
        cell.reminderCard.makeCard()
        cell.trailerImage.layer.cornerRadius = 14
        cell.trailerImage.contentMode = .scaleAspectFill
        if let reminderImage = reminders?.remindersList?[indexPath.row].itemPhoto?.data {
            cell.trailerImage.kf.setImage(with: URL(string: reminderImage))
        }
        
        if let _ = reminders?.remindersList?[indexPath.row].invoiceID {
            let trailer = reminders?.remindersList?[indexPath.row].rentedItems?.filter({ (item) -> Bool in
                return item.itemType == "trailer"
            })
            cell.trailerImage.kf.setImage(with: URL(string: (trailer?[0].itemPhoto!.data)!)!)
            cell.trailerDetails.text = trailer?[0].itemName!
        } else {
            cell.trailerDetails.text = reminders?.remindersList?[indexPath.row].itemName
        }
        cell.trailerName.text = reminders?.remindersList?[indexPath.row].reminderType
        cell.deadline.text = reminders?.remindersList?[indexPath.row].statusText
        cell.deadline.textColor = UIColor(hexString: (reminders?.remindersList?[indexPath.row].reminderColor)!)
        cell.reminderCard.makeBorder()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if let invoiceId = reminders?.remindersList?[selectedIndex].invoiceID {
            ServiceController.shared.getRentalDetails(rentalId: invoiceId) { (invoiceDetails, status, error) in
                if status {
                    DispatchQueue.main.async {
                        self.invoiceDetails = invoiceDetails
                        self.performSegue(withIdentifier: "rentalDetails", sender: Any?.self)
                    }
                } else {
                    DispatchQueue.main.async {
                        ProgressHUD.showError(error ?? "No invoice")
                    }
                }
            }
        }
    }
}
