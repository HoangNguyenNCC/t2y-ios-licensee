//
//  AddTrailerViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 05/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import Kingfisher
import iOSDropDown
import ProgressHUD
import MobileCoreServices
import NotificationCenter

class AddTrailerViewController: UIViewController {
    
    var trailerDetails : GetTrailerDetails? = nil
    var trailer : AddTrailer? = nil
    var index = -1
    var trailerList: [String] = []
    var trailerSelected = false
    var photoStream = [UIImage]()
    var trailerIndex = -1
    var photosBase = [String]()
    var adminTrailerList : TrailerListings? = nil
    var operation = ""
    var adminIdTrailer = ""
    var trailerModel = ""
    var upsell: AllItems? = nil
    var adminUpsell: UpsellListings? = nil
    
    @IBOutlet weak var pageDescription: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var closeBttn: UIButton!
    @IBOutlet weak var tareView: UIView!
    @IBOutlet weak var tareTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var capcityTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var vinNumberTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var addTrailerBttn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var capacityView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var vinNumberView: UIView!
    @IBOutlet weak var trailerNameView: UIView!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var addPhotoBttn: UIButton!
    @IBOutlet weak var trailerPreview: UIImageView!
    @IBOutlet weak var trailerName: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        vinNumberTextField.delegate = self
        ageTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        trailerName.selectedRowColor = .lightGray
        
        DispatchQueue.main.async {
            ProgressHUD.show("Fetching Latest Trailers")
        }
        
        if operation == OperationType.edit.rawValue {
            addTrailerBttn.setTitle("UPDATE TRAILER", for: UIControl.State.normal)
        }
        
        if let trailer = self.trailerDetails{
            preEditSetup()
        }
        
        ServiceController.shared.getAdminTrailers { (adminTrailers, status, error) in
            ProgressHUD.dismiss()
            if status {
                ProgressHUD.dismiss()
                self.adminTrailerList = adminTrailers
                for item in (self.adminTrailerList?.trailersList)! {
                    self.trailerList.append(item.name!)
                }
                self.trailerName.optionArray = self.trailerList
                if self.operation == OperationType.edit.rawValue {
                    DispatchQueue.main.async {
                        self.editSetup()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.setup()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error ?? "Error")
                }
            }
        }
        
        ServiceController.shared.getLicenseeUpsell { (licenseeUpsell, status, error) in
            if status {
                self.upsell = licenseeUpsell
            }
        }
        
