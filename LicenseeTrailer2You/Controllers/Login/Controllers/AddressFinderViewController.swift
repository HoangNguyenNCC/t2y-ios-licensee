//
//  AddressFinderViewController.swift
//  Trailer2You
//
//  Created by Aritro Paul on 16/04/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit
import MapKit

protocol addressCompletionDelegate: class {
    func didCompleteAddress(address: AddressRequest)
}

class AddressFinderViewController: UIViewController {

    @IBOutlet weak var addressSearchField: UITextField!
    @IBOutlet weak var addressSearchTable: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    weak var delegate: addressCompletionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressSearchTable.delegate = self
        addressSearchTable.dataSource = self
        overrideUserInterfaceStyle = .light
        addressSearchField.addIcon(iconName: "magnifyingglass")
        addressSearchField.layer.cornerRadius = 8
        addressSearchField.delegate = self
        searchCompleter.delegate = self
        addressSearchField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func textChanged(_ sender: Any) {
        searchCompleter.queryFragment = addressSearchField.text ?? ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AddressFinderViewController : UITableViewDelegate, UITableViewDataSource, MKLocalSearchCompleterDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationTableViewCell
        cell.locationIcon.image = UIImage(named: "location")
        let searchResult = searchResults[indexPath.row]
        cell.locationName.text = "\(searchResult.title), \(searchResult.subtitle)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        DispatchQueue.main.async {
            self.addressSearchTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error == nil {
                if let coordinate = response?.mapItems[0].placemark.coordinate,
                let country = response?.mapItems[0].placemark.country,
                    let pincode = response?.mapItems[0].placemark.postalCode {
                    let text = result.title+", "+result.subtitle
                    let address = AddressRequest(country: country, text: text, pincode: pincode, coordinates: [coordinate.latitude, coordinate.longitude])
                    self.delegate?.didCompleteAddress(address: address)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
