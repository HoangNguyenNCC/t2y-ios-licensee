//
//  RequestDetailsViewController.swift
//  
//
//  Created by Pranav Karnani on 27/04/20.
//

import UIKit
import ProgressHUD

class RequestDetailsViewController: UIViewController {

    var invoiceDetails : Invoice?
    var approvalStatus = -1
    var rentalType = ""
    var status = ""
    var drop: Bool = false
    var pickup: Bool = false
    
    @IBOutlet weak var invoiceDescription: UILabel!
    @IBOutlet weak var invoiceNumber: UILabel!
    @IBOutlet weak var trailerName: UILabel!
    @IBOutlet weak var priceTableHeight: NSLayoutConstraint!
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var priceTable: UITableView!
    @IBOutlet weak var invoiceCard: UIView!
    @IBOutlet weak var customerCard: UIView!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPicture: UIImageView!
    @IBOutlet weak var trailerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light

        priceTable.dataSource = self
        priceTable.delegate = self
        
        getInvoiceData()
        trailerImage.makeBorder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        invoiceCard.makeCard()
        invoiceCard.makeBorder()
        trailerImage.layer.cornerRadius = 8
        trailerImage.makeBorder()
        customerCard.makeCard()
        customerCard.makeBorder()
        nextBttn.layer.cornerRadius = 14
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
      //  self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConfirmationViewController {
            vc.invoiceDetails = invoiceDetails
            vc.approvalStatus = approvalStatus
            vc.rentalType = rentalType
            vc.drop = drop
            vc.pickup = pickup
        }
    }
    
    func getInvoiceData() {
        DispatchQueue.main.async {
            let trailer = self.invoiceDetails?.rentalObj?.rentedItems?.filter({ (item) -> Bool in
                return item.itemType == "trailer"
            })
            
            self.trailerName.text = trailer![0].itemName!
            self.trailerImage.kf.setImage(with: URL(string: trailer![0].itemPhoto!.data!))
            self.priceTableHeight.constant = CGFloat((self.invoiceDetails?.rentalObj?.rentedItems?.count ?? 0)*72)
                
            if let customerPhoto = self.invoiceDetails?.rentalObj?.bookedByUser?.photo?.data {
                self.customerPicture.kf.setImage(with: URL(string: customerPhoto))
            }
            self.invoiceDescription.text = self.convert(self.invoiceDetails?.rentalObj?.rentalPeriod?.start ?? "") + " - " + self.convert(self.invoiceDetails?.rentalObj?.rentalPeriod?.end ?? "")
            self.customerName.text = self.invoiceDetails?.rentalObj?.bookedByUser?.name!
            self.customerAddress.text = self.invoiceDetails?.rentalObj?.bookedByUser?.address?.text
            self.invoiceNumber.text = "Invoice Number: \(self.invoiceDetails?.rentalObj?.invoiceNumber ?? 0)"
            self.priceTable.reloadData()
        }
    }
    
    func convert(_ time : String?)->String{
        guard let time = time else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: time)
        formatter.timeZone = .current
        let dateString = formatter.string(from: date!)
        return dateString
    }
    
    
    @IBAction func nextBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "confirmRequest", sender: Any?.self)
    }
}

extension RequestDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceDetails?.rentalObj?.rentedItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! RentalItemCell
        let rentedItem = invoiceDetails?.rentalObj?.rentedItems![indexPath.row]
        cell.rentalItemPhoto.kf.setImage(with: URL(string: (invoiceDetails?.rentalObj?.rentedItems![indexPath.row].itemPhoto?.data)!))
        cell.rentalItem.text = rentedItem?.itemName!
        cell.rentalItemPhoto.layer.cornerRadius = 12
        cell.rentalPrice.text = "\(invoiceDetails?.rentalObj?.calculateCharges(indexPath.row) ?? 0.0) AUD"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
