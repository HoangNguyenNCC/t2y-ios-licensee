//
//  TrailersViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 17/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

struct LinkedItem {
    var id: String
    var name: String
    var photo: String
    var item: [String]
}

class TrailersViewController: UIViewController {
    
    var myItems : AllItems? = nil
    
    var operation = ""
    
    var adminTrailerList : TrailerListings? = nil
    var adminUpsellList : UpsellListings? = nil
    
    var trailer : AddTrailer?
    var upsell : AddUpsellItem?
    
    var selectedItem : Int = -1
    var titlePhoto: UIImage = UIImage()
    var hashedItem : [String:[String]] = [:]
    var listings: [LinkedItem] = []
    
    var upsellObject : AddUpsellItem?
    
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var trailerList: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        trailerList.dataSource = self
        trailerList.delegate = self
        getTrailers()
        titleLabel.text = "Link Trailer Model"
        
        if operation == OperationType.edit.rawValue {
            nextBttn.setTitle("UPDATE UPSELL", for: UIControl.State.normal)
        }
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    override func viewDidLayoutSubviews() {
        nextBttn.layer.cornerRadius = 14
    }
    
    func getTrailers() {
        print("TRAILER LIST: ",(self.myItems?.trailersList ?? []).map{$0.trailerModel})
        for item in self.myItems?.trailersList ?? [] {
            if item.trailerModel != nil {
                if hashedItem[item.trailerModel!] != nil {
                    var temp = hashedItem[item.trailerModel!] ?? [String]()
                    temp.append(item.id!)
                    hashedItem[item.trailerModel!] = temp
                } else {
                    self.hashedItem[item.trailerModel!] = [item.id!]
                }
            }
        }
        
        print("HASH: ",hashedItem)
        
        for item in adminTrailerList?.trailersList ?? [] {
            if self.hashedItem[item.id!] != nil {
                listings.append(LinkedItem(id: item.trailerModel ?? "", name: item.name!, photo: item.photos![0].data!
                    , item: hashedItem[item.id!]!))
            }
        }
    }
    
    @IBAction func nextBttnTapped(_ sender: Any) {
        if operation == OperationType.edit.rawValue {
            editUpsell()
        } else {
            addUpsell()
        }
    }
    
    
    func addUpsell() {
        
        ProgressHUD.show("Saving Upsell Details")
        nextBttn.disable()
        

        if upsell != nil {
            let trailerModel = listings[selectedItem].id
            
            upsell?.trailerModel = trailerModel
            PostController.shared.addUpsell(self.upsell!) { (status, message) in
                DispatchQueue.main.async {
                    if status {
                        ProgressHUD.showSuccess("Successfully saved Upsell Item")
                        self.performSegue(withIdentifier: "close", sender: Any?.self)
                    } else {
                        ProgressHUD.showError(message ?? "Error")
                        self.nextBttn.enable()
                    }
                }
            }
        }
    }
    
    func editUpsell() {

        ProgressHUD.show("Updating Upsell Details")
        nextBttn.disable()
        
        if upsell != nil && selectedItem > 0{
            let trailerModel = listings[selectedItem].id
            upsell?.trailerModel = trailerModel
            PostController.shared.addUpsell(self.upsell!,update : true) { (status, message) in
                DispatchQueue.main.async {
                    if status {
                        ProgressHUD.showSuccess("Successfully saved Upsell Item")
                        self.performSegue(withIdentifier: "close", sender: Any?.self)
                    } else {
                        ProgressHUD.showError(message ?? "Error")
                        self.nextBttn.enable()
                    }
                }
            }
        } else {
            ProgressHUD.showError(Strings.textFieldEmpty)
        }
    }
    
}

extension TrailersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailerCell", for: indexPath) as! TrailerSelectionCell
        
        let upsell = listings[indexPath.row]
        
        cell.trailerDetails.text = upsell.name
        
        if let url = URL(string: upsell.photo) {
            cell.trailerImage.kf.setImage(with: url)
        }
        
        cell.trailerView.makeCard()
        cell.trailerImage.layer.cornerRadius = 14
        
        if operation == OperationType.edit.rawValue {
            if upsell.id == self.upsell?.trailerModel{
                cell.setSelected(true, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TrailerSelectionCell
        if indexPath.row == selectedItem {
            cell.trailerView.backgroundColor = .white
        } else {
            selectedItem = indexPath.row
            cell.trailerView.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
