//
//  ChargesViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 07/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class ChargesViewController: UIViewController {
    
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var rental: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var damage: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var stacj: UIStackView!
    @IBOutlet weak var startdate: UILabel!
    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var card: UIView!
    var trailerId = ""
    var charges : Charges?
    
    let dayFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let hourFormatter = DateFormatter()
    
    
    var firstDate : Date?
    var lastDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         button.setTitle("Select Dates", for: .normal)
        self.stack.alpha = 0.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.layer.cornerRadius = 7
        self.card.makeCard()
        self.card.makeBorder()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
       self.performSegue(withIdentifier: "charges", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let schedule = segue.destination as?  ScheduleViewController{
            schedule.modalPresentationStyle = .popover
            schedule.delegate = self
            schedule.charges = true
          //  schedule.firstDate = firstDate
          //  schedule.secondDate = lastDate
        }
    }
}


extension ChargesViewController : ChargesDelegate{
    func returnDateTime(start: String, end: String) {
        button.setTitle("Update Dates", for: .normal)
        
       // dayFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dayFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeFormatter.dateFormat = "dd MMM"
       // hourFormatter.timeZone = .current
        hourFormatter.dateFormat = "HH mm"
        
        let startDate = dayFormatter.date(from: start)
        let endDate = dayFormatter.date(from: end)
        
        self.firstDate = startDate
        self.lastDate = endDate
        
      //  timeFormatter.timeZone = .current
    // hourFormatter.timeZone = .current
        
        startdate.textColor = .label
        starttime.textColor = .label
        self.endDate.textColor = .label
        endTime.textColor = .label

        startdate.text = timeFormatter.string(from: startDate!)
        starttime.text = hourFormatter.string(from: startDate!)
        
        self.endDate.text = timeFormatter.string(from: endDate!)
        endTime.text = hourFormatter.string(from: endDate!)
        
        ProgressHUD.show("Calculating Charges")

        let model = ChargesRequestModel(trailerId: self.trailerId, upsellItems: [], startDate: start, endDate: end)
        let data = try! JSONEncoder().encode(model)
        PostController.shared.getCharges(data) { (charge) in
            if let charge = charge{
                DispatchQueue.main.async {
                    self.stack.alpha = 1.0
                    ProgressHUD.dismiss()
                    let trailer = charge.trailerCharges
                    self.charges = charge
                    self.rental.text = trailer?.rentalCharges?.dollarValue
                    self.damage.text = trailer?.dlrCharges?.dollarValue
                    self.tax.text = trailer?.taxes?.dollarValue
                    self.total.text = trailer?.total?.dollarValue
                }
            } else {
                print("error")
            }
        }
    }
}
