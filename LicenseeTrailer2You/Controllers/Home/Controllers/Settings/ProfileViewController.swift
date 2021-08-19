//
//  ProfileViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 10/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import QuartzCore
import ProgressHUD
import CoreLocation

class ProfileViewController: UIViewController, LogoutDelegate {
    
    var lineChart: LineChart!
    var licenseeAddress = ""
    var financials: Financials? = nil
    var finances : [CGFloat] = []
    var user : UserProfile? = nil
    
    var segueIdentifiers = ["licensee","profileDetails","aboutus","finances"]
    
    
    @IBAction func unwindAfterInvite(_ unwindSegue: UIStoryboardSegue) {}
    @IBAction func unwindToProfileTab(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var tableview: UITableView!
    
    var employee: EmployeeDetails?
    var licensee: LicenseeDetails?
    lazy var geocoder = CLGeocoder()
    
    let notifCellData = [notifDetails(title: "About us", subtitle: "Some information about us", logo: #imageLiteral(resourceName: "Info")),notifDetails(title: "Financials", subtitle: "Know your finances", logo: #imageLiteral(resourceName: "finance"))]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        tableview.delegate = self
        tableview.dataSource = self
        
        //TODO
        ServiceController.shared.getFinancials { (result, success, message) in
            print(result,success,message)
        }
    }
    
    
    
    @objc func getProfileDetails() {
        self.performSegue(withIdentifier: "profileDetails", sender: Any?.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controller = 4
        ProgressHUD.show("Fetching Profile Details")
        
        let decoder = JSONDecoder()
        if let emp = Constant.loginDefaults?.value(forKey: Keys.userObject) as? Data {
            if let loadedEmployee = try? decoder.decode(EmployeeDetails.self, from: emp) {
                employee = loadedEmployee
            }
        }
        
        if let lic = Constant.loginDefaults?.value(forKey: Keys.licenseeObject) as? Data {
            if let loadedLicensee = try? decoder.decode(LicenseeDetails.self, from: lic) {
                licensee = loadedLicensee
            }
        }
        
        ServiceController.shared.getUserDetails { (user, status, message) in
            print("getDetails:",status)
            if status {
                self.user = user
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.licensee?.name = user?.licenseeObj?.name
                    self.licensee?.email = user?.licenseeObj?.email
                    self.licensee?.logo?.data = user?.licenseeObj?.logo?.data //TODO
                    
                    self.employee?.name = user?.employeeObj?.name
                    self.employee?.mobile = user?.employeeObj?.mobile
                    self.employee?.photo = user?.employeeObj?.photo
                }
            }
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self.tableview.reloadData()
            }
        }
        loadFinancials()
    }
    
    func logout(){
        DispatchQueue.main.async {
            //            Constant.loginDefaults?.set(self.usernameField.text!, forKey: Keys.userEmail)
            //            Constant.loginDefaults?.set(self.passwordField.text!, forKey: Keys.userPassword)
            //            Constant.loginDefaults?.set(true, forKey: Keys.isLoggedIn)
            //            Constant.loginDefaults?.set(loginResponse?.token, forKey: Keys.userToken)
            let mainStoryboard = AppStoryboard.login.instance
            if let initialViewController = mainStoryboard.instantiateInitialViewController() {
                Constant.loginDefaults?.removeObject(forKey: Keys.userEmail)
                Constant.loginDefaults?.removeObject(forKey: Keys.userPassword)
                Constant.loginDefaults?.set(false, forKey: Keys.isLoggedIn)
                Constant.loginDefaults?.removeObject(forKey: Keys.userToken)
                
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    func logoutTapped() {
        logout()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finances" {
            let vc = segue.destination as! FinancesViewController
            vc.finances = self.financials
        }
        
        if let profileVC = segue.destination as? ProfileDetailsViewController {
            profileVC.profile = user
        }
        
        if let licenseeVC = segue.destination as? LicenseeDetailsViewController {
            licenseeVC.delegate = self
            licenseeVC.user = user
        }
    }
    
    func loadFinancials() {
        if Defaults.getPrivileges(key: AccessCategory.FINANCIALS.localized(), access: AccessType.VIEW.rawValue) {
            ServiceController.shared.getFinancials { (finances, status, error) in
                if status {
                    self.financials = finances
                } else {
                    ProgressHUD.showError(error!)
                }
            }
        }
    }
}

extension ProfileViewController: LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        self.performSegue(withIdentifier: "finances", sender: Any?.self)
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 4 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableview.dequeueReusableCell(withIdentifier: "notificationcell") as! NotificationCell
            cell.imageview.layer.cornerRadius = 7
            
            if indexPath.row == 0 {
                cell.title.text = licensee?.name ?? ""
                cell.subtitle.text = licensee?.email ?? ""
                if let url = URL(string: user?.licenseeObj?.logo?.data ?? ""){
                    cell.imageview.kf.setImage(with: url)
                }
            } else if indexPath.row == 1 {
                cell.title.text = employee?.name ?? ""
                cell.subtitle.text = employee?.mobile ?? ""
                if let url = URL(string: user?.employeeObj?.photo?.data ?? ""){
                    cell.imageview.kf.setImage(with: url)
                }
            }
            else {
                
                let data = notifCellData[indexPath.row - 2]
                cell.title.text = data.title
                cell.subtitle.text = data.subtitle
                cell.imageview?.image = data.logo
            }
            cell.card.makeCard()
            cell.card.makeBorder()
            return cell
        } else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "logout") as! LogoutCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        tableview.deselectRow(at: indexPath, animated: true)
        
