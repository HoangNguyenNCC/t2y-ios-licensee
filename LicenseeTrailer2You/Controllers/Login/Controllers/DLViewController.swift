

import Foundation
import UIKit
import VisionKit
import PDFKit
import iOSDropDown
import NotificationCenter

// MARK: - Protocols
protocol DLDelegate : class {
    func returnDLData(License: DriverLicense)
}

class DLViewController : UIViewController {

    let states = ["New South Wales", "Victoria", "Queensland", "Western Australia", "South Australia", "Tasmania"]
    // MARK: - Declarations
    @IBOutlet weak var DLView: UIView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expiryTextField: UITextField!
   
    @IBOutlet weak var addScanBttn: UIButton!
    @IBOutlet weak var stateField: DropDown!
    
    var scan: String?
    var state = ""
    weak var delegate: DLDelegate?
    var datePickerView = UIDatePicker()
    var expiryDate = ""
    
    var license : DriverLicense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        overrideUserInterfaceStyle = .light
        
        stateField.selectedRowColor = .lightGray
        expiryTextField.delegate = self
        expiryTextField.inputView = datePickerView
        stateField.optionArray = states
        
        datePickerView.minimumDate = Date()
        datePickerView.date = Date().addYears(n: 1)
        if #available(iOS 13.4, *) { datePickerView.preferredDatePickerStyle = .wheels }

        stateField.didSelect{(selectedText , index ,id) in
            self.state = self.states[index]
        }
        
        self.isModalInPresentation = true
        
        if let license = self.license {
            stateField.text = license.state
            expiryTextField.text = license.expiry
            cardNumberTextField.text = license.card
            if license.scan?.data != "" || license.scan?.data != nil  {
                self.addScanBttn.setTitle("Scan Added", for: UIControl.State.normal)
                self.scan = license.scan?.data ?? ""
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdfVC = segue.destination as? PDFViewController {
            pdfVC.pdfData = Data(base64Encoded: scan ?? "") ?? Data()
        }
    }
    

    
    // MARK: - Buttons
    @IBAction func addScanTapped(_ sender: Any) {
        let action = UIAlertController(title: "", message: "Select Scan", preferredStyle: .actionSheet)
          if scan != nil {
              action.addAction(UIAlertAction(title: "View Scan", style: .default, handler: { (a) in
                  self.performSegue(withIdentifier: "scan", sender: Any?.self)
              }))
          }
          action.addAction(UIAlertAction(title: "Click a scan", style: .default, handler: { (a) in
              let documentCameraViewController = VNDocumentCameraViewController()
              documentCameraViewController.delegate = self
              self.present(documentCameraViewController, animated: true)
          }))
          action.addAction(UIAlertAction(title: "Pick a scan", style: .default, handler: { (a) in
              let picker = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
              picker.delegate = self
              picker.allowsMultipleSelection = false
              self.present(picker, animated: true, completion: nil)
          }))
          action.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
          self.present(action, animated: true)
    }
    
    @IBAction func addLicenseTapped(_ sender: Any) {
        if let scan = scan {
            let license = DriverLicense(card: cardNumberTextField.text, expiry: expiryTextField.text, state: state, scan: Photo(contentType: "application/pdf", data: scan))
            delegate?.returnDLData(License: license)
            self.dismiss(animated: true, completion: nil)
            self.addScanBttn.setTitle("Scan Added", for: UIControl.State.normal)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Layouts
    
    override func viewDidLayoutSubviews() {
        DLView.layer.cornerRadius = 8
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   @objc func cancelPressed() {
       expiryTextField.resignFirstResponder()
   }
    
   @objc func donePressed() {
       expiryTextField.resignFirstResponder()
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "dd.MM.yyyy"
    expiryDate = dateformatter.string(from: datePickerView.date)
    expiryTextField.text = expiryDate
    dateformatter.dateFormat = "yyyy-MM-dd"
    expiryDate = dateformatter.string(from: datePickerView.date)
   }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height*2/3
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension DLViewController : VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
       
        let pdf = PDFDocument()
        let pdfPage = PDFPage(image: scan.imageOfPage(at: 0))
        pdf.insert(pdfPage!, at: 0)
        self.scan = (pdf.dataRepresentation()?.base64EncodedString() ?? "")
        self.addScanBttn.setTitle("View Scan", for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        self.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DLViewController : UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let data = try! Data(contentsOf: url)
        //licenseData = data
        scan = data.base64EncodedString()
        addScanBttn.setTitle("View Scan", for: .normal)
    }
}

extension DLViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == expiryTextField {
            textField.inputView = datePickerView
            datePickerView.datePickerMode = .date
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
            let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(donePressed))
            toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: true)
            textField.inputAccessoryView = toolBar
            textField.becomeFirstResponder()
        }
    }
}

