//
//  MultipartController.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 25/06/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit


extension PostController {
    
    func signup(_ signupData : SignUp, completion : @escaping (Bool,String?)->()){
   
        let licenseeName = signupData.licensee.name ?? ""
        let licenseeEmail = signupData.licensee.email ?? ""
        let licenseeMobile = signupData.licensee.mobile ?? ""
        let licenseeBusinessType = signupData.licensee.businessType ?? "individual"
        let licenseeAddressText = signupData.licensee.address?.text ?? ""
        let licenseeAddressPincode = signupData.licensee.address?.pincode ?? ""
        let licenseeAddressLat = (signupData.licensee.address?.coordinates.first ?? 0.0).StringValue
        let licenseeAddressLon = (signupData.licensee.address?.coordinates.last ?? 0.0).StringValue
        let licenseeAddresscity = signupData.licensee.address?.city ?? ""
        let licenseeAddressState = signupData.licensee.address?.state ?? ""
        let licenseeAddressCountry = signupData.licensee.country ?? "Australia"
        let licenseebsbNumber = signupData.licensee.bsbNumber ?? ""
        let licenseeaccountNumber = signupData.licensee.accountNumber ?? ""
        let licenseeurl = "httpyolyoylo"
        let licenseetaxId = signupData.licensee.taxId ?? ""
        let employeename = signupData.employee.name
        let employeeemail = signupData.employee.email
        let employeemobile = signupData.employee.mobile
        let employeecountry = signupData.employee.address.country ?? "Australia"
        let employeepassword = signupData.employee.password ?? ""
        let employeetitle = "owner"
        let employeedob = signupData.employee.dob
        let employeeaddresstext = signupData.employee.address.text ?? ""
        let employeeaddresspincode = signupData.employee.address.pincode ?? ""
        let employeeaddresslat = (signupData.employee.address.coordinates?.first ?? 0.0).StringValue
        let employeeaddresslon = (signupData.employee.address.coordinates?.last ?? 0.0).StringValue
        let employeeaddresscity = signupData.employee.address.city ?? ""
        let employeeaddressstate = signupData.employee.address.state?.longForm ?? ""
        let employeeaddresscountry = signupData.employee.address.country ?? "Australia"
        let employeedriverLicensecard = signupData.employee.driverLicense.card ?? ""
        let employeedriverLicenseexpiry = signupData.employee.driverLicense.expiry ?? ""
        let employeedriverLicensestate = signupData.employee.driverLicense.state ?? ""
        let licenseeworkingHours = signupData.licensee.workingHours ?? ""
        
        var params =  [
            "reqBody[licensee][name]": licenseeName,
            "reqBody[licensee][email]": licenseeEmail,
            "reqBody[licensee][mobile]": licenseeMobile,
            "reqBody[licensee][country]": licenseeAddressCountry,
            "reqBody[licensee][businessType]": licenseeBusinessType,
            "reqBody[licensee][address][text]": licenseeAddressText,
            "reqBody[licensee][address][pincode]": licenseeAddressPincode,
            "reqBody[licensee][address][coordinates][0]": licenseeAddressLat,
            "reqBody[licensee][address][coordinates][1]": licenseeAddressLon,
            "reqBody[licensee][address][city]": licenseeAddresscity,
            "reqBody[licensee][address][state]": licenseeAddressState,
            "reqBody[licensee][address][country]": licenseeAddressCountry,
            "reqBody[licensee][bsbNumber]": licenseebsbNumber,
            "reqBody[licensee][accountNumber]": licenseeaccountNumber,
            "reqBody[licensee][url]": licenseeurl,
            "reqBody[licensee][taxId]": licenseetaxId,
            "reqBody[employee][name]": employeename,
            "reqBody[employee][email]": employeeemail,
            "reqBody[employee][mobile]": employeemobile,
            "reqBody[employee][country]": employeecountry,
            "reqBody[employee][password]": employeepassword,
            "reqBody[employee][title]": employeetitle,
            "reqBody[employee][dob]": employeedob,
            "reqBody[employee][address][text]": employeeaddresstext,
            "reqBody[employee][address][pincode]": employeeaddresspincode,
            "reqBody[employee][address][coordinates][0]": employeeaddresslat,
            "reqBody[employee][address][coordinates][1]": employeeaddresslon,
            "reqBody[employee][address][city]": employeeaddresscity,
            "reqBody[employee][address][state]": employeeaddressstate,
            "reqBody[employee][address][country]": employeeaddresscountry,
            "reqBody[employee][driverLicense][card]": employeedriverLicensecard,
            "reqBody[employee][driverLicense][expiry]": employeedriverLicenseexpiry,
            "reqBody[employee][driverLicense][state]": employeedriverLicensestate,
            "reqBody[licensee][workingHours]": licenseeworkingHours
            ] as [String:String]
        
        for day in signupData.licensee.workingDays {
            let index = signupData.licensee.workingDays.firstIndex(of: day)!
            params["reqBody[licensee][workingDays][\(index)]"] = day
        }
        
        print(params)
        
        guard let licenseeLogo = Media(stringData: signupData.licensee.logo, forKey: "licenseeLogo", name: licenseeName, mimeType: "image/png") else { return }
        
        
        guard let licenseeProofOfIncorporation = Media(stringData: signupData.licensee.proofOfIncorporation, forKey: "licenseeProofOfIncorporation", name: licenseeName, mimeType: "application/pdf") else { return }
                
        
        guard let employeePhoto = Media(stringData: signupData.employee.photo, forKey: "employeePhoto", name: licenseeName, mimeType: "image/png") else { return }
        
        
        guard let employeeDriverLicenseScan = Media(stringData: signupData.employee.driverLicense.scan!.data!, forKey: "employeeDriverLicenseScan", name: licenseeName, mimeType: "application/pdf") else { return }
        
        
        //TODO
        guard let employeeAdditionalDocumentScan = Media(stringData: signupData.licensee.proofOfIncorporation, forKey: "employeeAdditionalDocumentScan", name: licenseeName, mimeType: "application/pdf") else { return }
        
        PostController.shared.taskForPOSTRequest(url: NetworkConstants.signUpURL, responseType: SuccessModel.self, params: params, mediaData: [licenseeLogo,licenseeProofOfIncorporation,employeePhoto,employeeDriverLicenseScan,employeeAdditionalDocumentScan],header: false) { (result, error) in
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
    
    func signup2(_ signupData : SignUp, completion : @escaping (Bool,String?)->()){
        
        var paramaters = [String:Any]()
        

    
         let licenseeName = signupData.licensee.name ?? ""
         let licenseeEmail = signupData.licensee.email ?? ""
         let licenseeMobile = signupData.licensee.mobile ?? ""
         let licenseeBusinessType = signupData.licensee.businessType ?? "individual"
         let licenseeAddressText = signupData.licensee.address?.text ?? ""
         let licenseeAddressPincode = signupData.licensee.address?.pincode ?? ""
         let licenseeAddressLat = (signupData.licensee.address?.coordinates.first ?? 0.0).StringValue
         let licenseeAddressLon = (signupData.licensee.address?.coordinates.last ?? 0.0).StringValue
         let licenseeAddresscity = signupData.licensee.address?.city ?? ""
         let licenseeAddressState = signupData.licensee.address?.state ?? ""
         let licenseeAddressCountry = signupData.licensee.country ?? "Australia"
         let licenseebsbNumber = signupData.licensee.bsbNumber ?? ""
         let licenseeaccountNumber = signupData.licensee.accountNumber ?? ""
         let licenseeurl = "httpyolyoylo"
         let licenseetaxId = signupData.licensee.taxId ?? ""
         let employeename = signupData.employee.name
         let employeeemail = signupData.employee.email
         let employeemobile = signupData.employee.mobile
         let employeecountry = signupData.employee.address.country ?? "Australia"
         let employeepassword = signupData.employee.password ?? ""
         let employeetitle = "owner"
         let employeedob = signupData.employee.dob
         let employeeaddresstext = signupData.employee.address.text ?? ""
         let employeeaddresspincode = signupData.employee.address.pincode ?? ""
         let employeeaddresslat = (signupData.employee.address.coordinates?.first ?? 0.0).StringValue
         let employeeaddresslon = (signupData.employee.address.coordinates?.last ?? 0.0).StringValue
         let employeeaddresscity = signupData.employee.address.city ?? ""
         let employeeaddressstate = signupData.employee.address.state?.longForm ?? ""
         let employeeaddresscountry = signupData.employee.address.country ?? "Australia"
         let employeedriverLicensecard = signupData.employee.driverLicense.card ?? ""
         let employeedriverLicenseexpiry = signupData.employee.driverLicense.expiry ?? ""
         let employeedriverLicensestate = signupData.employee.driverLicense.state ?? ""
         let licenseeworkingHours = signupData.licensee.workingHours ?? ""
         
         var params =  [
             "reqBody[licensee][name]": licenseeName,
             "reqBody[licensee][email]": licenseeEmail,
             "reqBody[licensee][mobile]": licenseeMobile,
             "reqBody[licensee][country]": licenseeAddressCountry,
             "reqBody[licensee][businessType]": licenseeBusinessType,
             "reqBody[licensee][address][text]": licenseeAddressText,
             "reqBody[licensee][address][pincode]": licenseeAddressPincode,
             "reqBody[licensee][address][coordinates][0]": licenseeAddressLat,
             "reqBody[licensee][address][coordinates][1]": licenseeAddressLon,
             "reqBody[licensee][address][city]": licenseeAddresscity,
             "reqBody[licensee][address][state]": licenseeAddressState,
             "reqBody[licensee][address][country]": licenseeAddressCountry,
             "reqBody[licensee][bsbNumber]": licenseebsbNumber,
             "reqBody[licensee][accountNumber]": licenseeaccountNumber,
             "reqBody[licensee][url]": licenseeurl,
             "reqBody[licensee][taxId]": licenseetaxId,
             "reqBody[employee][name]": employeename,
             "reqBody[employee][email]": employeeemail,
             "reqBody[employee][mobile]": employeemobile,
             "reqBody[employee][country]": employeecountry,
             "reqBody[employee][password]": employeepassword,
             "reqBody[employee][title]": employeetitle,
             "reqBody[employee][dob]": employeedob,
             "reqBody[employee][address][text]": employeeaddresstext,
             "reqBody[employee][address][pincode]": employeeaddresspincode,
             "reqBody[employee][address][coordinates][0]": employeeaddresslat,
             "reqBody[employee][address][coordinates][1]": employeeaddresslon,
             "reqBody[employee][address][city]": employeeaddresscity,
             "reqBody[employee][address][state]": employeeaddressstate,
             "reqBody[employee][address][country]": employeeaddresscountry,
             "reqBody[employee][driverLicense][card]": employeedriverLicensecard,
             "reqBody[employee][driverLicense][expiry]": employeedriverLicenseexpiry,
             "reqBody[employee][driverLicense][state]": employeedriverLicensestate,
             "reqBody[licensee][workingHours]": licenseeworkingHours
             ] as [String:String]
         
         for day in signupData.licensee.workingDays {
             let index = signupData.licensee.workingDays.firstIndex(of: day)!
             params["reqBody[licensee][workingDays][\(index)]"] = day
         }
         
         print(params)
         
         guard let licenseeLogo = Media(stringData: signupData.licensee.logo, forKey: "licenseeLogo", name: licenseeName, mimeType: "image/png") else { return }
         
         
         guard let licenseeProofOfIncorporation = Media(stringData: signupData.licensee.proofOfIncorporation, forKey: "licenseeProofOfIncorporation", name: licenseeName, mimeType: "application/pdf") else { return }
                 
         
         guard let employeePhoto = Media(stringData: signupData.employee.photo, forKey: "employeePhoto", name: licenseeName, mimeType: "image/png") else { return }
         
         
         guard let employeeDriverLicenseScan = Media(stringData: signupData.employee.driverLicense.scan!.data!, forKey: "employeeDriverLicenseScan", name: licenseeName, mimeType: "application/pdf") else { return }
         
         
         //TODO
         guard let employeeAdditionalDocumentScan = Media(stringData: signupData.licensee.proofOfIncorporation, forKey: "employeeAdditionalDocumentScan", name: licenseeName, mimeType: "application/pdf") else { return }
         
         PostController.shared.taskForPOSTRequest(url: NetworkConstants.signUpURL, responseType: SuccessModel.self, params: params, mediaData: [licenseeLogo,licenseeProofOfIncorporation,employeePhoto,employeeDriverLicenseScan,employeeAdditionalDocumentScan],header: false) { (result, error) in
             if let result = result {
                 if result.success {
                     completion(true,nil)
                 } else {
                     completion(false,result.message)
                 }
             } else {
                 completion(false,error)
             }
         }
     }
    
    
    func signup(_ employee : Employee,token : String,update : Bool = false ,completion : @escaping (Bool,String?)->()){
        
        let employeename = employee.name
        let employeeemail = employee.email
        let employeemobile = employee.mobile
        let employeecountry = employee.address.country ?? "Australia"
        let employeepassword = employee.password ?? ""
        let employeetitle = "employee"
        let employeedob = employee.dob
        let employeeaddresstext = employee.address.text ?? ""
        let employeeaddresspincode = employee.address.pincode ?? ""
        let employeeaddresslat = (employee.address.coordinates?.first ?? 0.0).StringValue
        let employeeaddresslon = (employee.address.coordinates?.last ?? 0.0).StringValue
        let employeeaddresscity = employee.address.city ?? ""
        let employeeaddressstate = employee.address.state ?? ""
        let employeeaddresscountry = employee.address.country ?? "Australia"
        let employeedriverLicensecard = employee.driverLicense.card ?? ""
        let employeedriverLicenseexpiry = employee.driverLicense.expiry ?? ""
        let employeedriverLicensestate = employee.driverLicense.state ?? ""
        
        
        
        var params =  [
            "reqBody[name]": employeename,
            "reqBody[email]": employeeemail,
            "reqBody[mobile]": employeemobile,
            "reqBody[country]": employeecountry,
            "reqBody[password]": employeepassword,
            "reqBody[title]": employeetitle,
            "reqBody[dob]": employeedob,
            "reqBody[address][text]": employeeaddresstext,
            "reqBody[address][pincode]": employeeaddresspincode,
            "reqBody[address][coordinates][0]": employeeaddresslat,
            "reqBody[address][coordinates][1]": employeeaddresslon,
            "reqBody[address][city]": employeeaddresscity,
            "reqBody[address][state]": employeeaddressstate,
            "reqBody[address][country]": employeeaddresscountry,
            "reqBody[driverLicense][card]": employeedriverLicensecard,
            "reqBody[driverLicense][expiry]": employeedriverLicenseexpiry,
            "reqBody[driverLicense][state]": employeedriverLicensestate
            ] as [String:String]
        
        if !update {
            params["reqBody[token]"] = token
        }
        
        params = getUpdateParams(params)
        
        print(params)
        
        var medias = [Media]()
        
        guard let employeePhoto = Media(stringData: employee.photo, forKey: "employeePhoto", name: employeename, mimeType: "image/png") else { return }
        
        print("reached here 3")
        
        //TODO
        
        if !update {
            guard let employeeDriverLicenseScan = Media(stringData: employee.driverLicense.scan!.data!, forKey: "employeeDriverLicenseScan", name: employeename, mimeType: "application/pdf") else { return }
            medias.append(employeeDriverLicenseScan)
        }
        
        print("reached here 4")
        
        let  url = update ? NetworkConstants.getUserProfile : NetworkConstants.employeeSignupURL
        
        PostController.shared.taskForPOSTRequest(url: url, responseType: SuccessModel.self, params: params, mediaData: [employeePhoto] + medias ,header: update, PUT : update) { (result, error) in
            print(result,error)
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    print(result.message)
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
    
    func editProfile(_ employee : Employee,completion : @escaping (Bool,Employee2?,String?)->()){
        
        
        var params = [String:String]()
        
        params["reqBody[name]"] = employee.name
        params["reqBody[email]"] =  employee.email
        params["reqBody[mobile]"] =  employee.mobile
        params["reqBody[country]"] =  employee.address.country
        params["reqBody[password]"] =  employee.password
        //  params["reqBody[title]"] =  "owner" //TODO
        params["reqBody[dob]"] =  employee.dob
        params["reqBody[address][text]"] =  employee.address.text
        params["reqBody[address][pincode]"] =  employee.address.pincode
        params["reqBody[address][coordinates][0]"] =  (employee.address.coordinates?.first ?? 0.0).StringValue
        params["reqBody[address][coordinates][1]"] =  (employee.address.coordinates?.last ?? 0.0).StringValue
        params["reqBody[address][city]"] =  employee.address.city
        params["reqBody[address][state]"] =  employee.address.state
        params["reqBody[address][country]"] =  employee.address.country
        params["reqBody[driverLicense][card]"] =  employee.driverLicense.card
        params["reqBody[driverLicense][expiry]"] =  employee.driverLicense.expiry
        params["reqBody[driverLicense][state]"] =  employee.driverLicense.state
        
        params = getUpdateParams(params)
        
        print(params)
        
        var medias = [Media]()
        
        //  guard let employeePhoto = Media(stringData: employee.photo, forKey: "employeePhoto", name: employee.name, mimeType: "image/png") else { return }
        
        //  medias.append(employeePhoto)
        print("reached here 3")
        
        //TODO
        // guard let employeeDriverLicenseScan = Media(stringData: employee.driverLicense.scan!, forKey: "employeeDriverLicenseScan", name: employeename, mimeType: "application/pdf") else { return }
        //   medias.append(employeeDriverLicenseScan)
        
        
        
        PostController.shared.taskForPOSTRequest(url: NetworkConstants.getUserProfile , responseType: editProfileResponse.self, params: params, mediaData: [] + medias ,header: true, PUT : true) { (result, error) in
            print(result,error)
            if let result = result {
                if result.success {
                    completion(true,result.employeeObj,error)
                } else {
                    print(result.message)
                    completion(false,result.employeeObj,error)
                }
            } else {
                completion(false,nil,error)
            }
        }
    }
    
    
    
    func updateLicensee(_ licenseeData : Licensee?,logo : Bool,proof : Bool = false, completion: @escaping (Bool,String?,LicenseeDetails?) -> ()) {
        
        guard let licensee = licenseeData else { return }
        
        let licenseeName = licensee.name ?? ""
        let licenseeEmail = licensee.email ?? ""
        let licenseeMobile = licensee.mobile ?? ""
        let licenseeBusinessType = licensee.businessType ?? "individual"
        let licenseeAddressText = licensee.address?.text ?? ""
        let licenseeAddressPincode = licensee.address?.pincode ?? ""
        let licenseeAddressLat = (licensee.address?.coordinates.first ?? 0.0).StringValue
        let licenseeAddressLon = (licensee.address?.coordinates.last ?? 0.0).StringValue
        let licenseeAddresscity = licensee.address?.city ?? ""
        let licenseeAddressState = licensee.address?.state.longForm ?? ""
        let licenseeAddressCountry = licensee.country ?? "Australia"
        let licenseebsbNumber = licensee.bsbNumber ?? ""
        let licenseeaccountNumber = licensee.accountNumber ?? ""
        let licenseeurl = "https://github.com"
        let licenseetaxId = licensee.taxId ?? ""
        let licenseeworkingHours = licensee.workingHours ?? ""
        
        var params =  [
            "reqBody[name]": licenseeName,
            "reqBody[email]": licenseeEmail,
            "reqBody[mobile]": licenseeMobile,
            "reqBody[country]": licenseeAddressCountry,
            "reqBody[businessType]": licenseeBusinessType,
            "reqBody[address][text]": licenseeAddressText,
            "reqBody[address][pincode]": licenseeAddressPincode,
            "reqBody[address][coordinates][0]": licenseeAddressLat,
            "reqBody[address][coordinates][1]": licenseeAddressLon,
            "reqBody[address][city]": licenseeAddresscity,
            "reqBody[address][state]": licenseeAddressState,
            "reqBody[address][country]": licenseeAddressCountry,
            "reqBody[bsbNumber]": licenseebsbNumber,
            "reqBody[accountNumber]": licenseeaccountNumber,
            "reqBody[url]": licenseeurl,
            "reqBody[taxId]": licenseetaxId,
            "reqBody[workingHours]": licenseeworkingHours
            ] as [String:String]
        
        for day in licensee.workingDays {
            let index = licensee.workingDays.firstIndex(of: day)!
            params["reqBody[workingDays][\(index)]"] = day
        }
        
        params = getUpdateParams(params)
        
        print("params",params)
        
        
        var medias = [Media]()
        if logo {
            guard let licenseeLogo = Media(stringData: licensee.logo, forKey: "licenseeLogo", name: licenseeName, mimeType: "image/png") else { return }
            medias.append(licenseeLogo)
        }
        
        if proof {
            guard let licenseeProofOfIncorporation = Media(stringData: licensee.proofOfIncorporation, forKey: "licenseeProofOfIncorporation", name: licenseeName, mimeType: "application/pdf") else { return }
            medias.append(licenseeProofOfIncorporation)
        }
        
        PostController.shared.taskForPOSTRequest(url: NetworkConstants.editLicensee, responseType: editLicenseeResponse.self, params: params, mediaData: medias ,header: true, PUT: true) { (result, error) in
            if let result = result {
                if result.success {
                    completion(true,nil,result.licenseeObj)
                } else {
                    print(result.message)
                    completion(false,result.message,nil)
                }
            } else {
                completion(false,error,nil)
            }
        }
    }
    
    func addTrailer(_ trailer : AddTrailer,update : Bool = false, completion: @escaping (Bool,String?) -> ()) {
        
        var params = [String:String]()
        
        params["reqBody[name]"] = trailer.name ?? ""
        params["reqBody[vin]"] = trailer.vin ?? ""
        params["reqBody[type]"] = trailer.type ?? ""
        params["reqBody[description]"] = trailer.welcomeDescription ?? ""
        params["reqBody[size]"] = trailer.size ?? ""
        params["reqBody[capacity]"] = trailer.capacity ?? ""
        params["reqBody[tare]"] = trailer.tare ?? ""
        params["reqBody[age]"] = "\(trailer.age ?? 0)"
        params["reqBody[availability]"] = "true"
        params["reqBody[adminRentalItemId]"] = trailer.adminRentalItemId ?? ""
        params["reqBody[insurance][issueDate]"] = trailer.insurance?.issueDate ?? ""
        params["reqBody[insurance][expiryDate]"] = trailer.insurance?.expiryDate ?? ""
        params["reqBody[servicing][name]"] = trailer.service?.name ?? ""
        params["reqBody[servicing][serviceDate]"] = trailer.service?.serviceDate ?? ""
        params["reqBody[servicing][nextDueDate]"] = trailer.service?.nextDueDate ?? ""
        params["reqBody[features][0]"] = "Cool trailer" //TODO
        params["reqBody[trailerModel]"] = trailer.trailerModel ?? ""
        
        if update {
            params = getUpdateParams(params)
            params["reqBody[_id]"] = trailer.id!
        }
        
        guard let photos = trailer.photos else { return }
        
        var medias = [Media]()
        
        if let doc = trailer.insurance?.document{
        let insuranceDocument = Media(stringData: doc, forKey: "insuranceDocument", name: "Aaryan", mimeType: "application/pdf")
            medias.append(insuranceDocument!)
        }
        
        if let doc = trailer.service?.document{
         let servicingDocument = Media(stringData: doc, forKey: "servicingDocument", name: "servicingDocument", mimeType: "application/pdf")
        medias.append(servicingDocument!)

    }
        for photo in photos {
            guard let photo = Media(stringData: photo, forKey: "photos", name: "aaryan", mimeType: "image/png") else { return }
            medias.append(photo)
        }
        
        taskForPOSTRequest(url: NetworkConstants.addTrailerURL, responseType: SuccessModel.self, params: params, mediaData: medias) { (result, error) in
            print(result,error)
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
    
    
    func getUpdateParams(_ params : [String:String])->[String:String]{
        var updateParam = [String:String]()
        updateParam = params.filter{ $0.value != "" && $0.value != "0.0"}
        return updateParam
    }
    
    
    
    func addUpsell(_ upsellItem : AddUpsellItem?, update : Bool = false ,completion : @escaping (Bool,String?)->()) {
        guard let upsell = upsellItem else { return }
        
        var params = [
            "reqBody[name]" : upsell.name,
            "reqBody[type]" : upsell.type,
            "reqBody[description]" : upsell.description,
            "reqBody[adminRentalItemId]" : upsell.adminRentalItemId,
            "reqBody[quantity]" : "\(upsell.quantity)",
            "reqBody[trailerModel]" : upsell.trailerModel ?? "",
            "reqBody[availibility]" : "true"
            ] as [String:String]
        
        if update {
            params["reqBody[_id]"] = upsell._id ?? ""
        }
        
        var medias = [Media]()
        
        print(params)
        
        for photo in upsell.photos {
            guard let photo = Media(stringData: photo, forKey: "photos", name: "aaryan", mimeType: "image/png") else { return }
            medias.append(photo)
            
        }
        
        taskForPOSTRequest(url: NetworkConstants.addUpsellURL, responseType: SuccessModel.self, params: params, mediaData: medias) { (result, error) in
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
    
    func addInsurance(_ insuranceItem : InsuranceList?, update : Bool = false ,completion : @escaping (Bool,String?)->()) {
        guard let insurance = insuranceItem else { return }
        
        var params = [
            "reqBody[itemId]": insurance.itemId ?? "",
            "reqBody[issueDate]" : insurance.issueDate ?? "",
            "reqBody[expiryDate]" : insurance.expiryDate ?? ""
            ] as [String:String]
        
        if update {  params["reqBody[_id]"] = insurance.id ?? ""   } else
        { params["reqBody[itemType]"] = insurance.itemType ?? "Trailer" }
        
        print(params)
        
        guard let  media = Media(stringData: insurance.document?.data ?? "", forKey: "insuranceDocument", name: "Aaryan", mimeType: "application/pdf") else { return }
        
        taskForPOSTRequest(url: NetworkConstants.insurance, responseType: SuccessModel.self, params: params, mediaData: [media]) { (result, error) in
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
    
    
    
    
    
    func addServicing(_ serviceItem : ServicingList?, update : Bool = false ,completion : @escaping (Bool,String?)->()) {
        
        guard let service = serviceItem else { return }
        
        var params = [
            "reqBody[itemId]": service.itemId ?? "",
            "reqBody[itemType]" : service.itemType ?? "Trailer",
            "reqBody[serviceDate]" : service.serviceDate ?? "",
            "reqBody[nextDueDate]" : service.nextDueDate ?? "",
            "reqBody[name]" : service.name ?? ""
            ] as [String:String]
        
        if update {   params["reqBody[_id]"] = service.id!   }
        
        
        guard let  media = Media(stringData: service.document?.data ?? "", forKey: "servicingDocument", name: "Aaryan", mimeType: "application/pdf") else { return }
        
        taskForPOSTRequest(url: NetworkConstants.services, responseType: SuccessModel.self, params: params, mediaData: [media]) { (result, error) in
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
    
    func trackingUpdate(_ locationData : TrackingTripStatus?,completion : @escaping (Bool,String?)->()) {
        
        guard let data = locationData else { return }
        
        let params = [
            "reqBody[rentalId]": data.rentalId,
            "reqBody[type]" : data.type,
            "reqBody[action]" : data.action
            ] as [String:String]
        
        
        var medias = [Media]()
        if data.type == "dropoff" && data.action == "end"{
            guard let  media = Media(stringData: data.driverLicenseScan ?? "", forKey: "driverLicenseScan", name: "Aaryan", mimeType: "application/pdf") else { return }
            medias.append(media)
        }
        
        taskForPOSTRequest(url: NetworkConstants.trackingStatus, responseType: SuccessModel.self, params: params, mediaData: medias) { (result, error) in
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
    

    
    func trailerStatusUpdate(_ locationData : TrailerStatus?,completion : @escaping (Bool,String?)->()) {
        
        guard let data = locationData else { return }
        
        let params = [
            "reqBody[rentalId]": data.rentalId,
            "reqBody[status]" : data.status,
            ] as [String:String]
        
        
        var medias = [Media]()
        if data.status == "delivered" {
            guard let  media = Media(stringData: data.driverLicenseScan ?? "", forKey: "driverLicenseScan", name: "Aaryan", mimeType: "image/png") else { return }
            medias.append(media)
        }
        
        taskForPOSTRequest(url: NetworkConstants.trailerStatusURL, responseType: SuccessModel.self, params: params, mediaData: medias) { (result, error) in
            if let result = result {
                if result.success {
                    completion(true,nil)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,error)
            }
        }
    }
}



extension String {
    var longForm : String {
        var states = [
            "NSW" : "New South Wales",
            "QLD": "Queensland",
            "SA" : "South Australia",
            "TAS" : "Tasmania",
            "VIC" : "Victoria",
            "WA" : "Western Australia"]
        
        return (states[self] == nil) ? self : states[self]!
    }
}
