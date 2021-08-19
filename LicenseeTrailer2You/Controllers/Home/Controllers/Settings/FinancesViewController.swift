//
//  FinancesViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 09/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

//TODO show message for zero income
class FinancesViewController: UIViewController {
    
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var dataAvailability: UILabel!
    @IBOutlet weak var financeList: UITableView!
    @IBOutlet weak var financialGraph: UIView!
    
    var finances: Financials? = nil
    var lineChart: LineChart!
    var priceHistory: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        financeList.dataSource = self
        financeList.delegate = self
        
        lineChart = LineChart()
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        drawChart()
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    func drawChart() {
        
        guard let invoices = self.finances?.finances else { return }
        var paidFinances = invoices.filter{ $0.isLicenseePaid }
        var cumIncome: CGFloat = 0
        
        for item in paidFinances {
            let price = item.calculatePrice()
            cumIncome = cumIncome + CGFloat(price)
            priceHistory.append(cumIncome)
           }
        
        if priceHistory.count != 0 {
            lineChart.addLine(priceHistory)
            lineChart.lineWidth = 2
            lineChart.colors = [#colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)]
            lineChart.x.grid.visible = false
            lineChart.x.labels.visible = false
            lineChart.y.grid.visible = false
            lineChart.y.labels.visible = false
            lineChart.y.axis.visible = false
            lineChart.x.axis.visible = false
            lineChart.animation.enabled = true
            lineChart.area = true
            lineChart.x.labels.visible = true
            lineChart.x.grid.count = CGFloat(paidFinances.count)
            lineChart.y.grid.count = 5
            lineChart.delegate = self
            totalAmount.text = "\(round(cumIncome)) AUD"
            lineChart.frame = financialGraph.frame
            view.addSubview(lineChart)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RequestDetailsViewController {
            vc.invoiceDetails = sender as? Invoice
        }
    }
}

extension FinancesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finances?.finances.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "finance", for: indexPath) as! FinanceCell
        let finance = finances?.finances[indexPath.row]
        cell.financeCard.makeCard()
        cell.trailerName.text = finance?.trailerDetails.name ?? ""
        cell.trailerPrice.textColor = (finance?.isLicenseePaid ?? false) ? .green : .orange
        cell.trailerPrice.text = "\(round(finance?.calculatePrice() ?? 0.0)) AUD"
        cell.trailerImage.image = Defaults.cacheImage(key: (finance?.trailerDetails._id ?? "")!, url: ((finance?.trailerDetails.photos.first?.data) ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invoiceId = self.finances?.finances[indexPath.row].rentalId ?? ""
        ServiceController.shared.getRentalDetails(rentalId: invoiceId) { (invoiceDetails, status, error) in
            print(status,error)
            if status {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "financerental", sender: invoiceDetails)
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.showError("No Invoice Found")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FinancesViewController: LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        print("x: \(x)     y: \(yValues)")
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
}
