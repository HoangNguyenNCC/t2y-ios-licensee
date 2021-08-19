//
//  UpsellViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 16/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import Kingfisher
import iOSDropDown
import ProgressHUD
import NotificationCenter

class UpsellViewController: UIViewController {
    
    var editingUpsell : GetUpsellDetails? = nil
    var operation = ""
    var trailers: AllItems? = nil
    var newUpsell : AddUpsellItem?
    var upsellSelected = -1
    var upsellId: String? = nil
    var photoStream: [UIImage] = []
    var upsellList : [String] = []
    var photosBase = [String]()
    var adminUpsellList: UpsellListings? = nil
    
    var adminTrailer: TrailerListings? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeBttn: UIButton!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var addUpsellBttn: UIButton!
    
    @IBOutlet weak var salesChargesView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var itemView: UIView!
    
    @IBOutlet weak var itemName: DropDown!
    @IBOutlet weak var saleUnitStepper: UIStepper!
    @IBOutlet weak var saleUnits: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var addPhotoBttn: UIButton!
    @IBOutlet weak var photoPreview: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        photoCollection.dataSource = self
        photoCollection.delegate = self
        
        itemName.selectedRowColor = .lightGray
        saleUnitStepper.minimumValue = 0
        
        if operation == OperationType.edit.rawValue {
            titleLabel.text = "Edit Upsell Item"
        }
        
        ServiceController.shared.getAdminUpsell { (adminUpsell, status, error) in
            if status {
                DispatchQueue.main.async {
                    self.adminUpsellList = adminUpsell
                    var i = 0
                    
                    for item in (self.adminUpsellList?.upsellItemsList)! {
                        if self.operation == OperationType.edit.rawValue {
                            if item.id == self.editingUpsell?.upsellItemObj?.adminRentalItemId {
                                self.itemName.text = item.name
                                self.upsellSelected = i
                                self.editSetup(index: i)
                            }
                            i+=1
                        }
                        self.upsellList.append(item.name!)
                    }
                    self.itemName.optionArray = self.upsellList
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error ?? "")
                }
            }
        }
        
        ServiceController.shared.getAdminTrailers { (result, status, error) in
            if status {
                self.adminTrailer = result
            }
        }
        
        ServiceController.shared.getLicenseeTrailers { (result, status, error) in
            if status {
                self.trailers = result
            }
        }
        
        self.itemName.didSelect{(selectedText , index ,id) in
            self.upsellSelected = index
            self.descriptionTextView.text = self.adminUpsellList?.upsellItemsList?[index].upsellItemsListDescription!
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func editSetup(index: Int) {
        itemName.selectedIndex = index
        descriptionTextView.text = editingUpsell?.upsellItemObj?.description
        
        let quantity = editingUpsell?.upsellItemObj?.quantity ?? 0
        saleUnits.text = "QUANTITY: \(quantity)"
        saleUnitStepper.value = Double(quantity)
        for item in editingUpsell?.upsellItemObj?.photos ?? [] {
            if let url = URL(string: item.data ?? ""){
            KingfisherManager.shared.retrieveImage(with: url , options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                if let image = image {
                    self.photoStream.append(image)
                } else {
                    print(error)
                }
            })
                
            }
            
            if editingUpsell?.upsellItemObj?.photos.count == self.photoStream.count {
                DispatchQueue.main.async {
                    self.photoCollection.reloadData()
                    self.photoPreview.image = self.photoStream[0]
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        itemView.makeCard()
        salesChargesView.makeCard()
        descriptionView.makeCard()
        addUpsellBttn.layer.cornerRadius = 14
        photoPreview.layer.cornerRadius = 24
        photoPreview.makeBorder()
    }
    
    @IBAction func addPhotoBttnTapped(_ sender: Any) {
        importPicture()
    }
    
    @IBAction func saleUnitsStepper(_ sender: Any) {
        saleUnits.text = "QUANTITY : \(Int(saleUnitStepper.value))"
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        performSegue(withIdentifier: "upsellToRequest", sender: Any?.self)
    }
    
    @IBAction func addUpsellBttnTapped(_ sender: Any) {
        
        if upsellSelected < 0 || descriptionTextView.text.isEmpty || photoStream.count <= 0 || saleUnitStepper.value <= 0  {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
            for item in photoStream {
                if let photo = item.pngData()?.base64EncodedString(){
                    photosBase.append(photo)
                }
            }
            
        let upsellObject = adminUpsellList?.upsellItemsList?[itemName.selectedIndex!]
            
            let model = self.editingUpsell?.upsellItemObj?.trailerModel
      
        let newUpsell = AddUpsellItem(_id: upsellId, name: (upsellObject?.name!)!, photos: photosBase, description: descriptionTextView.text, availability: true, type: (upsellObject?.type!)!, trailerModel: model , quantity: Int(saleUnitStepper.value), adminRentalItemId: (upsellObject?.id!)!)
            
           performSegue(withIdentifier: "link", sender: newUpsell)
        }
    }
    

    
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TrailersViewController {
            vc.titlePhoto = photoStream[0]
            vc.operation = operation
            vc.myItems = trailers
            vc.adminTrailerList = adminTrailer
            vc.upsell = sender as? AddUpsellItem
        }
    }
}

extension UpsellViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoStream.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "upsell", for: indexPath) as! PhotoCell
        item.trailerPhoto.image = photoStream[indexPath.item]
        item.trailerPhoto.layer.cornerRadius = item.trailerPhoto.frame.width/2
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoPreview.image = photoStream[indexPath.item]
    }
}

extension UpsellViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func trailerPicker(_ sender: Any) {
        self.performSegue(withIdentifier: "getTrailer", sender: Any?.self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.photoPreview.image = image
            self.photoStream.insert(image, at: 0)
            self.photoCollection.reloadData()
            self.dismiss(animated: true)
        }
    }
}
