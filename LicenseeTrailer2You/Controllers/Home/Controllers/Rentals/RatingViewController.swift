//
//  RatingViewController.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 29/10/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var ratingsView: UIStackView!
    @IBOutlet weak var skipFeedbackButton: UIButton!
    @IBOutlet weak var submitFeedbackButton: UIButton!
    
    var ratings : Int = 0
    var invoiceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupRatings()
    }
    
    
    func setupRatings() {
        for star in ratingsView.subviews {
            star.tintColor = .systemGray5
        }
        for index in ratingsView.subviews.indices {
            let star = ratingsView.subviews[index]
            star.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(tappedStar(sender: )))
            star.tag = index
            star.addGestureRecognizer(tapGes)
        }
    }
    
    
    @objc func tappedStar(sender: UITapGestureRecognizer) {
        rating(stars: 0, stack: ratingsView)
        let cardNumber = sender.view?.tag ?? -1
        ratings = cardNumber + 1
        rating(stars: ratings, stack: ratingsView)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func submitTapped(_ sender: Any) {
        let rating = RatingRequest(rating: ratings, invoiceId: invoiceId)
        let data = try! JSONEncoder().encode(rating)
        PostController.shared.rateCustomer(req: data) { (success) in
            if success{
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                //ERROR
            }
        }
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func rating(stars: Int,stack:UIStackView) {
        switch stars {
        case 1: stack.subviews[0].tintColor = .systemOrange
        case 2:
            stack.subviews[0].tintColor = .systemOrange
            stack.subviews[1].tintColor = .systemOrange
        case 3:
            stack.subviews[0].tintColor = .systemOrange
            stack.subviews[1].tintColor = .systemOrange
            stack.subviews[2].tintColor = .systemOrange
        case 4:
            stack.subviews[0].tintColor = .systemOrange
            stack.subviews[1].tintColor = .systemOrange
            stack.subviews[2].tintColor = .systemOrange
            stack.subviews[3].tintColor = .systemOrange
        case 5:
            stack.subviews[0].tintColor = .systemOrange
            stack.subviews[1].tintColor = .systemOrange
            stack.subviews[2].tintColor = .systemOrange
            stack.subviews[3].tintColor = .systemOrange
            stack.subviews[4].tintColor = .systemOrange
        case 0:
            stack.subviews[0].tintColor = .systemGray5
            stack.subviews[1].tintColor = .systemGray5
            stack.subviews[2].tintColor = .systemGray5
            stack.subviews[3].tintColor = .systemGray5
            stack.subviews[4].tintColor = .systemGray5
            
        default: break
        }
    }

}
