//
//  CreateOrderDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class CreateOrderDisplayManager: NSObject {
    var tableView: UITableView!
    var output: CreateOrderViewOutput!
    var cell: CreateOrderTableViewCell? = nil
    
    private var dataProvider: [CreateAlertItem] = []
    private var currencyRow: AlertTableViewCellWithArrow? = nil
    private var tableCells: [IndexPath : AlertTableViewCellWithTextData] = [:]

    override init() {
        super.init()
        self.dataProvider = getFieldsForRender()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self

        registerTableCells()

        self.reloadData()
    }

    private func registerTableCells() {
        let classes = [
            CellName.AddAlertTableViewCell.rawValue,
            CellName.AlertTableViewCellWithArrow.rawValue,
            CellName.AlertTableViewCellButton.rawValue,
            CellName.OrderByTableViewCell.rawValue
        ]

        for className in classes {
            self.tableView.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
        }
    }

    func reloadData() {
        self.tableView.reloadData()
    }
    
    func createOrderPressed() {
        if self.cell != nil {
            guard let model = self.cell?.getOrderModel() else { return }
            self.output.createOrder(orderModel: model)
        }
    }
    
    private func getFieldsForRender() -> [CreateAlertItem] {
        return [
            CreateAlertItem(fieldType: .CurrencyPair, headerText: "Currency pair", leftText: "Select currency pair...", rightText: ""),
            CreateAlertItem(fieldType: .ActiveInput, headerText: "Amount", leftText: "USD"),
            CreateAlertItem(fieldType: .ActiveInput, headerText: "Total", leftText: "0 USD"),
            CreateAlertItem(fieldType: .InactiveInput, headerText: "Commision", leftText: "0 USD"),
            CreateAlertItem(fieldType: .OrderBy),
            CreateAlertItem(fieldType: .Button)
        ]
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        self.currencyRow?.updateData(leftText: name, rightText: String(price))
    }

    private func isAllRequiredFieldsFilled() -> Bool {
        for sectionIndex in 0 ..< 2 {
            guard let cell = self.tableCells[IndexPath(row: 0, section: sectionIndex)] else {
                return false
            }
            if cell.getTextData().isEmpty {
                return false
            }
        }
        return true
    }
}


extension CreateOrderDisplayManager: UITableViewDataSource  {
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

        switch self.dataProvider[indexPath.section].fieldType {
        case .ActiveInput,
             .InactiveInput:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AddAlertTableViewCell.rawValue)  as! AddAlertTableViewCell
            cell.setContentData(data: self.dataProvider[indexPath.section])
            cell.selectionStyle = .none
            cell.inputField.isEnabled = self.dataProvider[indexPath.section].fieldType == .ActiveInput
            self.tableCells[indexPath] = cell
            return cell
        case .CurrencyPair:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellWithArrow.rawValue) as! AlertTableViewCellWithArrow
            cell.setContentData(data: self.dataProvider[indexPath.section])
            self.currencyRow = cell
            self.tableCells[indexPath] = cell
            return cell
        case .OrderBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.OrderByTableViewCell.rawValue) as! OrderByTableViewCell
            self.tableCells[indexPath] = cell
            return cell
        case .Button:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellButton.rawValue) as! AlertTableViewCellButton
            cell.selectionStyle = .none
            cell.setCallbackOnTouch(callback: {
                print("create order")
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
}

extension CreateOrderDisplayManager: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.size.width, height: 2))
        footerView.backgroundColor = UIColor.clear
        
        let fieldType = self.dataProvider[section].fieldType
        let shouldAddSeparator = fieldType != .OrderBy && fieldType != .Button
        if shouldAddSeparator {
            let separatorLineWidth = footerView.frame.size.width - 40

            let separatorLine = UIView(frame: CGRect(x: 20, y: 0, width: separatorLineWidth, height: 1.0))
            separatorLine.backgroundColor = UIColor(red: 53/255.0, green: 51/255.0, blue: 67/255.0, alpha: 1.0)
            footerView.addSubview(separatorLine)
            separatorLine.bottomAnchor.constraint(equalTo: footerView.layoutMarginsGuide.bottomAnchor)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataProvider[indexPath.section].fieldType {
        case .Button: return 45
        case .OrderBy: return 126
        default: return 70
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataProvider[section].fieldType == .Button ? 30 : 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.dataProvider[section].fieldType == .Button ? 30 : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == FieldType.CurrencyPair.rawValue {
            self.output.openCurrencySearchView(data: Session.sharedInstance.getSearchCurrenciesContainer())
        }
    }
}
