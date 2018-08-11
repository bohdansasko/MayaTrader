//
//  CreateAlertDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum AlertOperationType {
    case Add
    case Update
    case None
}

//
// @MARK: UIFieldModel
//
fileprivate enum UIFieldType: Int {
    case CurrencyPair
    case UpperBound
    case BottomBound
    case Sound
    case Notification
    case Note
    case ButtonCreateUpdate
}

fileprivate struct UIItem {
    var type: UIFieldType
    var item: UIFieldModel?
    
    init(type: UIFieldType, item: UIFieldModel?) {
        self.type = type
        self.item = item
    }
}

class UIFieldModel {
    var textContainer: [String:String]
    
    convenience init(headerText: String = "") {
        self.init(headerText: headerText, leftText: "")
    }
    
    init(headerText: String, leftText: String, rightText: String = "") {
        self.textContainer = [String:String]()
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

enum CellName: String {
    case AddAlertTableViewCell
    case AlertTableViewCellWithArrow
    case AlertTableViewCellButton
    case OrderByTableViewCell
    case SwitcherTableViewCell
    case TableViewCellWithTwoButtons
}

//
// @MARK: CreateAlertDisplayManager
//
class CreateAlertDisplayManager: NSObject {
    private var dataProvider: [UIItem] = []
    private var tableView: UITableView!
    private var currencyRow: AlertTableViewCellWithArrow? = nil
    private var soundRow: AlertTableViewCellWithArrow? = nil
    private var tableCells: [IndexPath : AlertTableViewCellWithTextData] = [:]
    private var alertItem: AlertItem? = nil
    
    var output: CreateAlertViewOutput!
    
    override init() {
        super.init()
    }
    
    func setTableView(tableView: UITableView!) {
        self.dataProvider = getFieldsForRender()
        
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
    
    private func getFieldsForRender() -> [UIItem] {
        return [
            UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
            UIItem(type: .UpperBound,  item: UIFieldModel(headerText: "Upper bound", leftText: "0 USD")),
            UIItem(type: .BottomBound,  item: UIFieldModel(headerText: "Bottom bound", leftText: "0 USD")),
            // UIFieldModel(fieldType: .Sound, headerText: "Sound", leftText: "Melody1"),
            UIItem(type: .Notification,  item: UIFieldModel(headerText: "Notification settings", leftText: "Is persistent alert")),
            UIItem(type: .Note,  item: UIFieldModel(headerText: "Note", leftText: "Write remember note...")),
            UIItem(type: .ButtonCreateUpdate,  item: UIFieldModel(headerText: self.alertItem == nil ? "Add" : "Update"))
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

        return statesContainer.count > 2
            ? !statesContainer[0] && (!statesContainer[1] || !statesContainer[2])
            : false
    }
    
    private func getAlertDataFromUI() -> AlertItem? {
        //
        // collect data for create alert
        //
        let id = self.alertItem == nil ? "" : self.alertItem!.id
        let status = self.alertItem == nil ? AlertStatus.Inactive : self.alertItem!.status
        var currencyPairName = ""
        var priceAtCreateMoment = 0.0
        var topBoundary = 0.0
        var bottomBoundary = 0.0
        var isPersistentNotification = false
        var noteText = ""
        
        for (indexPath, cell) in self.tableCells {
            switch indexPath.section + 1 {
            case 1:
                currencyPairName = cell.getTextData()
                priceAtCreateMoment = cell.getDoubleValue()
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
        currencyPairName = currencyPairName.replacingOccurrences(of: "/", with: "_")
        
        return AlertItem(
            id: id, currencyPairName: currencyPairName, priceAtCreateMoment: priceAtCreateMoment,
            note: noteText, topBoundary: topBoundary, bottomBoundary: bottomBoundary,
            status: status, isPersistentNotification: isPersistentNotification
        )
    }
    
    private func handleTouchOnAlertBtn() {
        if !isAllRequiredFieldsFilled() {
            print("WARNING: required fields don't filled")
            return
        }
        //
        // show loading view while exec callback
        //
        
        let alertModelForServer = getAlertDataFromUI()
        var operationType = AlertOperationType.None
        
        if self.alertItem == nil {
            operationType = .Add
        } else {
            operationType = .Update
        }
        
        if let alertForSend = alertModelForServer {
            output.handleTouchAlertBtn(alertModel: alertForSend, operationType: operationType)
        }
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        self.currencyRow?.updateData(leftText: name, rightText: Utils.getFormatedPrice(value: price))
    }
    
    func updateSoundElement(soundName: String) {
        self.soundRow?.updateData(leftText: soundName, rightText: nil)
    }
    
    func setAlertItem(alertItem: AlertItem) {
        self.alertItem = alertItem
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
        
        let fieldType = self.dataProvider[indexPath.section].type
        switch fieldType {
        case .UpperBound, .BottomBound:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AddAlertTableViewCell.rawValue) as! AddAlertTableViewCell
            if let data = self.dataProvider[indexPath.section].item {
                cell.data = data
            }
            if let alert = self.alertItem {
                let price = fieldType == .UpperBound ? alert.topBoundary : alert.bottomBoundary
                if price != nil {
                    cell.setData(data: String(price!))
                }
            }
            cell.selectionStyle = .none
            self.tableCells[indexPath] = cell
            return cell
        case .CurrencyPair, .Sound:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellWithArrow.rawValue) as! AlertTableViewCellWithArrow
            if let data = self.dataProvider[indexPath.section].item {
                cell.setContentData(data: data)
            }
            if fieldType == .CurrencyPair {
                self.currencyRow = cell
                if let alert = self.alertItem {
                    updateSelectedCurrency(name: alert.getCurrencyPairForDisplay(), price: alert.priceAtCreateMoment)
                }
            } else {
                self.soundRow = cell
            }
            self.tableCells[indexPath] = cell
            return cell
        case .Notification:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.SwitcherTableViewCell.rawValue) as! SwitcherTableViewCell
            if let data = self.dataProvider[indexPath.section].item {
                cell.setContentData(data: data)
            }
            self.tableCells[indexPath] = cell
            if let alert = self.alertItem {
                cell.uiSwitch.isOn = alert.isPersistentNotification
            }
            return cell
        case .Note:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AddAlertTableViewCell.rawValue)  as! AddAlertTableViewCell
            if let data = self.dataProvider[indexPath.section].item {
                cell.data = data
            }
            cell.selectionStyle = .none
            cell.inputField.keyboardType = .default
            if let alert = self.alertItem {
                cell.setData(data: alert.note)
            }
            self.tableCells[indexPath] = cell
            return cell
        case .ButtonCreateUpdate:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellButton.rawValue) as! AlertTableViewCellButton
            cell.selectionStyle = .none
            if let data = self.dataProvider[indexPath.section].item {
                cell.setButtonTitle(text: data.getHeaderText())
            }
            cell.setCallbackOnTouch(callback: {
                self.handleTouchOnAlertBtn()
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
        if self.dataProvider[section].type == .ButtonCreateUpdate {
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
        return self.dataProvider[indexPath.section].type == .ButtonCreateUpdate ? 45 : 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataProvider[section].type == .ButtonCreateUpdate ? 30 : 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.dataProvider[section].type == .ButtonCreateUpdate ? 30 : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.dataProvider[indexPath.section].type {
            case .CurrencyPair:
                self.handleTouchSelectCurrencyPair()
                break
            case .Sound:
                self.handleTouchSelectSound()
                break
            default:
                // do nothing
                break
        }
    }
}
