//
//  PostController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 10/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

class PostController {
    static let shared: PostController = PostController()
    
    func addTrailer(trailerObject: Data, completion: @escaping(String?, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.addTrailerURL, parameters: [:], header: true, requestBody: trailerObject) { (data) in
            guard let data = data else { return }
            do {
                let addTrailerResponse = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(addTrailerResponse.message, addTrailerResponse.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func addUpsell(upsellObject: Data, completion: @escaping(String?, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.addUpsellURL, parameters: [:], header: true, requestBody: upsellObject) { (data) in
            guard let data = data else { return }
            do {
                let addUpsellResponse = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(addUpsellResponse.message, addUpsellResponse.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func login(loginObject: Data, completion : @escaping(LoginResponse?, Bool, String?) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.signInURL, parameters: [:], header: false, requestBody: loginObject) { (data) in
            guard let data = data else { return }
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(loginResponse, loginResponse.success, nil)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(nil, false, error?.errorsList[0] ?? NetworkErrors.serverError)
            }
        }
    }
    
    func signup(signUpObject: Data, completion: @escaping(String?, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.signUpURL, parameters: [:], header: false, requestBody: signUpObject) { (data) in
            guard let data = data else { return }
            do {
                let signUpResponse = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(signUpResponse.message, signUpResponse.success)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func forgotPassword(forgotPasswordObject: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPutRequest(NetworkConstants.forgotPasswordURL, parameters: [:], header: true, requestBody: forgotPasswordObject) { (data) in
            guard let data = data else { return }
            do {
                let forgotPassword = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(forgotPassword.message, forgotPassword.success)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func changePassword(changePasswordObject: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPutRequest(NetworkConstants.changePasswordURL, parameters: [:], header: true, requestBody: changePasswordObject) { (data) in
            guard let data = data else { return }
            do {
                let forgotPassword = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(forgotPassword.message, forgotPassword.success)
            } catch {
                print(error)
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func resetPassword(resetPasswordObject: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPutRequest(NetworkConstants.resetPasswordURL, parameters: [:], header: false, requestBody: resetPasswordObject) { (data) in
            guard let data = data else { return }
            do {
                let resetPassword = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(resetPassword.message, resetPassword.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func requestManager(requestObject: Data, completion: @escaping(String, Bool)->()) {
        WebHelper.sendPostRequest(NetworkConstants.requestApproval, parameters: [:], header: true, requestBody: requestObject) { (data) in
            guard let data = data else { return }
            do {
                let requestResponse = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(requestResponse.message, requestResponse.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func verifyOTP(verificationObject: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.verifyOTPURL, parameters: [:], header: false, requestBody: verificationObject) { (data) in
            guard let data = data else { return }
            do {
                let verification = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(verification.message, verification.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func resendOTP(resendObject: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.resendOTPURL, parameters: [:], header: true, requestBody: resendObject) { (data) in
            guard let data = data else { return }
            do {
                let otpSent = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(otpSent.message, otpSent.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func resendEmail(resendObject: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.resendEmailURL, parameters: [:], header: true, requestBody: resendObject) { (data) in
            guard let data = data else { return }
            do {
                let otpSent = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(otpSent.message, otpSent.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    
    func sendInvitation(inviteObject: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.sendInviteURL, parameters: [:], header: true, requestBody: inviteObject) { (data) in
            guard let data = data else { return }
            do {
                let invite = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(invite.message, invite.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func trackVehicle(coordinates: Data, completion:@escaping(String,Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.trackingURL, parameters: [:], header: true, requestBody: coordinates) { (data) in
            guard let data = data else { return }
            do {
                let tracking = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(tracking.message, tracking.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func UpdateTrailerStatus(coordinates: Data, completion:@escaping(String,Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.trackingURL, parameters: [:], header: true, requestBody: coordinates) { (data) in
            guard let data = data else { return }
            do {
                let tracking = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(tracking.message, tracking.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    
    func addSchedule(schedule: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPostRequest(NetworkConstants.blockTrailer, parameters: [:], header: true, requestBody: schedule) { (data) in
            guard let data = data else { return }
            do {
                let blocked = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(blocked.message, blocked.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func editLicensee(licensee: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPutRequest(NetworkConstants.editLicensee, parameters: [:], header: true, requestBody: licensee) { (data) in
            guard let data = data else { return }
            do {
                let updated = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(updated.message, updated.success)
            } catch {
                let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
                completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func editUserProfile(user: Data, completion: @escaping(String, Bool) -> ()) {
        WebHelper.sendPutRequest(NetworkConstants.getUserProfile, parameters: [:], header: true, requestBody: user) { (data) in
            guard let data = data else { return }
            do {
                let updated = try JSONDecoder().decode(SuccessModel.self, from: data)
                completion(updated.message, updated.success)
            } catch {
               let error = try? JSONDecoder().decode(ErrorModel.self, from: data)
               completion(error?.errorsList[0] ?? NetworkErrors.serverError, false)
            }
        }
    }
    
    func updateACL(data : [String:String], completion: @escaping(Bool, String) -> ()) {

        PostController.shared.taskForPOSTRequest(url: NetworkConstants.getUserProfile , responseType: SuccessModel.self, params: data, mediaData: [],header: true, PUT : true) { (result, error) in
            print(result,error)
            if let result = result {
                if result.success {
                    completion(true,result.message)
                } else {
                    completion(false,result.message)
                }
            } else {
                completion(false,"error")
            }
        }
    }
    
    func rateCustomer(req:Data, completion: @escaping (Bool)->()) {
        WebHelper.sendPostRequest(NetworkConstants.rating, parameters: [:], header: true, requestBody: req) { (data) in
            guard let data = data else { return }
            do {
                let charges = try JSONDecoder().decode(RatingResponse.self, from: data)
                completion(charges.success ?? false)
            } catch {
                completion(false)
            }
        }
    }
    
    func getCharges(_ booking: Data, completion: @escaping(Charges?)->()) {
        WebHelper.sendPostRequest(NetworkConstants.charges, parameters: [:], header: true, requestBody: booking) { (data) in
            guard let data = data else { return }
            do {
                let charges = try JSONDecoder().decode(Charges.self, from: data)
                completion(charges)
            } catch {
                completion(nil)
            }
        }
    }
    
}
