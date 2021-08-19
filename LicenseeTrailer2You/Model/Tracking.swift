//
//  Tracking.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 06/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class Tracking {
    let GOOGLE_DIRECTIONS_API_KEY = "AIzaSyAv3EAAeaT-PsR6cNePDsoxnukL_iRh0ko"

    func requestDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completionHandler: @escaping ((_ response: GMSPath?, _ error: Error?) -> Void)) {
        print(start,end,"STARTEND") //TODO
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(start.latitude),\(start.longitude)&destination=\(end.latitude),\(end.longitude)&key=\(GOOGLE_DIRECTIONS_API_KEY)") else {
            //https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=YOUR_API_KEY
            let error = NSError(domain: "LocalDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create object URL"])
            print("Error: \(error)")
            completionHandler(nil, error)
            return
        }



        // Set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: url) { (data, response, error) in
            // Check if there is an error.
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Google Directions Request Error: \((error!)).")
                    completionHandler(nil, error)
                }
                return
            }

            // Make sure data was received.
            guard let data = data else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "GoogleDirectionsRequest", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to receive data"])
                    print("Error: \(error).")
                    completionHandler(nil, error)
                }
                return
            }

            do {
                // Convert data to dictionary.
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "GoogleDirectionsRequest", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON to Dictionary"])
                        print("Error: \(error).")
                        completionHandler(nil, error)
                    }
                    return
                }

                print(json,"json")

                // Check if the the Google Direction API returned a status OK response.
                guard let status: String = json["status"] as? String, status == "OK" else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "GoogleDirectionsRequest", code: 3, userInfo: [NSLocalizedDescriptionKey: "Google Direction API did not return status OK"])
                        print("Error: \(error).")
                        completionHandler(nil, error)
                    }
                    return
                }


                // We only need the 'points' key of the json dictionary that resides within.
                if let routes: [Any] = json["routes"] as? [Any], routes.count > 0, let routes0: [String: Any] = routes[0] as? [String: Any], let overviewPolyline: [String: Any] = routes0["overview_polyline"] as? [String: Any], let points: String = overviewPolyline["points"] as? String {
                    // We need the get the first object of the routes array (route0), then route0's overview_polyline and finally overview_polyline's points object.

                    if let path: GMSPath = GMSPath(fromEncodedPath: points) {
                        DispatchQueue.main.async {
                            completionHandler(path, nil)
                        }
                        return
                    } else {
                        DispatchQueue.main.async {
                            let error = NSError(domain: "GoogleDirections", code: 5, userInfo: [NSLocalizedDescriptionKey: "Failed to create GMSPath from encoded points string."])
                            completionHandler(nil, error)
                        }
                        return
                    }

                } else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "GoogleDirections", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to parse overview polyline's points"])
                        completionHandler(nil, error)
                    }
                    return
                }


            } catch let error as NSError  {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }

        }

        task.resume()
    }
}

class TrackingTripStatus: Codable {
    let rentalId: String
    let type: String
    let action: String
    let driverLicenseScan: String?

    init(rentalId: String,type: String, action: String, driverLicenseScan: String?) {
        self.rentalId = rentalId
        self.type = type
        self.action = action
        self.driverLicenseScan = driverLicenseScan
    }
}

class TrailerStatus: Codable {
    let rentalId: String
    let status: String
    let driverLicenseScan: String?

    init(rentalId: String,status: String, driverLicenseScan: String?) {
        self.rentalId = rentalId
        self.status = status
        self.driverLicenseScan = driverLicenseScan
    }
}


class TrackingRequest: Codable {
    let rentalId : String
    let location : [Double]
    let type: String

    init(rentalId: String, location: [Double], type: String) {
        self.rentalId = rentalId
        self.location = location
        self.type = type
    }
}
