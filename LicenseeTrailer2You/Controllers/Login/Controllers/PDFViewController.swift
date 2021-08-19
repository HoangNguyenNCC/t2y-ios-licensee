//
//  PDFViewController.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 05/07/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

    @IBOutlet weak var pdfContainer: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var pdfView = PDFView()
    var pdfData = Data()
    var navTitle : PdfType = .License
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pdfData)
        self.title = navTitle.stringValue
        overrideUserInterfaceStyle = .light
        
           pdfView.frame = pdfContainer.bounds
           pdfContainer.addSubview(pdfView)
           pdfView.autoScales = true
           pdfView.document = PDFDocument(data: pdfData)
    }

    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)    }
    
}

enum PdfType {
    case License
    case Insurance
    case Servicing(name : String)
    
    var stringValue : String {
        switch self {
        case .License:
            return "License Scan"
        case .Insurance:
            return "Insurance Scan"
        case .Servicing(name: let name):
            return name + " Servicing Scan"
        }
    }
}
