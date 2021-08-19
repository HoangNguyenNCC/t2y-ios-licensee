//
//  Web Helper.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 02/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import Foundation

class WebHelper {
    class func sendGETRequest(_ url: String, parameters: [String: String], header: Bool, completion: @escaping (Data?) -> Void) {
        if Utils.isInternetAvailable() {
            var components = URLComponents(string: url)!
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            if let requestURL = components.url {
                var request = URLRequest(url: requestURL)
                if(header) {
                    request.setValue(Defaults.token(), forHTTPHeaderField: "Authorization")
                }
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, let response = response as? HTTPURLResponse else { completion(nil); return }
                    getDebugRequest(url,response:data)
                    if (200..<300) ~= response.statusCode {
                        completion(data)
                    } else if response.statusCode == 403 {
                        completion(data)
                    } else {
                        completion(data)
                    }
                }
                task.resume()
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    class func sendPostRequest(_ url: String, parameters: [String: String], header: Bool, requestBody: Data, completion: @escaping (Data?) -> Void) {
        if Utils.isInternetAvailable() {
            var components = URLComponents(string: url)!
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            if let requestURL = components.url {
                var request = URLRequest(url: requestURL)
                if(header) {
                    request.setValue(Defaults.token(), forHTTPHeaderField: "Authorization")
                }
                request.httpBody = requestBody
                request.httpMethod = "Post"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 60
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, let response = response as? HTTPURLResponse else { completion(nil); return }
                    DebugRequest(url, request: requestBody, response: data)
                    if(error == nil) {
                        if (200..<300) ~= response.statusCode {
                            completion(data)
                        } else if response.statusCode == 403 {
                            completion(data)
                        } else {
                            completion(data)
                        }
                    } else {
                        completion(nil)
                    }
                }
                task.resume()
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    
    class func sendPutRequest(_ url: String, parameters: [String: String], header: Bool, requestBody: Data, completion: @escaping (Data?) -> Void) {
        if Utils.isInternetAvailable() {
            var components = URLComponents(string: url)!
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            if let requestURL = components.url {
                var request = URLRequest(url: requestURL)
                if(header) {
                    request.setValue(Defaults.token(), forHTTPHeaderField: "Authorization")
                }
                request.httpBody = requestBody
                request.httpMethod = "PUT"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if(error == nil) {
                        guard let data = data, let response = response as? HTTPURLResponse else { completion(nil); return }
                        
                        DebugRequest(url, request: requestBody, response: data)
                        
                        if (200..<300) ~= response.statusCode {
                            completion(data)
                        } else if response.statusCode == 403 {
                            completion(data)
                        } else {
                            completion(data)
                        }
                    } else {
                        completion(nil)
                    }
                }
                task.resume()
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
    
    class func sendDeleteRequest(_ url: String, parameters: [String: String], header: Bool, requestBody: Data, completion: @escaping (Data?) -> Void) {
        if Utils.isInternetAvailable() {
            var components = URLComponents(string: url)!
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            if let requestURL = components.url {
                var request = URLRequest(url: requestURL)
                if(header) {
                    request.setValue(Defaults.token(), forHTTPHeaderField: "Authorization")
                }
                request.httpMethod = "DELETE"
                request.httpBody = requestBody
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                print(String(data: request.httpBody!, encoding: .utf8))
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, let response = response as? HTTPURLResponse else { completion(nil); return }
                    print(String(data: data, encoding: .utf8))
                    if (200..<300) ~= response.statusCode {
                        completion(data)
                    } else if response.statusCode == 403 {
                        completion(data)
                    } else {
                        completion(data)
                    }
                }
                task.resume()
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}
