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
    
    override init() {
        super.init()
        self.dataProvider = getFieldsForRender()
        subscribeOnKeyboardNotifications()
    }
    
    func subscribeOnKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleEventKeyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleEventKeyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.reloadData()
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
            CreateAlertItem(fieldType: .Disclosure, headerText: "Amount", leftText: "BTC/USD", rightText: "12800.876"),
            CreateAlertItem(fieldType: .ActiveInput, headerText: "Price", leftText: "0 USD"),
            CreateAlertItem(fieldType: .ActiveInput, headerText: "Total", leftText: "0 USD"),
            CreateAlertItem(fieldType: .InactiveInput, headerText: "Commision", leftText: "0 USD"),
            CreateAlertItem(fieldType: .OrderBy),
            CreateAlertItem(fieldType: .Button)
        ]
    }
    
    @objc func handleEventKeyboardWillShow(notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            self.tableView.contentOffset.y = keyboardSize.height
        }
    }
    
    @objc func handleEventKeyboardWillHide(notification: Notification) {
        self.tableView.contentOffset.y = 0
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
        switch self.dataProvider[indexPath.section].fieldType {
        case .ActiveInput,
             .InactiveInput:
            let cell = Bundle.main.loadNibNamed(CellName.AddAlertTableViewCell.rawValue, owner: self, options: nil)?.first  as! AddAlertTableViewCell
            cell.setContentData(data: self.dataProvider[indexPath.section])
            cell.selectionStyle = .none
            return cell
        case .Disclosure:
            let cell = Bundle.main.loadNibNamed(CellName.AlertTableViewCellWithArrow.rawValue, owner: self, options: nil)?.first as! AlertTableViewCellWithArrow
            cell.setContentData(data: self.dataProvider[indexPath.section])
            return cell
        case .OrderBy:
            let cell = Bundle.main.loadNibNamed(CellName.OrderByTableViewCell.rawValue, owner: self, options: nil)?.first as! OrderByTableViewCell
            return cell
        case .Button:
            let cell = Bundle.main.loadNibNamed(CellName.AlertTableViewCellButton.rawValue, owner: self, options: nil)?.first as! AlertTableViewCellButton
            cell.selectionStyle = .none
            cell.setCallbackOnTouch(callback: {
                // self.handleTouchAddAlertBtn()
            })
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
        
        if section < 4 {
            let separatorLineWidth = footerView.frame.size.width - 40

            let separatorLine = UIView(frame: CGRect(x: 20, y: 0, width: separatorLineWidth, height: 1.0))
            separatorLine.backgroundColor = UIColor(red: 53/255.0, green: 51/255.0, blue: 67/255.0, alpha: 1.0)
            footerView.addSubview(separatorLine)
            separatorLine.bottomAnchor.constraint(equalTo: footerView.layoutMarginsGuide.bottomAnchor)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataProvider[indexPath.section].fieldType {
        case .Button: return 45
        case .OrderBy: return 126
        default: return 70
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataProvider[section].fieldType == .Button ? 30 : 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataProvider[section].fieldType == .Button ? 30 : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case FieldType.CurrencyPair.rawValue:
//            handleTouchSelectCurrencyPair()
//            break
//        case FieldType.AlertSound.rawValue:
//            handleTouchSelectSound()
//            break
//        default:
//            // do nothing
//            break
//        }
    }
}
