//
//  EditTrailerViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 08/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD
import MobileCoreServices
import NotificationCenter

class EditTrailerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var operation = ""
    var photoStream = [UIImage]()
    var index = -1
    var photosBase = [String]()
    var itemId = ""
    var trailerDetails: TrailerDetails? = nil
    
    @IBOutlet weak var dlrTextField: UITextField!
    @IBOutlet weak var dlrView: UIView!
    @IBOutlet weak var pickupStepper: UIStepper!
    @IBOutlet weak var pickupDurationLabel: UILabel!
    @IBOutlet weak var doorToDoorDurationLabel: UILabel!
    @IBOutlet weak var doorToDoorCharges: UITextField!
    @IBOutlet weak var doorToDoorDuration: UIStepper!
    @IBOutlet weak var closeBttn: UIButton!
    @IBOutlet weak var tareView: UIView!
    @IBOutlet weak var pickUpChargesTextField: UITextField!
    @IBOutlet weak var doorToDoorView: UIView!
    @IBOutlet weak var tareTextField: UITextField!
    @IBOutlet weak var removePhotoBttn: UIButton!
    @IBOutlet weak var availabilitySwitch: UISwitch!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var capcityTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var vinNumberTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var trailerNameTextField: UITextField!
    @IBOutlet weak var addTrailerBttn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var capacityView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var insuranceView: UIView!
    @IBOutlet weak var vinNumberView: UIView!
    @IBOutlet weak var trailerNameView: UIView!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var addPhotoBttn: UIButton!
    @IBOutlet weak var trailerPreview: UIImageView!
    @IBOutlet weak var insuranceBttn: UIButton!
    
    var insuranceData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trailerNameTextField.text = trailerDetails?.name
        vinNumberTextField.text = trailerDetails?.vin
        descriptionTextView.text = trailerDetails?.description
        sizeTextField.text = trailerDetails?.size
        typeTextField.text = trailerDetails?.type
        capcityTextField.text = trailerDetails?.capacity
        tareTextField.text = trailerDetails?.tare
        dlrTextField.text =  "\(String(describing: trailerDetails?.dlrCharges))"
        ageTextField.text = "\(String(describing: trailerDetails?.age))"
        overrideUserInterfaceStyle = .light
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        photosBase = trailerDetails?.photos.map { ($0.data ?? "") } ?? []
        
        photoCollection.reloadData()
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
        doorToDoorView.makeCard()
        pickupView.makeCard()
        availabilityView.makeCard()
        locationView.makeCard()
        capacityView.makeCard()
        typeView.makeCard()
        descriptionView.makeCard()
        sizeView.makeCard()
        insuranceView.makeCard()
        vinNumberView.makeCard()
        trailerNameView.makeCard()
        addTrailerBttn.layer.cornerRadius = 14
    }
    
    @IBAction func pickupStepped(_ sender: Any) {
        pickupDurationLabel.text = "Duration :\(pickupStepper.value) DAYS"
    }
    
    @IBAction func doorToDoorStepped(_ sender: Any) {
        pickupDurationLabel.text = "Duration :\(doorToDoorDuration.value) DAYS"
    }
    
    @IBAction func removePhotoBttnTapped(_ sender: Any) {
        if photoStream.count > 0 {
            photoStream.remove(at: index)
            photoCollection.reloadData()
        } else {}
    }
    
    @IBAction func insuranceBttnTapped(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String, kUTTypePNG as String, kUTTypeImage as String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.trailerPreview.image = image
            self.photoStream.insert(image, at: 0)
            self.photoCollection.reloadData()
            self.dismiss(animated: true)
        }
    }

    @IBAction func updateBttnTapped(_ sender: Any) {
        if trailerNameTextField.text?.isEmpty ?? true || vinNumberTextField.text?.isEmpty ?? true || sizeTextField.text?.isEmpty ?? true || descriptionTextView.text.isEmpty || typeTextField.text?.isEmpty ?? true || capcityTextField.text?.isEmpty ?? true || locationTextField.text?.isEmpty ?? true || pickUpChargesTextField.text?.isEmpty ?? true || ageTextField.text?.isEmpty ?? true || photoStream.count <= 0 || insuranceData == "" || doorToDoorCharges.text?.isEmpty ?? true || pickupStepper.value > 0 || doorToDoorDuration.value > 0 {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
            for item in photoStream {
                photosBase.append((item.pngData()?.base64EncodedString())!)
            }
//            updateTrailer()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    func updateTrailer() {
//        ProgressHUD.show("Updating Trailer")
//        let age = Int(ageTextField.text!)!
//        let pickupDuration = Int(pickupStepper.value)
//        let pickupCharges = Int(pickUpChargesTextField.text!)!
//        let doorDuration = Int(doorToDoorDuration.value)
//        let doorCharges = Int(doorToDoorCharges.text!)!
//        let dlr = Double(dlrTextField.text!)!
//
//        let trailer = AddTrailer(id: trailerDetails?.id,name: trailerNameTextField.text!, vin: vinNumberTextField.text!, type: typeTextField.text!, description: descriptionTextView.text, size: sizeTextField.text!, capacity: capcityTextField.text!, tare: tareTextField.text!, age: age, features: [descriptionTextView.text], photos: photosBase, availability: availabilitySwitch.isOn, rentalCharges: RentalChargesResponse(pickUp: [Door2DoorResponse(duration: pickupDuration, charges: pickupCharges)], door2Door: [Door2DoorResponse(duration: doorDuration, charges: doorCharges)]), dlrCharges: dlr, licenseeID: Defaults.licenseeID())
//
//        let trailerObj = try! JSONEncoder().encode(trailer)
//
//        WebHelper.sendPostRequest(NetworkConstants.addTrailerURL, parameters: [:], header: true, requestBody: trailerObj) { (data, errorStatus) in
//            if(data != nil && errorStatus == 2) {
//                ProgressHUD.dismiss()
//                guard let data = data else { return }
//                let addTrailerResp = try! JSONDecoder().decode(AddTrailerResponse.self, from: data)
//                DispatchQueue.main.async {
//                    if addTrailerResp.success == 1 {
//                        ProgressHUD.showSuccess(addTrailerResp.message)
//                    }
//                }
//            } else if(data != nil && errorStatus == 1) {
//                guard let data = data else { return }
//                let errorResp = try! JSONDecoder().decode(ErrorModel.self, from: data)
//                DispatchQueue.main.async {
//                    ProgressHUD.showError(errorResp.message)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    ProgressHUD.showError(NetworkErrors.serverUnavailable)
//                }
//            }
//        }
//    }
    
}

extension EditTrailerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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

extension EditTrailerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        let fileURL = selectedFile
        
        do {
            let mediaD = try Data(contentsOf: fileURL)
            let response = mediaD.base64EncodedString()
            insuranceData = response
            self.insuranceBttn.setTitle("File added", for: .normal)
            self.insuranceBttn.setTitleColor(UIColor.darkGray, for: .normal)
            
        } catch {
            ProgressHUD.showError(Strings.fileError)
        }
    }
}

