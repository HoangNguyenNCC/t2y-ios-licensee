//
//  ConfirmationViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 27/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import GoogleMaps
import ProgressHUD

class ConfirmationViewController: UIViewController {
    
    var invoiceDetails : Invoice?
    var rentalType = ""
    var approvalStatus = -1
    var rentalId = ""
    var drop = true
    var pickup = false
    var type = ""
    var viewToggle = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescription: UILabel!
    @IBOutlet weak var revisedBttn: UIButton!
    @IBOutlet weak var rejectBttn: UIButton!
    @IBOutlet weak var approveBttn: UIButton!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var durationCard: UIView!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var locationCard: UIView!
    @IBOutlet weak var customerLocation: GMSMapView!
    
    let dayFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let hourFormatter = DateFormatter()
    var revision : Revision?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        dayFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dayFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeFormatter.dateFormat = "dd MMM"
        hourFormatter.timeZone = .current
        hourFormatter.dateFormat = "HH mm"
        
        if let revision = invoiceDetails?.rentalObj?.revisions?.last {
            self.revision = revision
            if revision.revisionType != "rental" {
                if revision.isApproved == 0 {
                    type = "Requested"
                } else if revision.isApproved == 1 {
                    type = "Approved"
                    revisedBttn.isHidden = true
                } else {
                    type = "Declined"
                    revisedBttn.isHidden = true
                }
                viewUpdated()
            } else {
                viewOriginal()
                revisedBttn.isHidden = true
            }
            titleLabel.text = (revision.revisionType?.capitalizingFirstLetter() ?? "Rental") + type
        }
        
        if approvalStatus > 0 {
            approveBttn.isUserInteractionEnabled = false
            rejectBttn.isHidden = true
            rejectBttn.isUserInteractionEnabled = false
            if approvalStatus == 1 {
                approveBttn.setTitle("R E Q U E S T    A P P R O V E D", for: .normal)
            } else {
                approveBttn.setTitle("R E Q U E S T    D E C L I N E D", for: .normal)
            }
        } else if approvalStatus == -1 {
            approveBttn.isHidden = true
            approveBttn.isUserInteractionEnabled = false
            rejectBttn.isHidden = true
            rejectBttn.isUserInteractionEnabled = false
        }
        
        if ((drop || pickup) && approvalStatus != 0) {
            rejectBttn.isHidden = true
            rejectBttn.isUserInteractionEnabled = false
            approveBttn.isUserInteractionEnabled = true
            approveBttn.setTitle("B E G I N    D E L I V E R Y", for: .normal)
            approveBttn.isHidden = false
        }
        
        if invoiceDetails?.rentalObj?.rentalStatus == "delivered" {
            rejectBttn.isHidden = true
            rejectBttn.isUserInteractionEnabled = false
            approveBttn.isUserInteractionEnabled = true
            approveBttn.setTitle("C O M P L E T E   R E N T A L", for: .normal)
            approveBttn.isHidden = false
        }
        
        if invoiceDetails?.rentalObj?.rentalStatus == "returned" {
            rejectBttn.isHidden = true
            rejectBttn.isUserInteractionEnabled = false
            approveBttn.isUserInteractionEnabled = false
            approveBttn.setTitle("B O O K I N G   C O M P L E T E", for: .normal)
            approveBttn.isHidden = false
        }
        
