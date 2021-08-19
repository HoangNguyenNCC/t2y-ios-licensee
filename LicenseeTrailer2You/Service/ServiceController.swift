//
//  ServiceController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 26/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class ServiceController {
    
    static let shared: ServiceController = ServiceController()
    
    func getLicenseeTrailers(completion: @escaping(AllItems?,Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.getTrailers, parameters: ["count":"30"], header: true) { (data) in
            guard let data = data else { return }
            do {
                let listings = try JSONDecoder().decode(AllItems.self, from: data)
                completion(listings,listings.success ?? false,nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getLicenseeUpsell(completion: @escaping(AllItems?,Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.getUpsell, parameters: ["count":"50"], header: true) { (data) in
            guard let data = data else { return }
            do {
                let listings = try JSONDecoder().decode(AllItems.self, from: data)
                completion(listings,listings.success ?? false,nil)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getLicenseeEmployees(completion: @escaping(AllItems?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.getEmployees, parameters: [:], header: true) { (data) in
            guard let data = data else { return }
            do {
                let employee = try JSONDecoder().decode(AllItems.self, from: data)
                completion(employee,employee.success ?? false,nil)
            } catch {
                print("error :",error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getAdminTrailers(completion: @escaping(TrailerListings?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.adminTrailers, parameters: ["count":"50"], header: true) { (data) in
                   guard let data = data else { return }
                   do {
                       let listings = try JSONDecoder().decode(TrailerListings.self, from: data)
                       completion(listings,listings.success ?? false,nil)
                   } catch {
                       print(error)
                       let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                       completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
                   }
               }
    }
    
    func getAdminUpsell(completion: @escaping(UpsellListings?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.adminUpsell, parameters: ["count":"50"], header: true) { (data) in
                   guard let data = data else { return }
                   do {
                       let listings = try JSONDecoder().decode(UpsellListings.self, from: data)
                    completion(listings,listings.success ?? false,nil)
                   } catch {
                       let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                       completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
                   }
               }
    }
    
    func getRentalRequests(completion: @escaping(RentalRequest?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.rentalRequestURL, parameters: ["count":"100"], header: true) { (data) in
            guard let data = data else { return }
            do {
                let requests = try JSONDecoder().decode(RentalRequest.self, from: data)
                completion(requests,requests.success ?? false,nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getTrailerInsurances(trailerId: String,completion: @escaping(InsuranceRequest?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.insurance, parameters: ["itemId":trailerId,"count":"30"], header: true) { (data) in
            guard let data = data else { return }
            do {
                let requests = try JSONDecoder().decode(InsuranceRequest.self, from: data)
                completion(requests,requests.success ?? false,nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getTrailerServices(trailerId: String,completion: @escaping(ServicingRequest?, Bool, String?) -> ()) {
         WebHelper.sendGETRequest(NetworkConstants.services, parameters: ["itemId":trailerId,"count":"30"], header: true) { (data) in
             guard let data = data else { return }
             do {
                 let requests = try JSONDecoder().decode(ServicingRequest.self, from: data)
                 completion(requests,requests.success ?? false,nil)
             } catch {
                 print(error)
                 let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                 completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
             }
         }
     }
    
    func getReminders(completion: @escaping(Reminder?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.remindersURL, parameters: ["count":"100"], header: true) { (data) in
            guard let data = data else { return }
            do {
                let reminders = try JSONDecoder().decode(Reminder.self, from: data)
                completion(reminders,reminders.success,nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getTrailerDetails(trailerId: String, completion: @escaping(GetTrailerDetails?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.getTrailerInfo, parameters: ["id":trailerId], header: true) { (data) in
            guard let data = data else { return }
            do {
                let trailerDetails = try JSONDecoder().decode(GetTrailerDetails.self, from: data)
                completion(trailerDetails,trailerDetails.success,nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getUpsellDetails(upsellId: String, completion: @escaping(GetUpsellDetails?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.getUpsellInfo, parameters: ["id":upsellId], header: true) { (data) in
            guard let data = data else { return }
            do {
                let upsellDetails = try JSONDecoder().decode(GetUpsellDetails.self, from: data)
                completion(upsellDetails,upsellDetails.success ?? false,nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getUserDetails(completion: @escaping(UserProfile?, Bool, String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.getUserProfile, parameters: [:], header: true) { (data) in
            guard let data = data else { return }
            do {
                let user = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(user,user.success,nil)
            } catch {
                print("ABCD",error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getRentalDetails(rentalId: String, completion: @escaping(Invoice?,Bool,String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.invoiceDetailURL, parameters: ["id":rentalId], header: true) { (data) in
            guard let data = data else { return }
            do {
                let invoice = try JSONDecoder().decode(Invoice.self, from: data)
                completion(invoice, true, nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil, false, error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func getFinancials(completion: @escaping(Financials?,Bool,String?) -> ()) {
        WebHelper.sendGETRequest(NetworkConstants.financialsURL, parameters: ["count":"30","userType":"licensee"], header: true) { (data) in
            guard let data = data else { return }
            do {
                let financials = try JSONDecoder().decode(Financials.self, from: data)
                completion(financials,financials.success,nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
//    func getRentalCharges(url: String, completion: @escaping(Charges?, Bool, String?) -> ()) {
//        
//        WebHelper.sendGETRequest(NetworkConstants.chargesURL, parameters: [:], header: true) { (data) in
//            guard let data = data else { return }
//            do {
//                let charges = try JSONDecoder().decode(Charges.self, from: data)
//                completion(charges, charges.success, nil)
//            } catch {
//                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
//                completion(nil,false,error?.errorsList[0] ?? NetworkErrors.serverError)
//            }
//        }
//    }
    
    func getACL(completion: @escaping([String:[String]]?, Bool) -> ()) {
        DispatchQueue.global(qos: .background).async {
            WebHelper.sendGETRequest(NetworkConstants.aclURL, parameters: [:], header: false) { (data) in
                guard let data = data else { return }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let access = json["accessControlList"] as? [String: [String]] {
                            completion(access, true)
                        } else {
                            completion(nil, false)
                        }
                    } else {
                        completion(nil, false)
                    }
                } catch {
                    completion(nil, false)
                }
            }
        }
    }
    
    func deleteTrailer(trailerId: Data, completion: @escaping(Bool, String?) -> ()) {
        WebHelper.sendDeleteRequest(NetworkConstants.deleteTrailer, parameters: [:], header: true, requestBody: trailerId) { (data) in
            guard let data = data else { return }
            do {
                let deleted = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(deleted.success, deleted.message)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(false, error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func deleteUpsell(upsellId: Data, completion: @escaping(Bool, String?) -> ()) {
        WebHelper.sendDeleteRequest(NetworkConstants.deleteUpsell, parameters: [:], header: true, requestBody: upsellId) { (data) in
            guard let data = data else { return }
            do {
                let deleted = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(deleted.success, deleted.message)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(false, error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func deleteEmployee(employeeId: Data, completion: @escaping(Bool, String?) -> ()) {
        WebHelper.sendDeleteRequest(NetworkConstants.deleteEmployee, parameters: [:], header: true, requestBody: employeeId) { (data) in
            guard let data = data else { return }
            do {
                let deleted = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(deleted.success, deleted.message)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(false,error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
}
