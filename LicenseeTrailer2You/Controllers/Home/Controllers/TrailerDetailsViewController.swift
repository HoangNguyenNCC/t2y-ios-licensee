//
//  TrailerDetailsViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 22/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import WebKit
import ProgressHUD
import Kingfisher

class TrailerDetailsViewController: UIViewController {
    
    var typeIndex = 0
    //var trailertype = ""
    var trailerId = ""
    var trailerDetails: GetTrailerDetails? = nil
    var itemImages: [UIImage] = []
    var licenses : Documents? = nil
    
    @IBOutlet weak var trailerStatus: UILabel!
    @IBOutlet weak var trailerLinkedCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editTrailerBttn: UIButton!
    @IBOutlet weak var chargeScheduleBttn: UIButton!
    @IBOutlet weak var trailerStatusBttn: UIButton!
    @IBOutlet weak var rentalHistoryBttn: UIButton!
    @IBOutlet weak var trailerLinkedItems: UICollectionView!
    @IBOutlet weak var trailerInsurance: UIImageView!
    @IBOutlet weak var trailerLicenses: UIImageView!
    @IBOutlet weak var trailerPhoto: UIImageView!
    @IBOutlet weak var trailerName: UILabel!
    @IBOutlet weak var upsellLabel: UILabel!
    @IBOutlet weak var vin: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var capacity: UITextField!
    @IBOutlet weak var tare: UITextField!
    @IBOutlet weak var age: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        trailerPhoto.makeBorder()
        if Defaults.getPrivileges(key: AccessCategory.TRAILER.localized(), access: AccessType.EDIT.rawValue) {
            editTrailerBttn.isHidden = false
        }
        
