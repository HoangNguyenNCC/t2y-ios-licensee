//
//  RequestsViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 10/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class RequestsViewController: UIViewController {
    
    var value = 0
    var parameter: [String:String] = [:]
    var selectedIndex = -1
    var trailer : RentalItem? = nil
    var flag = false
    var invoiceDetails : Invoice? = nil
    
    let dateFormatter = DateFormatter()
    
    @IBAction func unwindToRequestTab(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var requests: UITableView!
    
    var trailers : [String] = []
    var currentIndex = 0
    var rentals: RentalRequest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        requests.dataSource = self
        requests.delegate = self
        getRentalRequests()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controller = 2
        if(flag) {
            getRentalRequests()
        }
    }
    
    
    func permissionAlert() {
        DispatchQueue.main.async {
            ProgressHUD.showError(Strings.permissionDataMessage)
        }
    }
    
    func getRentalRequests() {
        if Defaults.getPrivileges(key: AccessCategory.RENTAL_STATUS.localized(), access: AccessType.EDIT.rawValue) {
            ProgressHUD.show("Fetching latest requests for the day")
            ServiceController.shared.getRentalRequests { (requestList, status, error) in
                if status {
                    self.rentals = requestList
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        self.requests.reloadData()
                        self.flag = true
                    }
                } else {
                    ProgressHUD.showError(error ?? "Error")
                }
            }
        } else {
            permissionAlert()
        }
    }
    
    func dayDiff(dateA: Date, dateB: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: dateB, to: dateA).day!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RequestDetailsViewController {
            vc.approvalStatus = (rentals?.requestList?[selectedIndex].isApproved!)!
            vc.rentalType = (rentals?.requestList?[selectedIndex].requestType!)!
            vc.drop = (rentals?.requestList?[selectedIndex].todayDropOff!)!
            vc.pickup = (rentals?.requestList?[selectedIndex].todayPickup!)!
            if let invoice = sender as? Invoice {
                vc.invoiceDetails = invoice
            } else {
                vc.invoiceDetails = invoiceDetails
            }
        }
    }
}

extension RequestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (rentals?.requestList?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! RequestCell
        
        let request = rentals?.requestList?[indexPath.row]
        
        cell.requestCard.makeCard()
        cell.requestCard.makeBorder()
        cell.trailerImage.layer.cornerRadius = 14
        cell.trailerImage.contentMode = .scaleAspectFill
        cell.trailerImage.clipsToBounds = true
        
        cell.trailerDetails.text = request?.customerName!
        let trailer = request?.rentedItems?.filter({ (item) -> Bool in
            return item.itemType == "trailer"
        })
        cell.trailerName.text = trailer![0].name
        cell.trailerImage.kf.setImage(with: URL(string: trailer![0].photo!.data!)) //TODO
        if let type = request?.requestType?.capitalizingFirstLetter() {
            cell.deadline.text = "\(dayDiff(dateA: dateFormatter.date(from: (request?.rentalPeriodStart)!)!, dateB: Date())) Days"
            if request?.isApproved == 0 {
                cell.deadlineDescription.text = "\(type) Request"
                cell.deadlineDescription.backgroundColor = .systemOrange
            } else if request?.isApproved == 1 {
                cell.deadlineDescription.text = "\(type) Approved"
                cell.deadlineDescription.backgroundColor = .systemBlue
            } else {
                let desc = (type == "cancellation") ? "rental Cancelled" : "\(type) Declined"
                cell.deadlineDescription.text = desc
                cell.deadlineDescription.backgroundColor = .systemRed
            }
        }
        cell.deadlineDescription.padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        cell.deadlineDescription.layer.cornerRadius = 6
        cell.deadlineDescription.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print(((rentals?.requestList?[selectedIndex].rentalID!)!))
        ServiceController.shared.getRentalDetails(rentalId: ((rentals?.requestList?[selectedIndex].rentalID!)!)) { (invoiceDetails, status, error) in
            if status {
                DispatchQueue.main.async {
                    self.invoiceDetails = invoiceDetails
                    print("invoice details:",invoiceDetails)
                    self.performSegue(withIdentifier: "details", sender: invoiceDetails)
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error ?? "No invoice")
                }
            }
        }
    }
    
}
