//
//  CreateOrderDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum CreateOrderViewType {
    case Limit
    case Instant
}

fileprivate enum OrderCreateType: String {
    case Buy = "buy"
    case Sell = "sell"
    case MarketBuy = "market_buy"
    case MarketSell = "market_sell"
    case MarketBuyTotal = "market_buy_total"
    case MarketSellTotal = "market_sell_total"
}

class CreateOrderDisplayManager: NSObject {
    enum UIFieldType: Int {
        case CurrencyPair
        case Amount
        case ForAmount
        case Price
        case Total
        case TotalWillBe
        case Commision
        case OrderBy
        case AvailableBalance
        case ButtonCreate
    }
    
    fileprivate struct UIItem {
        var type: UIFieldType
        var item: UIFieldModel?
        
        init(type: UIFieldType, item: UIFieldModel?) {
            self.type = type
            self.item = item
        }
    }
    
    var tableView: UITableView!
    var output: CreateOrderViewOutput!
    fileprivate var viewOrderType: CreateOrderViewType = .Limit
    
    private var dataProvider: [UIItem] = []
    private var tableCells: [IndexPath : AlertTableViewCellWithTextData] = [:]

    override init() {
        super.init()
        self.dataProvider = getFieldsForRender()
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    func getCellByType(inParamType: UIFieldType) -> AlertTableViewCellWithTextData? {
        guard let index = self.dataProvider.index(where: { $0.type == inParamType }) else {
            print("getCellByType: cell with param type \(inParamType.rawValue) doesn't exists")
            return nil
        }
        
        guard let cell = self.tableCells[IndexPath(row: 0, section: index)] else {
            print("getCellByType: cell with section index \(index) doesn't exists")
            return nil
        }
        
        return cell
    }
}

//
// @MARK:
//
extension CreateOrderDisplayManager {
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        registerTableCells()
        
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func getOrderModel() -> OrderModel {
        return OrderModel(id: 1, orderType: .Buy, currencyPair: "", createdDate: Date(), price: 0.0, quantity: 0.0, amount: 0.0)
    }
    
    func createOrderPressed() {
        self.output.createOrder(orderModel: self.getOrderModel())
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        guard let index = self.dataProvider.index(where: { $0.type == .CurrencyPair }) else {
            print("updateSelectedCurrency: index doesn't exists")
            return
        }

        guard let currencyCell = self.tableCells[IndexPath(row: 0, section: index)] as? AlertTableViewCellWithArrow else {
            print("updateSelectedCurrency: cell doesn't exists")
            return
        }

        currencyCell.updateData(leftText: name, rightText: Utils.getFormatedPrice(value: price))
    }
    
