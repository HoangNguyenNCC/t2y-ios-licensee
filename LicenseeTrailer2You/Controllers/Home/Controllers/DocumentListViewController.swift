//
//  DocumentListViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 06/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class DocumentListViewController: UIViewController {
    
    @IBOutlet weak var docTable: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var insurances: [TrailerInsurance]?
    var servicing: [TrailerService]?
    var docType : DocumentType = .insurance
    var trailerID : String?
    var formatter = DateFormatter()
    var timeFormatter = DateFormatter()
    var trailer : TrailerDetails?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        docTable.dataSource = self
        docTable.delegate = self
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        timeFormatter.dateFormat = "dd MMM yyyy"
        if trailerID != nil {
        switch docType {
        case .insurance:
            getInsurances()
            self.insurances = trailer?.insurance
            titleLabel.text = "Trailer Insurance"
        case .servicing:
            getServices()
            self.servicing = trailer?.servicing
            titleLabel.text = "Trailer Servicing"
            }
        } else {
            ProgressHUD.showError("Error, please try again!")
        }
    }
    
    func getInsurances(){
        ServiceController.shared.getTrailerInsurances(trailerId: trailerID!) { (insurances, status, error) in
            if status {
                DispatchQueue.main.async {
                    if let insurance = insurances?.insuranceList {
                        self.insurances = insurance.map {TrailerInsurance(_id: $0.id, document: $0.document, expiryDate: $0.expiryDate ?? "", issueDate: $0.issueDate ?? "") }
                    }
                    DispatchQueue.main.async {
                        self.docTable.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!)
                }
            }
        }
    }
    
    func getServices(){
        ServiceController.shared.getTrailerServices(trailerId: trailerID!) { (servicing, status, error) in
            if status {
                DispatchQueue.main.async {
                    if let services = servicing?.servicingList{
                        self.servicing = services.map { TrailerService(_id: $0.id, document: $0.document, nextDueDate: $0.nextDueDate ?? "", serviceDate: $0.serviceDate ?? "", name: $0.name ?? "", itemId: $0.itemId ?? "", itemType: $0.itemType ?? "") }
                    }
                    DispatchQueue.main.async {
                        self.docTable.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!)
                }
            }
        }
    }
    
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let insuranceVC = segue.destination as? InsuranceViewController {
            insuranceVC.operation = OperationType.edit.rawValue
            insuranceVC.insurance = sender as? TrailerInsurance
            insuranceVC.titlePhotoURL = trailer?.photos.first?.data ?? ""
            insuranceVC.editingTrailer = trailer?.name ?? ""
            insuranceVC.editId = trailer?.id ?? ""
        }
        
        if let serviceVC = segue.destination as? ServiceViewController {
            serviceVC.operation = OperationType.edit.rawValue
            serviceVC.service = sender as? TrailerService
            serviceVC.titlePhotoURL = trailer?.photos.first?.data ?? ""
            serviceVC.editingTrailer = trailer?.name ?? ""
            serviceVC.editId = trailer?.id ?? ""
        }
        
    }
    
}

extension DocumentListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.docType == .insurance {
            return insurances?.count ?? 0
        } else {
            return servicing?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rental", for: indexPath) as! RentalCell
        cell.rentalCard.makeCard()
        cell.rentalCard.makeBorder()
        if docType == .insurance {
            let insurance = insurances![indexPath.row]
            cell.customerName.text = "Insurance"
            let sdate = formatter.date(from: insurance.issueDate)
            let edate = formatter.date(from: insurance.expiryDate)
            cell.rentalDate.text = timeFormatter.string(from: sdate!)
            cell.rentalExpiryDate.text = timeFormatter.string(from: edate!)
            return cell
        } else {
            let service = servicing![indexPath.row]
            cell.customerName.text = service.name
            let sdate = formatter.date(from: service.serviceDate)
            let edate = formatter.date(from: service.nextDueDate)
            cell.rentalDate.text = timeFormatter.string(from: sdate!)
            cell.rentalExpiryDate.text = timeFormatter.string(from: edate!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if docType == .insurance{
            performSegue(withIdentifier: "editInsurance", sender: insurances?[indexPath.row])
        } else {
            performSegue(withIdentifier: "editServicing", sender: servicing?[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

