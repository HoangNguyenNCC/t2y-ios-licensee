//
//  ScheduleViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 27/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD
import JTAppleCalendar

protocol ChargesDelegate : class {
    func returnDateTime(start: String, end: String)
}

class ScheduleViewController: UIViewController {
    
    var times = [String]()
    var firstDate: Date?
    var secondDate: Date?
    var datePicker = UIDatePicker()
    var activeTextField : UITextField!
    var upsell: AllItems? = nil
    var trailer: AllItems? = nil
    var charges : Bool = false
    weak var delegate : ChargesDelegate?
    
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var subtitle: UILabel!
    
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && calendarView.selectedDates.count > 1
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    var months = 0
    var dates = [String]()
    let df = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomBar.makeCard()
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        overrideUserInterfaceStyle = .light
        fromField.delegate = self
        toField.delegate = self
        
        if charges {
            subtitle.text = "GET CHARGES"
        } else {
            ServiceController.shared.getLicenseeUpsell { (upsell, status, message) in
                DispatchQueue.main.async {
                    if status {
                        self.upsell = upsell
                    }
                }
            }
            
            ServiceController.shared.getLicenseeTrailers { (trailer, status, message) in
                DispatchQueue.main.async {
                    if status {
                        self.trailer = trailer
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        nextBttn.layer.cornerRadius = 8
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func nextBttnTapped(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let firstDate = firstDate, let secondDate = secondDate {
            dates = [formatter.string(from: firstDate), formatter.string(from: secondDate)]
            if fromField.text != "" && toField.text != "" {
                times = [fromField.text!, toField.text!]
                if charges{
                    let start = dates[0] + " " + times[0]
                    let end = dates[1] + " " + times[1]
                    delegate?.returnDateTime(start: start, end: end)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "selection", sender: Any?.self)
                }
            } else {
                ProgressHUD.showError("Please enter the date and time")
            }
        } else {
            ProgressHUD.showError("Please enter the date and time")
        }
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.secondaryLabel
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        switch cellState.selectedPosition() {
        case .left:
            cell.selectedView.layer.cornerRadius = 24
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .middle:
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = []
        case .right:
            cell.selectedView.layer.cornerRadius = 24
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .full:
            cell.selectedView.layer.cornerRadius = 24
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        default: break
        }
        
        if cellState.isSelected {
            cell.dateLabel.textColor = UIColor.white
        }
    }
    
    func setupDatePicker(textField: UITextField) {
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216))
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
        datePicker.backgroundColor = .secondarySystemBackground
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(timeSelected))
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        toolBar.barTintColor = .secondarySystemBackground
        toolBar.sizeToFit()
        
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
    }
    
    @objc func timeSelected() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        activeTextField.text = dateformatter.string(from: datePicker.date)
        activeTextField.resignFirstResponder()
    }
}

extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print(currentDate)
        print(futureDate!)
        return ConfigurationParameters(startDate: currentDate, endDate: futureDate!, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, hasStrictBoundaries: false)
    }
}

extension ScheduleViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        df.dateFormat = "MMM YYYY"
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = df.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if firstDate != nil {
            secondDate = date
            toDate.text = formatter.string(from: date)
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
            secondDate = date
            fromDate.text = formatter.string(from: date)
            toDate.text = formatter.string(from: date)
        }
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < calendarView.selectedDates[0] {
            firstDate = nil
            let retval = !calendarView.selectedDates.contains(date)
            calendarView.deselectAllDates()
            return retval
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if twoDatesAlreadySelected && cellState.selectionType != .programatic {
            firstDate = nil
            calendarView.deselectAllDates()
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UnavailableItemsViewController {
            vc.upsellData = upsell?.upsellItemsList ?? []
            vc.trailerData = trailer?.trailersList ?? []
            vc.startDate = dates[0] + " " + times[0]
            vc.endDate = dates[1] + " " + times[1]
        }
    }
}

extension ScheduleViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        setupDatePicker(textField: textField)
    }
}

class DateHeader: JTAppleCollectionReusableView  {
    @IBOutlet var monthTitle: UILabel!
}
