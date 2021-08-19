//
//  MultipartExtension.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 08/07/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

extension PostController {
    
    func taskForPOSTRequest<ResponseType: Decodable>(url: String?, responseType: ResponseType.Type, params: [String:String],mediaData : [Media],header : Bool = true, PUT : Bool = false,completion: @escaping (ResponseType?, String?) -> Void) {
        
        guard let url = URL(string:  url ?? "") else { return }
        
        print("PARAMS:",params)
        
        print("Media :",mediaData)
        
        var request = URLRequest(url: url)
        request.httpMethod = PUT ? "PUT" : "POST"
                
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if(header) {
            request.setValue(Defaults.token(), forHTTPHeaderField: "Authorization")
        }
        
        let dataBody = createDataBody(withParameters: params, media: mediaData, boundary: boundary)
        
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, "error")
                }
                return
            }
            
            DebugRequest(url.absoluteString, request: dataBody, response: data)
                
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseData, nil)
                }
            } catch {
                print("DECODE ERROR",error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil, error?.errorsList.first)
            }
        }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String: Any]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\("\(value)" + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(stringData : String, forKey key: String, name : String, mimeType : String) {
        self.key = key
        self.mimeType = mimeType
        self.filename = "\(name) \(key)"
        
        
        guard let data = Data(base64Encoded: stringData, options: .ignoreUnknownCharacters) else
        {
            print("no data")
            return nil
        }
        self.data = data
    }
}

extension Double {
    var StringValue : String {
        return String(self)
    }
    
    var dollarValue : String {
        return String(self) + " AUD"
    }
}
