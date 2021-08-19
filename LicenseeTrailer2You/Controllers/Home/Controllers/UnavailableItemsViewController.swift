//
//  UnavailableItemsViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 27/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class UnavailableItemsViewController: UIViewController {

    var currentIndex = 0
    var trailerData : [TrailerObject] = []
    var upsellData : [UpsellObject] = []
    var startDate = ""
    var endDate = ""
    var blockedItems : [BlockedItem] = []
    var selectedTrailers: [Int] = []
    var selectedUpsell : [Int] = []
    
    @IBAction func unwindToTrailerTab(_ unwindSegue: UIStoryboardSegue) {}

    @IBOutlet weak var addScheduleBttn: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var trailerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        segment.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        
        print(startDate)
        print(endDate)
    }
    
    override func viewDidLayoutSubviews() {
        addScheduleBttn.layer.cornerRadius = 14
    }
    
    override func viewDidAppear(_ animated: Bool) {
        trailerTable.dataSource = self
        trailerTable.delegate = self
        trailerTable.reloadData()
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        currentIndex = segment.selectedSegmentIndex
        trailerTable.reloadData()
    }
    
    @IBAction func addScheduleBttnTapped(_ sender: Any) {
        addScheduleBttn.disable()
        for item in selectedTrailers {
            blockedItems.append(BlockedItem(itemType: "trailer", itemId: trailerData[item].id!, units: nil))
        }
        for item in selectedUpsell {
            blockedItems.append(BlockedItem(itemType: "upsell", itemId: upsellData[item].id!, units: 1))
        }
        
        let schedule = BlockRental(id: nil, items: blockedItems, startDate: formatDatesToGMT()[0], endDate: formatDatesToGMT()[1])
        let scheduleObject = try! JSONEncoder().encode(schedule)
        
        PostController.shared.addSchedule(schedule: scheduleObject) { (message, status) in
            DispatchQueue.main.async {
                if status {
                    ProgressHUD.showSuccess(message)
                    //self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "close", sender: nil)
                } else {
                    self.addScheduleBttn.enable()
                    ProgressHUD.showError(message)
                }
            }
        }
    }
    
    func formatDatesToGMT()->[String]{
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(abbreviation: "UTC")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let start = dateformatter.date(from: startDate)
        let end = dateformatter.date(from: endDate)
        
        dateformatter.timeZone = .current

        return [dateformatter.string(from: start!), dateformatter.string(from: end!)]

    }
}

extension UnavailableItemsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentIndex == 0 {
            return trailerData.count
        } else {
            return upsellData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailerCell", for: indexPath) as! TrailerSelectionCell
        cell.trailerView.makeCard()
        cell.trailerView.makeBorder()
        
        if currentIndex == 0 {
            cell.trailerImage.kf.setImage(with: URL(string: trailerData[indexPath.row].photos?.first?.data ?? ""))
            cell.trailerDetails.text = trailerData[indexPath.row].name!
            cell.vinLabel.text = "vin: " + (trailerData[indexPath.row].vin ?? "")
            if let _ = selectedTrailers.firstIndex(of: indexPath.row) {
                cell.trailerView.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            }
        } else {
            cell.trailerImage.kf.setImage(with: URL(string: upsellData[indexPath.row].photos?.first?.data ?? ""))
            cell.trailerDetails.text = upsellData[indexPath.row].name!
            if let _ = selectedUpsell.firstIndex(of: indexPath.row) {
                cell.trailerView.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TrailerSelectionCell
        if currentIndex == 0 {
            if let index = selectedTrailers.firstIndex(of: indexPath.row) {
                selectedTrailers.remove(at: index)
                cell.trailerView.backgroundColor = .white
            } else {
                cell.trailerView.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
                selectedTrailers.append(indexPath.row)
            }
        } else {
            if let index = selectedUpsell.firstIndex(of: indexPath.row) {
                selectedUpsell.remove(at: index)
                cell.trailerView.backgroundColor = .white
            } else {
                selectedUpsell.append(indexPath.row)
                cell.trailerView.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