        customerAddress.text = invoiceDetails?.rentalObj?.dropOffLocation?.text
        fetchRoute()
    }
    
    //TODO
    func viewUpdated() {
        let revisionFormatter = DateFormatter()
        revisionFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let sdate = dayFormatter.date(from: (revision?.start ?? ""))
        let edate = dayFormatter.date(from: (revision?.end ?? ""))
        
        if sdate != nil && edate != nil {
            fromDate.text = timeFormatter.string(from: sdate!)
            toDate.text = timeFormatter.string(from: edate!)
            
            from.text = hourFormatter.string(from: sdate!)
            to.text = hourFormatter.string(from: edate!)
        }
    }
    
    func viewOriginal() {
        let sdate = dayFormatter.date(from: (invoiceDetails?.rentalObj?.rentalPeriod?.start ?? "")!)
        let edate = dayFormatter.date(from: (invoiceDetails?.rentalObj?.rentalPeriod?.end ?? "")!)
        
        fromDate.text = timeFormatter.string(from: sdate!)
        toDate.text = timeFormatter.string(from: edate!)
        
        from.text = hourFormatter.string(from: sdate!)
        to.text = hourFormatter.string(from: edate!)
    }
    
    override func viewDidLayoutSubviews() {
        approveBttn.layer.cornerRadius = 14
        rejectBttn.layer.cornerRadius = 14
        revisedBttn.layer.cornerRadius = 7
        locationCard.makeCard()
        durationCard.makeCard()
        locationCard.makeBorder()
        durationCard.makeBorder()
        customerLocation.layer.cornerRadius = 12
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let trackingVC = segue.destination as? TrackingViewController {
            trackingVC.invoiceDetails = invoiceDetails
            trackingVC.drop = drop
            trackingVC.pickup = pickup
        }
        if let ratingVC = segue.destination as? RatingViewController {
            ratingVC.invoiceId = self.invoiceDetails?.rentalObj?.invoiceId ?? ""
        }
    }
    
    @IBAction func approveBttnTapped(_ sender: Any) {
        print("APPROVE TAPPED",drop,pickup)
        if invoiceDetails?.rentalObj?.rentalStatus == "returned"{
            
        } else if
            invoiceDetails?.rentalObj?.rentalStatus == "delivered" {
            updateTrailerStatus()
        } else {
            if invoiceDetails?.rentalObj?.isApproved == 0{
                    defineRentalType(approval: true)
                } else {
                    if drop || pickup {
                        self.performSegue(withIdentifier: "track", sender: Any?.self)
                    }
                }
            }
    }
    
    @IBAction func revisedBttnTapped(_ sender: Any) {
        if viewToggle == false {
            viewToggle = true
            self.revisedBttn.setTitle("VIEW UPDATED RENTAL", for: .normal)
            viewOriginal()
        } else {
            viewToggle = false
            self.revisedBttn.setTitle("VIEW ORIGINAL DATES", for: .normal)
            viewUpdated()
        }
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    @IBAction func rejectBttnTapped(_ sender: Any) {
        defineRentalType(approval: false)
    }
    
    
    func fetchRoute() {
        let sessionManager = Tracking()
        let endLocation = self.invoiceDetails?.rentalObj?.pickUpLocation?.coordinates
        if let licensee = Constant.loginDefaults?.value(forKey: Keys.licenseeObject) as? Data {
            print(licensee,"licenseeDATA")
            do {
                let licenseeObject = try JSONDecoder().decode(LicenseeDetails.self, from: licensee)
                let startLocation = licenseeObject.address?.coordinates
                let start = CLLocationCoordinate2D(latitude: startLocation![0], longitude: startLocation![1])
                let end = CLLocationCoordinate2D(latitude: endLocation![0], longitude: endLocation![1])
                print(start,"STARTING")
                print(end,"ENDING")
                
                sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, error) in
                    if let error = error {
                        ProgressHUD.showError(error.localizedDescription)
                    } else {
                        let polyline = GMSPolyline(path: path!)
                        polyline.strokeColor = .systemBlue
                        polyline.strokeWidth = 3
                        polyline.map = self.customerLocation
                        let bounds = GMSCoordinateBounds(path: path!)
                        let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
                        self.customerLocation.animate(with: cameraUpdate)
                    }
                })
            } catch {
                print("ERROR HERE")
                print(error.localizedDescription)
            }
        }
    }
    
    func defineRentalType(approval: Bool) {
        if(approval) {
            print("approval")
            formulateRequest(approval: "approved")
        } else {
            formulateRequest(approval: "rejected")
        }
    }
    
    func sendRequest(object: RequestApproval) {
        ProgressHUD.show("Forwarding your request")
        let requestObject = try! JSONEncoder().encode(object)
        
        approveBttn.disable()
        rejectBttn.disable()
        
        PostController.shared.requestManager(requestObject: requestObject) { (message, status) in
            if status {
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess(message)
                    self.performSegue(withIdentifier: "close", sender: Any?.self)
                }
            } else {
                DispatchQueue.main.async {
                    self.approveBttn.enable()
                    self.rejectBttn.enable()
                    ProgressHUD.showError(message)
                }
            }
        }
    }
    
    func formulateRequest(approval: String) {
        print("formulateRequest")
        let rentalApproval = RequestApproval(rentalId: self.invoiceDetails?.rentalObj?._id!, revisionId: self.revision?.id, approvalStatus: approval)
        sendRequest(object: rentalApproval)
    }
    
    func updateTrailerStatus(){
        let trailerStatus = TrailerStatus(rentalId: invoiceDetails?.rentalObj?.invoiceId ?? "", status: "returned", driverLicenseScan: "")
        PostController.shared.trailerStatusUpdate(trailerStatus) { (success, error) in
            if success {
                ProgressHUD.showSuccess("Successfully Returned trailer")
                self.performSegue(withIdentifier: "rating", sender: nil)
            } else {
                ProgressHUD.showError(error)
            }
        }
    }
    
    
}
