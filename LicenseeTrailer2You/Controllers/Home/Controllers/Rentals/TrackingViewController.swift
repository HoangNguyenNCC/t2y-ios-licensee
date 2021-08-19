//
//  TrackingViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//


import UIKit
import WebKit
import GoogleMaps
import ProgressHUD
import AVFoundation
import CoreLocation
import PDFKit

class TrackingViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var licenseToggle = false
    var invoiceDetails : Invoice? = nil
    var rentalID = ""
    var drop = true
    var pickup = false
    var locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D? = nil
    var customerLocation: CLLocationCoordinate2D? = nil
    var trackingEnabled: Bool = false
    var status = ""
    var started = false
    

    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var viewBttn: UIButton!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerCard: UIView!
    @IBOutlet weak var customerImage: UIImageView!
    @IBOutlet weak var startTrackingBttn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.mapView?.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        customerName.text = invoiceDetails?.rentalObj?.bookedByUser?.name!
        customerAddress.text = invoiceDetails?.rentalObj?.bookedByUser?.address?.text
        
        self.rentalID = invoiceDetails?.rentalObj?.invoiceId ?? ""
        
        if drop {
            status = "dropoff"
        } else if pickup {
            status = "pickup"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let scan = invoiceDetails?.rentalObj?.bookedByUser?.driverLicense?.scan?.data, let url = URL(string: scan){
            WebHelper.sendGETRequest(scan, parameters: [:], header: false) { (response) in
                self.pdfView.autoScales = true
                DispatchQueue.main.async {
                    self.pdfView.document = PDFDocument(data: response ?? Data())
                }
            }
        }
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    override func viewDidLayoutSubviews() {2
        customerCard.makeCard()
        startTrackingBttn.layer.cornerRadius = 14
        customerImage.layer.cornerRadius = customerImage.frame.width/2
        mapView.layer.cornerRadius = 14
        viewBttn.layer.cornerRadius = 8
        pdfView.layer.cornerRadius = 14
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if licenseToggle {
            view.sendSubviewToBack(pdfView)
            view.removeBlur()
        }
        licenseToggle = false
    }
    
    func viewLicense() {
        view.addBlurToView()
        view.bringSubviewToFront(pdfView)
        licenseToggle = true
    }
    
    @IBAction func viewBttnTapped(_ sender: Any) {
        trackVehicle()
        viewLicense()
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        print("toLocation",toLocation)
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
    
    @objc func trackVehicle() {
        print("tracking")
        if let loc = location{
            let trackingDetails = locationData(invoiceNumber: rentalID, lat: loc.latitude.StringValue, long: loc.longitude.StringValue)
            SocketIOManager.sharedInstance.sendLocation(trackingDetails)
        } else {
            print("LOCATION NOT FOUND")
        }
    }
    
    @IBAction func startTrackingBttnTapped(_ sender: Any) {
        if(trackingEnabled == false) {
            startTracking()
            trackingEnabled = true
            startTrackingBttn.setTitle("Stop Tracking", for: .normal)
        } else {
            endTracking()
            trackingEnabled = false
            startTrackingBttn.setTitle("Start Tracking", for: .normal)
            startTrackingBttn.isHidden = true
        }
    }
    
    func fetchRoute(to destination: CLLocationCoordinate2D) {
        let sessionManager = Tracking()
        let start = location ?? CLLocationCoordinate2D()
        let end = CLLocationCoordinate2D(latitude: (self.invoiceDetails?.rentalObj?.bookedByUser?.address?.coordinates[0])!, longitude: (self.invoiceDetails?.rentalObj?.bookedByUser?.address?.coordinates[1])!)
        
        sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
            } else {
                let polyline = GMSPolyline(path: path!)
                polyline.strokeColor = .systemBlue
                polyline.strokeWidth = 3
                polyline.map = self.mapView
                let bounds = GMSCoordinateBounds(path: path!)
                let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
                self.mapView.animate(with: cameraUpdate)
            }
        })
    }
    
    func startTracking() {
        let tripStatus = TrackingTripStatus(rentalId: rentalID, type: status, action: "start", driverLicenseScan: nil)
        print(rentalID)
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.connect(rentalID)
        updateStatus(location: tripStatus)
        started = true
        self.locationManager.startMonitoringSignificantLocationChanges()
        customerLocation = CLLocationCoordinate2D(latitude: (invoiceDetails?.rentalObj?.dropOffLocation?.coordinates[0])!, longitude: (invoiceDetails?.rentalObj?.dropOffLocation?.coordinates[1])!)
        fetchRoute(to: customerLocation!)
        print("COORD",invoiceDetails?.rentalObj?.dropOffLocation?.coordinates[0])
        view.sendSubviewToBack(cameraView)
    }
    
    func endTracking() {
        ProgressHUD.showSuccess("Click Picture of Driving License")
        view.bringSubviewToFront(cameraView)
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopMonitoringSignificantLocationChanges()
        setupCamera()
    }
    
    @IBAction func capturePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        trackingComplete()
    }
    
    func trackingComplete() {
        ProgressHUD.show("Marking Completion of trip")
        let licenseScan = capturedImage.image?.toString()!
        let tripStatus = TrackingTripStatus(rentalId: rentalID, type: status, action: "end", driverLicenseScan: licenseScan)
        let trailerStatus = TrailerStatus(rentalId: rentalID, status: "delivered", driverLicenseScan: licenseScan)
        print(tripStatus)
        updateStatus(location: tripStatus)
        updateTrailerStatus(status: trailerStatus)
    }
    
    func updateStatus(location: TrackingTripStatus) {
        PostController.shared.trackingUpdate(location) { (status, message) in
            print(status,message)
            if status {
                //ProgressHUD.showSuccess("Successfully delivered trailer")
                DispatchQueue.main.async {
                    //self.performSegue(withIdentifier: "close", sender: Any?.self)
                }
                SocketIOManager.sharedInstance.closeConnection()
            } else {
                ProgressHUD.showError(message)
            }
        }
    }
    
    func updateTrailerStatus(status : TrailerStatus){
        PostController.shared.trailerStatusUpdate(status) { (success, error) in
            if success {
                ProgressHUD.showSuccess("Successfully delivered trailer")
            } else {
                DispatchQueue.main.async {
                    self.startTrackingBttn.isHidden = false
                    ProgressHUD.showError(error)
                }
            }
        }
    }
    
}

extension TrackingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location",locations.last?.coordinate)
        location = locations.last?.coordinate
        cameraMoveToLocation(toLocation: location)
        trackVehicle()
    }
}

extension TrackingViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        
        let image = UIImage(data: imageData)
        capturedImage.image = image
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraView.bounds
            }
        }
    }
    
    func stopMonitoring() {
        self.captureSession.stopRunning()
    }
}

