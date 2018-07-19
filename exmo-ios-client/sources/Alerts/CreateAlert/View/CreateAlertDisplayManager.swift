//
//  CreateAlertDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

//
// @MARK: Model
//
class CreateAlertItem {
    enum FieldType {
        case None
        case ActiveInput
        case InactiveInput
        case CurrencyPair
        case Sound
        case Button
        case TwoButtons
        case OrderBy
        case NotificationType
        case Note
    }
    
    var fieldType: FieldType = .None
    var textContainer: [String:String]
    
    convenience init(fieldType: FieldType) {
        self.init(fieldType: fieldType, headerText: "", leftText: "")
    }
    
    init(fieldType: FieldType, headerText: String, leftText: String, rightText: String = "") {
        self.fieldType = fieldType
        textContainer = [String:String]()
        self.textContainer["headerText"] = headerText
        self.textContainer["leftText"] = leftText
        self.textContainer["rightText"] = rightText
    }
    
    func getHeaderText() -> String {
        return textContainer["headerText"] ?? ""
    }
    
    func getLeftText() -> String {
        return textContainer["leftText"] ?? ""
    }
    
    func getRightText() -> String {
        return textContainer["rightText"] ?? ""
    }
}

//
// @MARK: DisplayManager
//

enum CellName: String {
    case AddAlertTableViewCell
    case AlertTableViewCellWithArrow
    case AlertTableViewCellButton
    case OrderByTableViewCell
    case SwitcherTableViewCell
}

enum FieldType: Int {
    case CurrencyPair = 0
    case AlertSound = 4
}

class CreateAlertDisplayManager: NSObject {
    private var dataProvider: [CreateAlertItem] = []
    private var tableView: UITableView!
    private var currencyRow: AlertTableViewCellWithArrow? = nil
    private var soundRow: AlertTableViewCellWithArrow? = nil
    private var tableCells: [IndexPath : AlertTableViewCellWithTextData] = [:]
    
    
    var output: CreateAlertViewOutput!
    
    override init() {
        super.init()
        dataProvider = getFieldsForRender()
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerTableCells()
        self.tableView.reloadData()
    }
    
    private func registerTableCells() {
        let classes = [
            CellName.AddAlertTableViewCell.rawValue,
            CellName.AlertTableViewCellWithArrow.rawValue,
            CellName.AlertTableViewCellButton.rawValue,
            CellName.SwitcherTableViewCell.rawValue
        ]
        for className in classes {
            self.tableView.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
        }
    }
    
    private func getFieldsForRender() -> [CreateAlertItem] {
        return [
            CreateAlertItem(fieldType: .CurrencyPair, headerText: "Currency pair", leftText: "Select currency pair...", rightText: ""),
            CreateAlertItem(fieldType: .ActiveInput, headerText: "Upper bound", leftText: "0 USD"),
            CreateAlertItem(fieldType: .ActiveInput, headerText: "Bottom bound", leftText: "0 USD"),
            // CreateAlertItem(fieldType: .Sound, headerText: "Sound", leftText: "Melody1"),
            CreateAlertItem(fieldType: .NotificationType, headerText: "Notification settings", leftText: "Is persistent alert"),
            CreateAlertItem(fieldType: .Note, headerText: "Note", leftText: "Write remember note..."),
            CreateAlertItem(fieldType: .Button)
        ]
    }
    
    private func handleTouchSelectCurrencyPair() {
        output.showSearchViewController(searchType: .Currencies)
    }
    
    private func handleTouchSelectSound() {
        output.showSearchViewController(searchType: .Sounds)
    }
    
    private func isAllRequiredFieldsFilled() -> Bool {
        var statesContainer: [Bool] = []
        for sectionIndex in 0 ..< 3 {
            guard let cell = self.tableCells[IndexPath(row: 0, section: sectionIndex)] else {
                return false
            }
            statesContainer.append(cell.getTextData().isEmpty)
        }

        return !statesContainer[0] && (!statesContainer[1] || !statesContainer[2])
    }
    