        let identifier = segueIdentifiers[indexPath.row]
        if indexPath == IndexPath(row: 5, section: 0){
            if Defaults.getPrivileges(key: AccessCategory.FINANCIALS.localized(), access: AccessType.VIEW.rawValue) {
                self.performSegue(withIdentifier: "finances", sender: Any?.self)
            } else {
                ProgressHUD.showError("unauthorized")
            }
        } else {
            performSegue(withIdentifier: identifier, sender: Any?.self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ProfileViewController : licenseeDelegate {
    func didEnterLicensee(licensee: LicenseeDetails) {
        self.licensee?.name = licensee.name
        self.licensee?.email = licensee.email
        self.licensee?.logo = licensee.logo
        
        //self.user?.licenseeObj = licensee
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
        
        ServiceController.shared.getUserDetails { (user, status, message) in
            if status {
                self.user = user
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        }
        
    }
}


struct notifDetails {
    var title : String
    var subtitle : String
    var logo : UIImage
}




//    func loadChart() {
//        var cumIncome: CGFloat = 0
//        let invoices = financials?.financialsObj.invoicesList ?? []
//        for item in invoices {
//            let price = item.totalCharges.total
//            cumIncome = cumIncome + CGFloat(price ?? 0)
//            finances.append(cumIncome)
//        }
//
//        lineChart.addLine(finances)
//        lineChart.lineWidth = 2
//        lineChart.colors = [#colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)]
//        lineChart.x.grid.visible = false
//        lineChart.x.labels.visible = false
//        lineChart.y.grid.visible = false
//        lineChart.y.labels.visible = false
//        lineChart.y.axis.visible = false
//        lineChart.x.axis.visible = false
//        lineChart.animation.enabled = true
//        lineChart.area = true
//        lineChart.x.labels.visible = true
//        lineChart.x.grid.count = 5
//        lineChart.y.grid.count = 5
//        lineChart.delegate = self
//            // print(incomeGraph.frame)
//        lineChart.frame = CGRect(x: incomeGraph.frame.minX, y: incomeGraph.frame.minY, width: incomeGraph.frame.width, height: incomeGraph.frame.height)
//        view.addSubview(lineChart)
//        lineChart.sizeToFit()
//        totalAmount.text = "\(round(cumIncome)) AUD"
//    }

