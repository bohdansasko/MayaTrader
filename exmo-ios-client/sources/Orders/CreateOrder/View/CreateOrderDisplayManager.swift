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

enum CreateOrderDisplayType : Int {
    case Limit = 0
    case InstantOnAmount = 1
    case InstantOnSum = 2
}

class CreateOrderDisplayManager: NSObject {
    enum UIFieldType: Int {
        case CurrencyPair
        case Amount
        case Price
        case Total
        case Commision
        case OrderBy
        case AvailableBalance
        case OrderType
        case ButtonCreate
    }
    
    fileprivate struct UIItem {
        var type: UIFieldType
        var item: UIFieldModel?
        
        init(type: UIFieldType, item: UIFieldModel?) {
            self.type = type
            self.item = item
        }

//        
//        func getOnAmountLayout() -> [UIItem] {
//            return [
//                UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
//                UIItem(type: .Amount, item: UIFieldModel(headerText: "Amount", leftText: "0 USD")),
//                UIItem(type: .Total, item: UIFieldModel(headerText: "Total", leftText: "0 BTC")),
//                UIItem(type: .OrderType, item: UIFieldModel(headerText: "Order Type")),
//                UIItem(type: .OrderBy, item: UIFieldModel(headerText: orderViewModel.header, leftText: orderViewModel.dataSouce[self.selectedOrderViewIndex], rightText: "")),
//                UIItem(type: .ButtonCreate, item: nil)
//            ]
//        }
//      
    }
    
    var tableView: UITableView!
    var output: CreateOrderViewOutput!
    
    private var dataProvider: [UIItem] = []
    private var tableCells: [IndexPath : AlertTableViewCellWithTextData] = [:]

