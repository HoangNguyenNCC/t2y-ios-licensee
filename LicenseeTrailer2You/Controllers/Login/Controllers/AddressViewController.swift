//
//  AddressViewController.swift
//  Trailer2You
//
//  Created by Aritro Paul on 22/02/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol addressDelegate: class {
    func didEnterAddress(address: AddressRequest)
}

class AddressViewController: UIViewController {
    
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var stateAndCountryLabel: UILabel!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var landmarkTextField: UITextField!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressSearchField: UITextField!
    
    var locationManager:CLLocationManager!
    weak var delegate: addressDelegate?
    var frame = CGRect()
    
    var addressCore = AddressRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 8
        houseNumberTextField.addIcon(iconName: "number.circle.fill")
        landmarkTextField.addIcon(iconName: "mappin.and.ellipse")
        
        frame = self.view.frame
        addressSearchField.addIcon(iconName: "magnifyingglass")
        addressSearchField.layer.cornerRadius = 8
        addressSearchField.delegate = self
        addressSearchField.tintColor = .tertiaryLabel
        
        overrideUserInterfaceStyle = .light
        
        houseNumberTextField.layer.cornerRadius = 8
        landmarkTextField.layer.cornerRadius = 8
        
        if addressCore.text != nil {
            let house = addressCore.text?.split(separator: ",")[0]
            houseNumberTextField.text = String(house ?? "")
            landmarkTextField.text = addressCore.text
            let location = CLLocation(latitude: addressCore.coordinates?[0] ?? -33.81, longitude: addressCore.coordinates?[1] ?? 151.2)
            getAddress(location: location)
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            DispatchQueue.main.async {
                self.mapView.setRegion(viewRegion, animated: true)
            }
        } else {
            setupMap()
        }
        self.isModalInPresentation = true
    }
    
    
    func setupMap() {
        
        mapView.makeCard()
        mapView.layer.cornerRadius = 12
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        determineMyCurrentLocation()
        
    }
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            let viewRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: true)
            getAddress(location: locationManager.location ?? CLLocation())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.view.frame = self.frame
        }
    }
    
    
    @IBAction func addAddressTapped(_ sender: Any) {
        
        if let house = houseNumberTextField.text, let landmark = landmarkTextField.text, let locality = localityLabel.text, let area = stateAndCountryLabel.text {
            let addressString = "\(house), \(landmark), \(locality), \(area)"
            addressCore.text = addressString
            print(addressString)
            delegate?.didEnterAddress(address: addressCore)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let completionVC = segue.destination as? AddressFinderViewController {
            completionVC.delegate = self
        }
    }
}

extension AddressViewController : addressCompletionDelegate {
    func didCompleteAddress(address: AddressRequest) {
        self.addressCore = address
        landmarkTextField.text = address.text
        let location = CLLocationCoordinate2D(latitude: address.coordinates?[0] ?? 0.0, longitude: address.coordinates?[1] ?? 0.0)
        let annotation = MKPointAnnotation()
        annotation.title = String(address.text?.split(separator: ",")[0] ?? "")
        annotation.coordinate =  location
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        getAddress(location: CLLocation(latitude: location.latitude, longitude: location.longitude))
    }
    
}

extension AddressViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addressSearchField {
            textField.resignFirstResponder()
            self.performSegue(withIdentifier: "completion", sender: Any?.self)
        }
    }
}

extension AddressViewController : CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.addressCore.coordinates = [userLocation.coordinate.latitude, userLocation.coordinate.longitude]
    }
    
    func getAddress(location: CLLocation){
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let locality = placeMark.locality {
                self.localityLabel.text = locality
            }
            if let state = placeMark.administrativeArea, let country = placeMark.country, let pincode = placeMark.postalCode, let city = placeMark.locality{
                self.stateAndCountryLabel.text = "\(state), \(country)"
                self.addressCore.country = country
                self.addressCore.pincode = pincode
                self.addressCore.city = city
                self.addressCore.state = state
            }
        })
    }
}
