//
//  Extensions.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 10/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    func cleanTitles() {
        guard let items = self.tabBar.items else {
            return
        }
        for item in items {
            item.title = ""
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}

extension UIView{
    func makeCard() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    func makeBorder() {
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.tertiarySystemFill.cgColor
    }
    
    func makeBottomCard(){
        self.layer.shadowOffset = CGSize(width: 0, height: -8)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    func makeTopCard(){
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    func makeRoundedCorners(usingCorners corners: UIRectCorner, cornerRadii: Int) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 3
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
        
    }
    
    func addBlurToView() {
        var blurEffect: UIBlurEffect!
        blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = 1
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurredEffectView)
    }
    
    func removeBlur() {
        for view in self.subviews {
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
}

extension UITextField {
    func formatField() {
        self.layer.cornerRadius = 12.0
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
           contentMode = mode
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard
                   let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                   let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                   let data = data, error == nil,
                   let image = UIImage(data: data)
                   else { return }
               DispatchQueue.main.async() {
                   self.image = image
               }
        }.resume()
    }
    
       
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func setup() {
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 14
    }
}

extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    func setPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
    func addIcon(iconName: String) {
        let iconView = UIImageView(frame:
                       CGRect(x: 10, y: 10, width: 20, height: 20))
        iconView.contentMode = .scaleAspectFill
        iconView.image = UIImage(systemName: iconName)
        let iconContainerView: UIView = UIView(frame:
                       CGRect(x: 20, y: 0, width: 45, height: 40))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {

        guard let labelText = text else { return }

        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Character spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIButton {
    func disable() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.4
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

enum AccessCategory : String {
    case TRAILER = "trailer"
    case UPSELL = "upsell"
    case INSURANCE = "insurance"
    case SERVICING = "servicing"
    case REMINDERS = "reminders"
    case FINANCIALS = "financials"
    case RENTAL_STATUS = "rentalstatus"
    case EMPLOYEE = "employees"
    case BLOCK = "block"
    
    func localized() -> String {
       return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum AccessType : String {
    case ADD = "ADD"
    case EDIT = "UPDATE"
    case VIEW = "VIEW"
    case DELETE = "DELETE"
}

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }

    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }

    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }

        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0

        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }

        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)

        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth

        return contentSize
    }
}

extension UIViewController {
    
    // Function for tap gesture
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    // Calling dismiss selector actions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
        func gtmTime(dates:[String]) -> [String] {
            let formatter = DateFormatter()
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = .short
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let dt1 = dateformatter.date(from: dates[0])
            let dt2 = dateformatter.date(from: dates[1])
            formatter.dateFormat = "h:mm a"
            return [formatter.string(from: dt1!),formatter.string(from: dt2!)]
        }
        
        func gmtToLocal(_ time : String)->String{
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let date = formatter.date(from: time)
            formatter.timeZone = .current
            formatter.dateFormat = "h:mm a"
            let time = formatter.string(from: date!)
            
            return time
        }
}

