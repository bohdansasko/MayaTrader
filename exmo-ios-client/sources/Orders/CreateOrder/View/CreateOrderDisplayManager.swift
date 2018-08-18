//
//  CreateOrderDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

fileprivate enum CreateOrderViewType : Int {
    case None = -1
    case Limit = 0
    case Instant = 1
    case OnSum = 2
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
    
    private var dataProvider: [UIItem] = []
    private var tableCells: [IndexPath : AlertTableViewCellWithTextData] = [:]

    fileprivate var viewOrderType: CreateOrderViewType = .None
    fileprivate var orderSettings: OrderSettings?
    private var orderViewModel : DarkeningPickerViewModel!
    private var selectedOrderViewIndex : Int = 0
    
    override init() {
        super.init()
        self.dataProvider = self.getFieldsForRender()
        self.orderViewModel = self.getPickerViewLayout()
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
    
    func handleSelectedActionInOrderPickerView(actionIndex: Int) {
        print("handleSelectedActionInOrderPickerView: \(actionIndex)")
        
        var layoutViewType = self.viewOrderType
        switch actionIndex {
        case 0: layoutViewType = .Limit
        case 1: layoutViewType = .Instant
        case 2: layoutViewType = .OnSum
        default: break
        }
        
        self.selectedOrderViewIndex = actionIndex
        self.updateViewLayout(viewType: layoutViewType)
    }
    
    func getPickerViewLayout() -> DarkeningPickerViewModel {
        return DarkeningPickerViewModel(
            header: "Order by",
         dataSouce: ["Limit", "Instant", "On sum"]
        )
    }
    
    func getSelectedOrderViewIndex() -> Int {
        return self.selectedOrderViewIndex
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
        
        self.registerTableCells()
        self.handleSelectedActionInOrderPickerView(actionIndex: CreateOrderViewType.Limit.rawValue)
        
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
            self.tableCells.removeAll()
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
                UIItem(type: .OrderBy, item: UIFieldModel(headerText: orderViewModel.header, leftText: orderViewModel.dataSouce[self.selectedOrderViewIndex], rightText: "")),
                UIItem(type: .ButtonCreate, item: nil)
            ]
        case .Instant:
            return [
                UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
                UIItem(type: .Amount, item: UIFieldModel(headerText: "Amount", leftText: "USD")),
                UIItem(type: .Total, item: UIFieldModel(headerText: "Total", leftText: "0 BTC")),
                UIItem(type: .OrderBy, item: UIFieldModel(headerText: orderViewModel.header, leftText: orderViewModel.dataSouce[self.selectedOrderViewIndex], rightText: "")),
                UIItem(type: .ButtonCreate, item: nil)
                
                //                UIItem(type: .ForAmount, item: UIFieldModel(headerText: "For the amount of", leftText: "USD")),
                //                UIItem(type: .TotalWillBe, item: UIFieldModel(headerText: "The amount will be", leftText: "0 USD")),

            ]
        case .OnSum:
            return [
                UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
                UIItem(type: .ForAmount, item: UIFieldModel(headerText: "For the amount of", leftText: "USD")),
                UIItem(type: .TotalWillBe, item: UIFieldModel(headerText: "The amount will be", leftText: "0 USD")),
                UIItem(type: .OrderBy, item: UIFieldModel(headerText: orderViewModel.header, leftText: orderViewModel.dataSouce[self.selectedOrderViewIndex], rightText: "")),
                UIItem(type: .ButtonCreate, item: nil)
            ]
        default:
            return []
        }
    }
    
    fileprivate func fillFields(number: Double) {
        switch self.viewOrderType {
        case .Limit:
            guard let cellAmount = self.getCellByType(inParamType: .Amount),
                  let cellPrice = self.getCellByType(inParamType: .Price) else {
                return
            }
            
            let amount = cellAmount.getDoubleValue()
            let price = cellPrice.getDoubleValue()
            let exmoCommisionInPercentage = 2.0
            
            let totalValue = amount * price
            let comissionValue = (exmoCommisionInPercentage * totalValue)/100.0
            
            guard let cellTotal = self.getCellByType(inParamType: .Total) as? AddAlertTableViewCell,
                  let cellCommision = self.getCellByType(inParamType: .Commision) as? AddAlertTableViewCell else {
                return
            }
            
            cellTotal.setData(data: Utils.getFormatedPrice(value: totalValue))
            cellCommision.setData(data: Utils.getFormatedPrice(value: comissionValue))
        case .Instant:
            guard let cellCurrencyPair = self.getCellByType(inParamType: .CurrencyPair) as? AlertTableViewCellWithArrow,
                        let cellAmount = self.getCellByType(inParamType: .Amount) as? AddAlertTableViewCell,
                        let  cellTotal = self.getCellByType(inParamType: .Total) as? AddAlertTableViewCell else {
                return
            }
            
            let price = cellCurrencyPair.getDoubleValue()
            let amount = cellAmount.getDoubleValue()
            let totalValue = amount * price
            
            cellTotal.setData(data: Utils.getFormatedPrice(value: totalValue))
        
        case .OnSum:
            guard let cellCurrencyPair = self.getCellByType(inParamType: .CurrencyPair) as? AlertTableViewCellWithArrow,
            let cellAmount = self.getCellByType(inParamType: .Amount) as? AddAlertTableViewCell,
            let  cellTotal = self.getCellByType(inParamType: .Total) as? AddAlertTableViewCell else {
                return
            }
            
            let price = cellCurrencyPair.getDoubleValue()
            let amount = cellAmount.getDoubleValue()
            let totalValue = amount * price
            
            cellTotal.setData(data: Utils.getFormatedPrice(value: totalValue))
        default: // do nothing
            break
        }
    }
    
    private func getDataFromUI() -> OrderModel? {
        
        var currencyPairName = ""
        var amount = 0.0
        var price = 0.0
        var total = 0.0
        
        for item in self.dataProvider {
            guard let cell = getCellByType(inParamType: item.type) else {
                
                return nil
            }
            
            switch item.type {
            case .CurrencyPair:
                currencyPairName = cell.getTextData()
            case .Amount:
                amount = cell.getDoubleValue()
            case .Price:
                price = cell.getDoubleValue()
            case .Total:
                total = cell.getDoubleValue()
            default:
                break
            }
        }
        
        currencyPairName = Utils.getRawCurrencyPairName(name: currencyPairName)
        
        let isSellOrder = true // TODO: add sell/buy option in view
        var createType = OrderCreateType.None
        
        switch self.viewOrderType {
        case .Limit:
            if isSellOrder {
                createType = .Sell
            } else {
                createType = .Buy
            }
        case .Instant:
            if isSellOrder {
                createType = .MarketSell
            } else {
                createType = .MarketBuy
            }
        case .OnSum:
            if isSellOrder {
                createType = .MarketSellTotal
            } else {
                createType = .MarketBuyTotal
            }
        default: // do nothing
            break
        }
        
        return OrderModel(createType: createType, currencyPair: currencyPairName, price: price, quantity: total, amount: amount)
    }
        
    func handleTouchOnButtonCreateOrder() {
        if !self.isAllRequiredFieldsFilled() {
            print("handleTouchOnButtonCreateOrder: required fields don't filled")
            return
        }
        //
        // show loading view while exec callback
        //
        guard let orderModel = self.getDataFromUI() else {
            print("handleTouchOnButtonCreateOrder: can't parse data from UI")
            return
        }
        self.output.createOrder(orderModel: orderModel)
    }
    
    func setOrderSettings(orderSettings: OrderSettings) {
        self.orderSettings = orderSettings
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
                    if self.orderSettings != nil {
                        print("orderSettings max price: \(self.orderSettings!.maxPrice)")
                    }
                    self.fillFields(number: numb)
                    print("user input: \(text)")
                })
            }
            self.tableCells[indexPath] = cell
            return cell
        case .CurrencyPair,
             .OrderBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellWithArrow.rawValue) as! AlertTableViewCellWithArrow
            if let data = self.dataProvider[indexPath.section].item {
                cell.setContentData(data: data)
            }
            self.tableCells[indexPath] = cell
            return cell
        case .ButtonCreate:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellButton.rawValue) as! AlertTableViewCellButton
            cell.selectionStyle = .none
            cell.setCallbackOnTouch(callback: {
                self.handleTouchOnButtonCreateOrder()
            })
            self.tableCells[indexPath] = cell
            return cell
        }
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
        let shouldAddSeparator = fieldType != .ButtonCreate
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
        // case .OrderBy: return 126
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
        switch self.dataProvider[indexPath.section].type {
        case UIFieldType.CurrencyPair:
            self.output.openCurrencySearchView(data: AppDelegate.session.getSearchCurrenciesContainer())
        case UIFieldType.OrderBy:
            output.handleTouchOnOrderType()
        default: // do nothing
            break
        }
    }
}
