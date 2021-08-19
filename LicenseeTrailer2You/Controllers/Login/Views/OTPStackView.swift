//
//  OTPStackView.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 20/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit

var textFieldsCollection: [OTPTextField] = []

protocol OTPDelegate: class {
    func didChangeValidity(isValid: Bool)
}

class OTPStackView: UIStackView {
    
    let numberOfFields = 4
    
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    
    let inactiveFieldBorderColor = UIColor(named: "lightGrey")
    let textBackgroundColor = UIColor(named: "lightGrey")
    let activeFieldBorderColor = UIColor.black
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }
    
    func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 5
    }
    
    func addOTPFields() {
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
        textFieldsCollection[0].becomeFirstResponder()
        print(textFieldsCollection)
    }
    
    func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        textField.backgroundColor = textBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: "Avenir Next", size: 20)
        textField.textColor = .black
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = inactiveFieldBorderColor?.cgColor
        textField.keyboardType = .numberPad
    }
    
    func checkForValidity(){
        for fields in textFieldsCollection{
            if (fields.text == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    func getOTP() -> String {
        var OTP = ""
        print(textFieldsCollection.count)
        for textField in textFieldsCollection {
            OTP += textField.text ?? ""
        }
        return OTP
    }

    func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
}

extension OTPStackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor ?? UIColor.lightGray)
            showsWarningColor = false
        }
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = inactiveFieldBorderColor?.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        
        guard let textField = textField as? OTPTextField else { return true }
        
        if (range.length == 0){
            
            if textField.nextTextField == nil {
                textField.resignFirstResponder()
            }else{
                textField.nextTextField?.becomeFirstResponder()
            }
            textField.text? = string
            checkForValidity()
            return false
            
        }
        else if (range.length == 1) {
            
            textField.previousTextField?.becomeFirstResponder()
            textField.text? = ""
            checkForValidity()
            return false
            
        }
        return true
    }
    
}