    fileprivate var viewOrderType: CreateOrderDisplayType = .Limit
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
        case 1: layoutViewType = .InstantOnAmount
        case 2: layoutViewType = .InstantOnSum
        default: break
        }
        
        self.selectedOrderViewIndex = actionIndex
        self.updateViewLayout(viewType: layoutViewType)
    }
    
    func getPickerViewLayout() -> DarkeningPickerViewModel {
        return DarkeningPickerViewModel(
                header: "Order by",
             dataSouce: ["Limit", "Instant order(On amount)", "Instant order(On sum)"]
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
        self.handleSelectedActionInOrderPickerView(actionIndex: CreateOrderDisplayType.Limit.rawValue)
        
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

        self.fillFields(number: price)
        self.updatePlaceholdersInFields(currencyPairName: name)
    }

    fileprivate func updatePlaceholdersInFields(currencyPairName: String) {
        let currencies = currencyPairName.split(separator: "/")

        for item in self.dataProvider {
            guard let cell = getCellByType(inParamType: item.type) as? AddAlertTableViewCell else {
                continue
            }
            switch item.type {
            case .Amount:
                cell.setPlaceholderText(string: currencies[0].description)
            case .Price:
                cell.setPlaceholderText(string: currencies[1].description)
            case .Total:
                cell.setPlaceholderText(string: currencies[1].description)
            case .Commision:
                cell.setPlaceholderText(string: currencies[0].description)
            default:
                break
            }
        }
    }
    
    fileprivate func registerTableCells() {
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
    
    fileprivate func updateViewLayout(viewType: CreateOrderDisplayType) {
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
             .Price:
            return true
        default:
            return false
        }
    }
    
    fileprivate func getFieldsForRender() -> [UIItem] {
        return []
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
            cellTotal.setTextInInputField(string: totalValue > 0
                    ? Utils.getFormatedPrice(value:totalValue)
                    : ""
            )
            cellCommision.setTextInInputField(string: comissionValue > 0
                    ? Utils.getFormatedPrice(value: comissionValue)
                    : ""
            )
        case .InstantOnAmount:
            guard let cellCurrencyPair = self.getCellByType(inParamType: .CurrencyPair) as? AlertTableViewCellWithArrow,
                  let cellAmount = self.getCellByType(inParamType: .Amount) as? AddAlertTableViewCell,
                  let  cellTotal = self.getCellByType(inParamType: .Total) as? AddAlertTableViewCell else {
                return
            }
            
            let price = cellCurrencyPair.getDoubleValue()
            let amount = cellAmount.getDoubleValue()
            let totalValue = amount * price

            cellTotal.setTextInInputField(string: totalValue > 0
                    ? Utils.getFormatedPrice(value: totalValue)
                    : ""
            )

        case .InstantOnSum:
            guard let cellCurrencyPair = self.getCellByType(inParamType: .CurrencyPair) as? AlertTableViewCellWithArrow,
            let cellAmount = self.getCellByType(inParamType: .Amount) as? AddAlertTableViewCell,
            let  cellTotal = self.getCellByType(inParamType: .Total) as? AddAlertTableViewCell else {
                return
            }
            
            let price = cellCurrencyPair.getDoubleValue()
            let amount = cellAmount.getDoubleValue()
            let totalValue = amount * price

            cellTotal.setTextInInputField(string: totalValue > 0
                    ? Utils.getFormatedPrice(value: totalValue)
                    : ""
            )
        default: // do nothing
            break
        }
    }
    
    private func getDataFromUI() -> OrderModel? {
        switch self.viewOrderType {
        case .Limit:
            return self.getDataFromUILimitView()
        case .InstantOnAmount:
            return self.getDataFromUIInstantOnAmountView()
        case .InstantOnSum:
            return self.getDataFromUIInstantOnSumView()
        default: // do nothing
            return nil
        }
    }

    private func getDataFromUILimitView() -> OrderModel? {
        var currencyPairName = ""
        var amount = 0.0
        var price = 0.0
        var total = 0.0
        var createType = OrderCreateType.None
        
        for item in self.dataProvider {
            guard let cell = getCellByType(inParamType: item.type) else {
                return nil
            }
            
            switch item.type {
            case .CurrencyPair:
                currencyPairName = Utils.getRawCurrencyPairName(name: cell.getTextData())
            case .Amount:
                amount = cell.getDoubleValue()
            case .Price:
                price = cell.getDoubleValue()
            case .Total:
                total = cell.getDoubleValue()
            case .OrderType:
                if cell.getBoolValue() {
                    createType = .Sell
                } else {
                    createType = .Buy
                }
            default:
                break
            }
        }
        
        return OrderModel(createType: createType, currencyPair: currencyPairName, price: price, quantity: total, amount: amount)
    }
    
    private func getDataFromUIInstantOnAmountView() -> OrderModel? {
        var createType = OrderCreateType.None
        var currencyPairName = ""
        var amount = 0.0
        var price = 0.0
        
        for item in self.dataProvider {
            guard let cell = getCellByType(inParamType: item.type) else {
                return nil
            }
            
            switch item.type {
            case .CurrencyPair:
                currencyPairName = Utils.getRawCurrencyPairName(name: cell.getTextData())
            case .Amount:
                amount = cell.getDoubleValue()
            case .Price:
                price = cell.getDoubleValue()
            case .OrderType:
                if cell.getBoolValue() {
                    createType = .MarketSell
                } else {
                    createType = .MarketBuy
                }
            default:
                break
            }
        }
        
        let total = amount * price
        
        return OrderModel(createType: createType, currencyPair: currencyPairName, price: price, quantity: total, amount: amount)
    }
    
    private func getDataFromUIInstantOnSumView() -> OrderModel? {
        var createType = OrderCreateType.None
        var currencyPairName = ""
        var amount = 1.0
        var price = 0.0
        
        for item in self.dataProvider {
            guard let cell = self.getCellByType(inParamType: item.type) else {
                return nil
            }
            
            switch item.type {
            case .CurrencyPair:
                currencyPairName = Utils.getRawCurrencyPairName(name: cell.getTextData())
            case .Amount:
                amount = cell.getDoubleValue()
            case .Price:
                price = cell.getDoubleValue()
            case .OrderType:
                if cell.getBoolValue() {
                    createType = .MarketSellTotal
                } else {
                    createType = .MarketBuyTotal
                }
            default:
                break
            }
        }
        
        let total = amount * price
        
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

// @MARK: datasource
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
        
        let data = self.dataProvider[indexPath.section].item
        
        let cellType = self.dataProvider[indexPath.section].type
        switch cellType {
        case .Amount,
             .Total,
             .Price,
             .AvailableBalance,
             .Commision:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AddAlertTableViewCell.rawValue)  as! AddAlertTableViewCell
            cell.data = data!
            cell.selectionStyle = .none
            cell.inputField.isEnabled = isFieldTouchEnabled(cellType: cellType)
            if cell.inputField.isEnabled {
                cell.setOnTextFieldTextDidChanged(onTextFieldTextDidChanged: { text in
                    if self.orderSettings != nil {
                        print("orderSettings max price: \(self.orderSettings!.maxPrice)")
                    }
                    self.fillFields(number: Double(text) ?? 0)
                    print("user input: \(text)")
                })
            }
            self.tableCells[indexPath] = cell
            return cell
        case .CurrencyPair,
             .OrderBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellWithArrow.rawValue) as! AlertTableViewCellWithArrow
            cell.setContentData(data: data!)
            self.tableCells[indexPath] = cell
            return cell
        case .OrderType:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.SwitcherTableViewCell.rawValue) as! SwitcherTableViewCell
            cell.selectionStyle = .none
            cell.data = data
            cell.lefTextSwitchContainer = ["Sell", "Buy"]
            cell.shouldUpdateLeftTextOnChangeState = true
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
