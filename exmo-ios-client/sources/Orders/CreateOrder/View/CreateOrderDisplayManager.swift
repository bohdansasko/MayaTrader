//
//  CreateOrderDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum UIFieldType: Int {
    case CurrencyPair
    case Amount
    case ForAmount
    case Price
    case Total
    case TotalWillBe
    case Commision
    case OrderBy
    case AvailableBalance
    case TwoButtonsSellAndBuy
}

fileprivate struct UIItem {
    var type: UIFieldType
    var item: UIFieldModel?
    
    init(type: UIFieldType, item: UIFieldModel?) {
        self.type = type
        self.item = item
    }
}

fileprivate enum ViewOrderType {
    case Limit
    case Instant
}

class CreateOrderDisplayManager: NSObject {
    var tableView: UITableView!
    var output: CreateOrderViewOutput!
    var cell: CreateOrderTableViewCell? = nil
    fileprivate var viewOrderType: ViewOrderType = .Limit
    
    private var dataProvider: [UIItem] = []
    private var currencyRow: AlertTableViewCellWithArrow? = nil
    private var tableCells: [IndexPath : AlertTableViewCellWithTextData] = [:]

    override init() {
        super.init()
        self.dataProvider = getFieldsForRender()
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
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
            CellName.TableViewCellWithTwoButtons.rawValue,
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
    
    private func getFieldsForRender() -> [UIItem] {
        switch self.viewOrderType {
        case .Limit:
            return [
                UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
                UIItem(type: .Amount, item: UIFieldModel(headerText: "Amount", leftText: "BTC")),
                UIItem(type: .Price, item: UIFieldModel(headerText: "Price", leftText: "0 USD")),
                UIItem(type: .Total, item: UIFieldModel(headerText: "Total", leftText: "0 USD")),
                UIItem(type: .Commision, item: UIFieldModel(headerText: "Commision", leftText: "0 BTC")),
                UIItem(type: .AvailableBalance, item: UIFieldModel(headerText: "Available balance", leftText: "0 USD")),
                UIItem(type: .OrderBy, item: nil),
                UIItem(type: .TwoButtonsSellAndBuy, item: nil)
            ]
        case .Instant:
            return [
                UIItem(type: .CurrencyPair, item: UIFieldModel(headerText: "Currency pair", leftText: "Select currency pair...", rightText: "")),
                
                UIItem(type: .Amount, item: UIFieldModel(headerText: "Amount", leftText: "USD")),
                UIItem(type: .Total, item: UIFieldModel(headerText: "Total", leftText: "0 BTC")),
                
//                UIItem(type: .ForAmount, item: UIFieldModel(headerText: "For the amount of", leftText: "USD")),
//                UIItem(type: .TotalWillBe, item: UIFieldModel(headerText: "The amount will be", leftText: "0 USD")),
                
                UIItem(type: .OrderBy, item: nil),
                UIItem(type: .TwoButtonsSellAndBuy, item: nil)
            ]
        }
        
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
    
    private func updateViewLayout(viewType: ViewOrderType) {
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
                cell.setContentData(data: data)
            }
            cell.selectionStyle = .none
            cell.inputField.isEnabled = isFieldTouchEnabled(cellType: cellType)
            self.tableCells[indexPath] = cell
            return cell
        case .CurrencyPair:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.AlertTableViewCellWithArrow.rawValue) as! AlertTableViewCellWithArrow
            if let data = self.dataProvider[indexPath.section].item {
                cell.setContentData(data: data)
            }
            self.currencyRow = cell
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
        case .TwoButtonsSellAndBuy:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.TableViewCellWithTwoButtons.rawValue) as! TableViewCellWithTwoButtons
            cell.selectionStyle = .none
            cell.setCallbackOnTouchLeftButton(callback: {
                print("touch left button")
            })
            cell.setCallbackOnTouchRightButton(callback: {
                print("touch right button")
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
        
        let fieldType = self.dataProvider[section].type
        let shouldAddSeparator = fieldType != .OrderBy && fieldType != .TwoButtonsSellAndBuy
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
        case .TwoButtonsSellAndBuy: return 45
        case .OrderBy: return 126
        default: return 70
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataProvider[section].type == .TwoButtonsSellAndBuy ? 30 : 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.dataProvider[section].type == .TwoButtonsSellAndBuy ? 30 : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == UIFieldType.CurrencyPair.rawValue {
            self.output.openCurrencySearchView(data: AppDelegate.session.getSearchCurrenciesContainer())
        }
    }
}
