//
//  RentalHistoryViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 08/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class RentalHistoryViewController: UIViewController {

    var selectedIndex = -1
    var trailerDetails: GetTrailerDetails? = nil
    let formatter = DateFormatter()
    let timeFormatter = DateFormatter()
    var invoiceDetails: Invoice? = nil
    
    @IBOutlet weak var rentalHistory: UITableView!
    override func viewDidLoad() {
        print(trailerDetails?.trailerObj?.rentalsList.first?.bookedByUser?.name)
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeFormatter.dateFormat = "dd MMM"
        rentalHistory.dataSource = self
        rentalHistory.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RequestDetailsViewController {
            vc.invoiceDetails = invoiceDetails
            vc.status = (trailerDetails?.trailerObj?.rentalsList[selectedIndex].status ?? "")
        }
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
}

extension RentalHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailerDetails?.trailerObj?.rentalsList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rental", for: indexPath) as! RentalCell
        cell.rentalCard.makeCard()
        if let photo = trailerDetails?.trailerObj?.rentalsList[indexPath.row].bookedByUser?.photo?.data, let url = URL(string: photo) {
        cell.rentalCustomer.kf.setImage(with: url)
        }
        cell.customerName.text = trailerDetails?.trailerObj?.rentalsList[indexPath.row].bookedByUser?.name!
        let sdate = formatter.date(from: (trailerDetails?.trailerObj?.rentalsList[indexPath.row].start)!)
        let edate = formatter.date(from: (trailerDetails?.trailerObj?.rentalsList[indexPath.row].end)!)
        if let sdate = sdate, let edate = edate {
        cell.rentalDate.text = timeFormatter.string(from: sdate)
        cell.rentalExpiryDate.text = timeFormatter.string(from: edate)
        }
        cell.rentalCustomer.layer.cornerRadius = 32
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if let id = trailerDetails?.trailerObj?.rentalsList[selectedIndex].invoiceId {
            ServiceController.shared.getRentalDetails(rentalId: id) { (invoiceDetails, status, error) in
                if status {
                    DispatchQueue.main.async {
                        self.invoiceDetails = invoiceDetails
                        self.performSegue(withIdentifier: "invoice", sender: Any?.self)
                    }
                } else {
                    DispatchQueue.main.async {
                        ProgressHUD.showError("No Invoice Found")
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
