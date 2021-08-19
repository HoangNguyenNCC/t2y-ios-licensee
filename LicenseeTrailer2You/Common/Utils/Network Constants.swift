//
//  Network Constants.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 02/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation

struct NetworkConstants {
    
     public static let baseURL = "http://trailer2you.herokuapp.com/"
    //    public static let baseURL = "https://t2ytest-private.herokuapp.com/"
  //  public static let baseURL = "https://t2ybeta.herokuapp.com/"
    
    public static let signUpURL = baseURL + "licensee/"
    public static let editLicensee = baseURL + "licensee"
    public static let signInURL = baseURL + "employee/signin/"
    public static let addInsuranceURL = baseURL + "insurance/"
    public static let addServicingURL = baseURL + "servicing/"
    public static let addTrailerURL = baseURL + "trailer/"
    public static let addUpsellURL = baseURL + "upsellitem/"
    public static let remindersURL = baseURL + "reminders/"
    public static let getTrailers = baseURL + "licensee/trailers/"
    public static let getTrailerInfo = baseURL + "licensee/trailer/"
    public static let getUpsell = baseURL + "licensee/upsellitems/"
    public static let getUpsellInfo = baseURL + "licensee/upsellitem/"
    public static let sendInviteURL = baseURL + "employee/invite/"
    public static let forgotPasswordURL = baseURL + "employee/forgotpassword/"
    public static let changePasswordURL = baseURL + "employee/password/change"
    public static let resetPasswordURL = "employee/resetpassword"
    public static let rentalRequestURL = baseURL + "rental/requests/"
    public static let aclURL = baseURL + "licensee/employee/acl"
    public static let requestApproval = baseURL + "rental/approval"
    public static let locationURL = baseURL + "rental/location"
    public static let trailerStatusURL = baseURL + "rental/status"
    public static let chargesURL = baseURL + "trailer/"
    public static let documentsURL = baseURL + "licensee/docs/"
    public static let financialsURL = baseURL + "licensee/financial"
    public static let adminTrailers = baseURL + "licensee/trailers/admin"
    public static let adminUpsell = baseURL + "licensee/upsellitems/admin"
    public static let verifyOTPURL = baseURL + "licensee/otp/verify"
    public static let resendOTPURL = baseURL + "licensee/otp/resend"
    public static let resendEmailURL = baseURL + "licensee/email/verify/resend"
    public static let invoiceDetailURL = baseURL + "rental/details"
    public static let getUserProfile = baseURL + "employee/profile"
    public static let getEmployees = baseURL + "employees"
    public static let blockTrailer = baseURL + "trailer/block"
    public static let deleteTrailer = baseURL + "trailer/"
    public static let deleteUpsell = baseURL + "upsellitem/"
    public static let deleteEmployee = baseURL + "employee/"
    public static let trackingURL = baseURL + "rental/location/"
    public static let trackingStatus = baseURL + "rental/location/track"
    public static let employeeSignupURL = baseURL + "employee/invite/accept"
    public static let insurance = baseURL + "insurance"
    public static let services = baseURL + "servicing"
    public static let charges = baseURL + "booking/charges"
    public static let rating = baseURL + "user/rating"    
}