    fileprivate func registerTableCells() {
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
    
    fileprivate func isAllRequiredFieldsFilled() -> Bool {
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
    
    fileprivate func updateViewLayout(viewType: CreateOrderViewType) {
        if viewType != self.viewOrderType {
            self.viewOrderType = viewType
            self.dataProvider = getFieldsForRender()
            self.tableCells = [:]
            self.reloadData()
        }
    }
    
    fileprivate func isFieldTouchEnabled(cellType: UIFieldType) -> Bool {
        switch cellType {
        case .Amount,
             .ForAmount,
             .Price:
            return true
        default:
            return false
        }
    }
    
    fileprivate func getFieldsForRender() -> [UIItem] {
        switch self.viewOrderType {
        case .Limit:
            return [
                UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
                UIItem(type: .Amount, item: UIFieldModel(headerText: "Amount", leftText: "BTC")),
                UIItem(type: .Price, item: UIFieldModel(headerText: "Price", leftText: "0 USD")),
                UIItem(type: .Total, item: UIFieldModel(headerText: "Total", leftText: "0 USD")),
                UIItem(type: .Commision, item: UIFieldModel(headerText: "Commision", leftText: "0 BTC")),
//                UIItem(type: .AvailableBalance, item: UIFieldModel(headerText: "Available balance", leftText: "0 USD")),
                UIItem(type: .OrderBy, item: nil),
                UIItem(type: .ButtonCreate, item: nil)
            ]
        case .Instant:
            return [
                UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
                
                UIItem(type: .Amount, item: UIFieldModel(headerText: "Amount", leftText: "USD")),
                UIItem(type: .Total, item: UIFieldModel(headerText: "Total", leftText: "0 BTC")),
                UIItem(type: .OrderBy, item: nil),
                UIItem(type: .ButtonCreate, item: nil)
                
                //                UIItem(type: .ForAmount, item: UIFieldModel(headerText: "For the amount of", leftText: "USD")),
                //                UIItem(type: .TotalWillBe, item: UIFieldModel(headerText: "The amount will be", leftText: "0 USD")),

            ]
        }
    }
    
    fileprivate func updateFields(number: Double) {
        if self.viewOrderType != .Limit {
            return
        }
        guard let cellAmount = self.getCellByType(inParamType: .Amount) else {
            return
        }
        guard let cellPrice = self.getCellByType(inParamType: .Price) else {
            return
        }
        
        let amount = cellAmount.getDoubleValue()
        let price = cellPrice.getDoubleValue()
        let exmoCommisionInPercentage = 2.0
        
        let totalValue = amount * price
        let comissionValue = (exmoCommisionInPercentage * totalValue)/100.0

        guard let cellTotal = self.getCellByType(inParamType: .Total) as? AddAlertTableViewCell else {
            return
        }
        guard let cellCommision = self.getCellByType(inParamType: .Commision) as? AddAlertTableViewCell else {
            return
        }
        cellTotal.setData(data: Utils.getFormatedPrice(value: totalValue))
        cellCommision.setData(data: Utils.getFormatedPrice(value: comissionValue))
    }
}

//
// @MARK: datasource
//
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

        let cellType = self.dataProvider[indexPath.section].type
        switch cellType {
        case .Amount,
             .ForAmount,
             .Total,
             .TotalWillBe,
             .Price,
             .AvailableBalance,
             .Commision:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AddAlertTableViewCell.rawValue)  as! AddAlertTableViewCell
            if let data = self.dataProvider[indexPath.section].item {
                cell.data = data
            }
            cell.selectionStyle = .none
            cell.inputField.isEnabled = isFieldTouchEnabled(cellType: cellType)
            if cell.inputField.isEnabled {
                cell.setOnTextFieldTextDidChanged(onTextFieldTextDidChanged: { text in
                    guard let numb = Double(text) else {
                        return
                    }
                    self.updateFields(number: numb)
                    print("user input: \(text)")
                })
            }
            self.tableCells[indexPath] = cell
            return cell
        case .CurrencyPair:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellWithArrow.rawValue) as! AlertTableViewCellWithArrow
            if let data = self.dataProvider[indexPath.section].item {
                cell.setContentData(data: data)
            }
            self.tableCells[indexPath] = cell
            return cell
        case .OrderBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.OrderByTableViewCell.rawValue) as! OrderByTableViewCell
            self.tableCells[indexPath] = cell
            cell.setCallbackOnTouchLimitButton(callback: {
                self.updateViewLayout(viewType: .Limit)
            })
            cell.setCallbackOnTouchInstantButton(callback: {
                self.updateViewLayout(viewType: .Instant)
            })
            return cell
        case .ButtonCreate:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellButton.rawValue) as! AlertTableViewCellButton
            cell.selectionStyle = .none
            cell.setCallbackOnTouch(callback: {
                print("create order")
            })
            self.tableCells[indexPath] = cell
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.bounds)
        view.backgroundColor = UIColor.clear
        return view
    }
}

//
// @MARK: delegate
//
extension CreateOrderDisplayManager: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.size.width, height: 2))
        footerView.backgroundColor = UIColor.clear
        
        let fieldType = self.dataProvider[section].type
        let shouldAddSeparator = fieldType != .OrderBy && fieldType != .ButtonCreate
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
        switch self.dataProvider[indexPath.section].type {
        case .ButtonCreate: return 45
        case .OrderBy: return 126
        default: return 70
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataProvider[section].type == .ButtonCreate ? 30 : 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.dataProvider[section].type == .ButtonCreate ? 30 : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == UIFieldType.CurrencyPair.rawValue {
            self.output.openCurrencySearchView(data: AppDelegate.session.getSearchCurrenciesContainer())
        }
    }
}