        ServiceController.shared.getAdminUpsell { (adminUpsell, status, error) in
            if status {
                self.adminUpsell = adminUpsell

            }
        }
        
    }
    
    func preEditSetup(){
        self.trailerName.text = self.trailerDetails?.trailerObj?.name
        self.sizeTextField.text = self.trailerDetails?.trailerObj?.size
        self.tareTextField.text = self.trailerDetails?.trailerObj?.tare
        self.capcityTextField.text = self.trailerDetails?.trailerObj?.capacity
        self.descriptionTextView.text = self.trailerDetails?.trailerObj?.description
        self.typeTextField.text = self.trailerDetails?.trailerObj?.type
        self.vinNumberTextField.text = trailerDetails?.trailerObj?.vin
        self.ageTextField.text = "\(trailerDetails?.trailerObj?.age ?? 0)"
        
        for photo in trailerDetails?.trailerObj?.photos ?? [] {
            KingfisherManager.shared.retrieveImage(with: URL(string: photo.data ?? "")!, options: nil, progressBlock: nil) { (image, error, _, _) in
                if error == nil {
                    self.photoStream.append(image!)
                    if(self.photoStream.count == self.trailerDetails?.trailerObj?.photos.count) {
                        DispatchQueue.main.async {
                            self.photoCollection.reloadData()
                        }
                    }
                }
            }
        }
        trailerPreview.image = self.photoStream[0]
    }
    
    func editSetup() {
        var i = 0
        for item in adminTrailerList?.trailersList! ?? [] {
            if item.id == trailerDetails?.trailerObj?.trailerModel! {
                trailerName.selectedIndex = i
                self.trailerIndex = i
                trailerName.text = trailerList[trailerName.selectedIndex ?? 0]
                break
            }
            i+=1
        }
        
        self.sizeTextField.text = self.adminTrailerList?.trailersList?[i].size!
        self.tareTextField.text = self.adminTrailerList?.trailersList?[i].tare!
        self.capcityTextField.text = self.adminTrailerList?.trailersList?[i].capacity!
        self.descriptionTextView.text = trailerDetails?.trailerObj?.description
        self.typeTextField.text = self.adminTrailerList?.trailersList?[i].type!
        self.vinNumberTextField.text = trailerDetails?.trailerObj?.vin
        self.ageTextField.text = "\(trailerDetails?.trailerObj?.age ?? 0)"
        
        trailerSelected = true
        setup()
    }
    
    func setup() {
        self.trailerName.didSelect{(selectedText , index ,id) in
            self.trailerIndex = index
            self.trailerSelected = true
            self.trailerModel = (self.adminTrailerList?.trailersList?[index].trailerModel)!
            self.sizeTextField.text = self.adminTrailerList?.trailersList?[index].size!
            self.tareTextField.text = self.adminTrailerList?.trailersList?[index].tare!
            self.capcityTextField.text = self.adminTrailerList?.trailersList?[index].capacity!
            self.descriptionTextView.text = self.adminTrailerList?.trailersList?[index].trailersListDescription!
            self.typeTextField.text = self.adminTrailerList?.trailersList?[index].type!
            self.adminIdTrailer = (self.adminTrailerList?.trailersList?[index].id!)!
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
    
    override func viewDidAppear(_ animated: Bool) {
        photoCollection.dataSource = self
        photoCollection.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        ageView.makeCard()
        capacityView.makeCard()
        typeView.makeCard()
        descriptionView.makeCard()
        sizeView.makeCard()
        tareView.makeCard()
        vinNumberView.makeCard()
        trailerNameView.makeCard()
        addTrailerBttn.layer.cornerRadius = 14
        trailerPreview.makeBorder()
        trailerPreview.layer.cornerRadius = 24
    }
    
    @IBAction func addPhotoBttnTapped(_ sender: Any) {
        importPicture()
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func addTrailerBttnTapped(_ sender: Any) {
        if !trailerSelected || vinNumberTextField.text?.isEmpty ?? true ||  ageTextField.text?.isEmpty ?? true || photoStream.count <= 0 {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
            for item in photoStream {
                let baseImage = (item.pngData()?.base64EncodedString())!
                photosBase.append(baseImage)
            }
            addTrailer()
        }
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "trailerToRequest", sender: Any?.self)
    }
    
    func addTrailer() {
        let age = Int(ageTextField.text!)!
        var trailerId: String? = nil
        
        if operation == OperationType.edit.rawValue {
            trailerId = trailerDetails?.trailerObj?.id
        }
        
        trailer = AddTrailer(id: trailerId, name: trailerList[trailerIndex], vin: vinNumberTextField.text!, type: typeTextField.text!, description: descriptionTextView.text, size: sizeTextField.text!, capacity: capcityTextField.text!, tare: tareTextField.text!, age: age, photos: photosBase, licenseeID: Defaults.licenseeID(), insurance: nil, service: nil, linkedUpsell: [], adminRentalItemId: adminIdTrailer, trailerModel: trailerModel)
        
        print(trailerModel)
        
        if operation == OperationType.edit.rawValue {
            updateTrailer(trailer!)
        } else {
            self.performSegue(withIdentifier: "insurance", sender: Any?.self) //TODO
        }
    }
    
    func updateTrailer(_ trailer : AddTrailer) {
        PostController.shared.addTrailer(trailer, update: true) { (status, message) in
            print(status,message)
            if status {
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess(message ?? "Success")
                    self.performSegue(withIdentifier: "close", sender: Any?.self) //TODO
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError(message ?? "Error")
                    self.addTrailerBttn.enable()
                }
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TrailersViewController {
            vc.trailer = trailer
            vc.titlePhoto = photoStream[0]
            vc.operation = operation
            vc.myItems = upsell
            vc.adminUpsellList = adminUpsell
            vc.adminTrailerList = adminTrailerList
        }
        
        if let vc = segue.destination as? InsuranceViewController {
            vc.trailer = trailer
            vc.titlePhoto = photoStream[0]
        }
    }
}

extension AddTrailerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoStream.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trailer", for: indexPath) as! PhotoCell
        cell.trailerPhoto.image = photoStream[indexPath.item]
        cell.trailerPhoto.layer.cornerRadius = cell.trailerPhoto.frame.width/2
        cell.trailerPhoto.layer.borderWidth = 2
        cell.trailerPhoto.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        trailerPreview.image = photoStream[indexPath.item]
        index = indexPath.item
    }
}

extension AddTrailerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.trailerPreview.image = image
            self.photoStream.insert(image, at: 0)
            self.photoCollection.reloadData()
            self.dismiss(animated: true)
        }
    }
}

extension AddTrailerViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(donePressed))
        toolBar.setItems([flexibleSpace, doneBarButton], animated: true)
        textField.inputAccessoryView = toolBar
        textField.becomeFirstResponder()
    }
    
    @objc
    func donePressed() {
        vinNumberTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
    }
}