    private func handleTouchAddAlertBtn() {
        if !isAllRequiredFieldsFilled() {
            print("WARNING: required fields don't filled")
            return
        }
        //
        // show loading view while exec callback
        //
        
        // collect data for create alert
        var currencyPairName = ""
        var currencyPairPriceAtCreateMoment = 0.0
        var topBoundary = 0.0
        var bottomBoundary = 0.0
        var isPersistentNotification = false
        var noteText = ""
        
        for (indexPath, cell) in self.tableCells {
            switch indexPath.section + 1 {
            case 1:
                currencyPairName = cell.getTextData()
                currencyPairPriceAtCreateMoment = cell.getDoubleValue()
            case 2:
                topBoundary = cell.getDoubleValue()
            case 3:
                bottomBoundary = cell.getDoubleValue()
            case 4:
                isPersistentNotification = cell.getBoolValue()
            case 5:
                noteText = cell.getTextData()
                break
            default:
                break
            }
        }
        
        let alertModel = AlertItem(
            id: "", currencyPairName: currencyPairName, currencyPairPriceAtCreateMoment: currencyPairPriceAtCreateMoment,
            note: noteText, topBoundary: topBoundary, bottomBoundary: bottomBoundary,
            status: .Active, isPersistentNotification: isPersistentNotification
        )
        output.handleTouchAddAlertBtn(alertModel: alertModel)
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        self.currencyRow?.updateData(leftText: name, rightText: String(price))
    }
    
    func updateSoundElement(soundName: String) {
        self.soundRow?.updateData(leftText: soundName, rightText: nil)
    }
}

//
// @MARK: DataSource
//
extension CreateAlertDisplayManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataProvider.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableCells[indexPath] != nil {
            return self.tableCells[indexPath]!
        }
        
        let fieldType = self.dataProvider[indexPath.section].fieldType
        switch fieldType {
        case .ActiveInput:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AddAlertTableViewCell.rawValue) as! AddAlertTableViewCell
            cell.setContentData(data: self.dataProvider[indexPath.section])
            cell.selectionStyle = .none
            self.tableCells[indexPath] = cell
            return cell
        case .CurrencyPair, .Sound:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellWithArrow.rawValue) as! AlertTableViewCellWithArrow
            cell.setContentData(data: self.dataProvider[indexPath.section])
            if fieldType == .CurrencyPair {
                self.currencyRow = cell
            } else {
                self.soundRow = cell
            }
            self.tableCells[indexPath] = cell
            return cell
        case .NotificationType:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.SwitcherTableViewCell.rawValue) as! SwitcherTableViewCell
            cell.setContentData(data: self.dataProvider[indexPath.section])
            self.tableCells[indexPath] = cell
            return cell
        case .Note:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AddAlertTableViewCell.rawValue)  as! AddAlertTableViewCell
            cell.setContentData(data: self.dataProvider[indexPath.section])
            cell.selectionStyle = .none
            cell.inputField.keyboardType = .default
            self.tableCells[indexPath] = cell
            return cell
        case .Button:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellButton.rawValue) as! AlertTableViewCellButton
            cell.selectionStyle = .none
            cell.setCallbackOnTouch(callback: {
                self.handleTouchAddAlertBtn()
            })
            self.tableCells[indexPath] = cell
            return cell
        default:
            // do nothing
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.bounds)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if dataProvider[section].fieldType == .Button {
            let view = UIView(frame: tableView.frame)
            view.backgroundColor = UIColor.clear
            return view
        } else {
            let footerView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.size.width, height: 2))
            footerView.backgroundColor = UIColor.clear
            
            let separatorLineWidth = footerView.frame.size.width - 40
            
            let separatorLine = UIView(frame: CGRect(x: 20, y: 0, width: separatorLineWidth, height: 1.0))
            separatorLine.backgroundColor = UIColor(red: 53/255.0, green: 51/255.0, blue: 67/255.0, alpha: 1.0)
            footerView.addSubview(separatorLine)
            separatorLine.bottomAnchor.constraint(equalTo: footerView.layoutMarginsGuide.bottomAnchor)
            return footerView
        }
    }
}

//
// @MARK: Delegate
//
extension CreateAlertDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dataProvider[indexPath.section].fieldType == .Button ? 45 : 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataProvider[section].fieldType == .Button ? 30 : 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.dataProvider[section].fieldType == .Button ? 30 : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case FieldType.CurrencyPair.rawValue:
                self.handleTouchSelectCurrencyPair()
                break
            case FieldType.AlertSound.rawValue:
                self.handleTouchSelectSound()
                break
            default:
                // do nothing
                break
        }
    }
}