        ServiceController.shared.getTrailerDetails(trailerId: trailerId) { (trailerDetails, status, error) in
            if status {
                DispatchQueue.main.async {
                    self.trailerDetails = trailerDetails
                    self.setupTrailer()
                    ProgressHUD.dismiss()
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error ?? "Error")
                }
            }
        }
        
        let serviceTap = UITapGestureRecognizer(target: self, action: #selector(TrailerDetailsViewController.viewService))
        trailerLicenses.addGestureRecognizer(serviceTap)
        
        let insuranceTap = UITapGestureRecognizer(target: self, action: #selector(TrailerDetailsViewController.viewInsurance))
        trailerInsurance.addGestureRecognizer(insuranceTap)
        
        descriptionLabel.text = "Trailer Details"
        editTrailerBttn.setTitle("EDIT TRAILER", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if trailerDetails == nil {
            ProgressHUD.show("Fetching Trailer Details")
        }
    }
    
    func setupTrailer() {
        let trailer = trailerDetails?.trailerObj
        trailerName.text = trailer?.name
        vin.text = trailer?.vin
        size.text = trailer?.size
        descriptionLabel.text = trailer?.description
        type.text = trailer?.type
        capacity.text = trailer?.capacity
        tare.text = trailer?.tare
        age.text = String(trailer?.age ?? 0)
        
        guard let thumbURL = trailerDetails?.trailerObj?.photos.first?.data else { return }
        trailerPhoto.kf.setImage(with: URL(string: thumbURL))
        
        if trailerDetails?.upsellItemsList?.count != 0 {
            upsellLabel.alpha = 1
            trailerLinkedItems.dataSource = self
            trailerLinkedItems.delegate = self
        } else {
            upsellLabel.alpha = 0
            trailerLinkedCollectionHeight.constant = 0
        }
        
        if trailerDetails?.trailerObj?.availability ?? false {
            trailerStatus.text = "Active"
            trailerStatus.textColor = .green
        } else {
            trailerStatus.text = "Inactive"
            trailerStatus.textColor = .red
        }
    }
    
    override func viewDidLayoutSubviews() {
        rentalHistoryBttn.layer.cornerRadius = 14
        trailerStatusBttn.layer.cornerRadius = 14
        chargeScheduleBttn.layer.cornerRadius = 14
        editTrailerBttn.layer.cornerRadius = 14
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    @IBAction func rentalHistoryBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "rentals", sender: Any?.self)
    }
    
    @IBAction func chargeScheduleBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "charges", sender: Any?.self)
    }
    
    @IBAction func editTrailerBttnTapped(_ sender: Any) {
        //TODO
        //        if(Defaults.getPrivileges(key: AccountManagementKeys.UPDATE_TRAILER.rawValue)) {
        self.performSegue(withIdentifier: "edit", sender: Any?.self)
        //        } else {
        ProgressHUD.showError(Strings.permissionDataMessage)
        //        }
    }
    
    @objc func viewService() {
        if Defaults.getPrivileges(key: AccessCategory.SERVICING.localized(), access: AccessType.VIEW.rawValue) {
            viewDocument(type: .servicing)
        } else {
            ProgressHUD.showError(Strings.permissionDataMessage)
        }
    }
    
    @objc func viewInsurance() {
        if Defaults.getPrivileges(key: AccessCategory.INSURANCE.localized(), access: AccessType.VIEW.rawValue) {
            viewDocument(type: .insurance)
        } else {
            ProgressHUD.showError(Strings.permissionDataMessage)
        }
    }
    
    func viewDocument(type: DocumentType) {
        let alert = UIAlertController(title: "Trailer Documents", message: "Please Select an Option", preferredStyle: .actionSheet)
        let viewAction = UIAlertAction(title: "View \(type)", style: .default , handler:{ (UIAlertAction) in
            if type == .servicing {
                self.performSegue(withIdentifier: "documents", sender: DocumentType.servicing)
            } else if type == .insurance {
                self.performSegue(withIdentifier: "documents", sender: DocumentType.insurance)
            }
        })
        
        let addAction = UIAlertAction(title: "Add \(type)", style: .default , handler:{ (UIAlertAction) in
            if type == .servicing {
                if Defaults.getPrivileges(key: AccessCategory.INSURANCE.localized(), access: AccessType.ADD.rawValue) {
                    self.performSegue(withIdentifier: "addService", sender: Any.self)
                }
            } else if type == .insurance {
                if Defaults.getPrivileges(key: AccessCategory.INSURANCE.localized(), access: AccessType.ADD.rawValue) {
                    self.performSegue(withIdentifier: "addInsurance", sender: Any.self)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction) in
        })
        
        viewAction.isEnabled = false
        addAction.isEnabled = false
        
        if type == .insurance {
            if Defaults.getPrivileges(key: AccessCategory.INSURANCE.localized(), access: AccessType.VIEW.rawValue) {
                viewAction.isEnabled = true
            }
            
            if Defaults.getPrivileges(key: AccessCategory.INSURANCE.localized(), access: AccessType.ADD.rawValue) {
                addAction.isEnabled = true
            }
        }
        
        if type == .servicing {
            if Defaults.getPrivileges(key: AccessCategory.SERVICING.localized(), access: AccessType.VIEW.rawValue) {
                viewAction.isEnabled = true
            }
            if Defaults.getPrivileges(key: AccessCategory.SERVICING.localized(), access: AccessType.ADD.rawValue) {
                addAction.isEnabled = true
            }
        }
        alert.addAction(viewAction)
        
        alert.addAction(addAction)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let thumbURL = trailerDetails?.trailerObj?.photos.first else { return }
        if let chargesVC = segue.destination as? ChargesViewController {
            chargesVC.trailerId = trailerId
        }
        
        if let editVC = segue.destination as? AddTrailerViewController {
            editVC.trailerDetails = trailerDetails
            editVC.operation = OperationType.edit.rawValue
        }
        
        if let rentalsVC = segue.destination as? RentalHistoryViewController {
            rentalsVC.trailerDetails = trailerDetails
        }
        
        if let serviceVC = segue.destination as? ServiceViewController {
            serviceVC.operation = OperationType.add.rawValue
            serviceVC.editId = (trailerDetails?.trailerObj!.id)!
            serviceVC.titlePhotoURL = thumbURL.data ?? ""
            serviceVC.editingTrailer = (trailerDetails?.trailerObj!.name)!
        }
        
        if let insuranceVC = segue.destination as? InsuranceViewController {
            insuranceVC.operation = OperationType.add.rawValue
            insuranceVC.editId = (trailerDetails?.trailerObj!.id)!
            insuranceVC.titlePhotoURL = thumbURL.data ?? ""
            insuranceVC.editingTrailer = (trailerDetails?.trailerObj!.name)!
        }
        
        if let documentVC = segue.destination as? DocumentListViewController {
            documentVC.trailerID = self.trailerId
            if let doc = sender as? DocumentType{
                documentVC.docType = doc
                documentVC.trailer = self.trailerDetails?.trailerObj
            }
        }
    }
}

extension TrailerDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trailerDetails?.upsellItemsList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "linkedItem", for: indexPath) as! LinkedItemCell
        
        let image = URL(string: trailerDetails?.upsellItemsList?[indexPath.item].photo.data ?? "")
        item.linkedItem.text = trailerDetails?.upsellItemsList?[indexPath.item].name
        
        let processor = DownsamplingImageProcessor(size: item.linkedItemPhoto.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 25)
        
        let url = URL(string: trailerDetails?.upsellItemsList?[indexPath.row].photo.data ?? "")
        
        item.linkedItemPhoto.kf.indicatorType = .activity
        item.linkedItemPhoto.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ])
        
        item.linkedItemPhoto.layer.cornerRadius = 24
        item.makeBorder()
        item.makeCard()
        
        return item
    }
}

enum DocumentType {
    case insurance
    case servicing
}
