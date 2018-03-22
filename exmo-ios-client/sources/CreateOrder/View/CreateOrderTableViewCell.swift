//
//  CreateOrderTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

enum OrderBy {
    case Market
    case CurrencyExchange
}

class CreateOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyPairTextField: UITextField!
    @IBOutlet weak var totalMoneyTextField: UITextField!
    @IBOutlet weak var currencyPriceTextField: UITextField!
    @IBOutlet weak var commissionTextField: UITextField!
    @IBOutlet weak var availableBalanceTextField: UITextField!
    @IBOutlet weak var orderBySwitch: UISwitch!
    @IBOutlet weak var orderByLabel: UILabel!
    @IBOutlet weak var orderTypeSwitch: UISwitch!
    @IBOutlet weak var orderTypeLabel: UILabel!
    
    var onCreateOrderCallback: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(orderData: OrderModel) {
//        self.currencyPairTextField.text = orderData.getCurrencyPair()
//        self.totalMoneyTextField.text = "0"
//        self.currencyPriceTextField.text = orderData.getPrice()
//        self.commissionTextField.text = "0.001"
//        self.availableBalanceTextField.text = "1000 $"
        
//        configureOrderByObject()
//        configureOrderTypeObject(orderType: orderData.getOrderType())
    }
    
    private func configureOrderByObject() {
        self.orderBySwitch.isOn = true
        self.orderByLabel.text = "Market"
//        switch orderType {
//        case .Market:
//
//        case .CurrencyExchange:
//            self.orderBySwitch.isOn = false
//            self.orderByLabel.text = "CurrencyExchange"
//        default:
//            break
//        }
    }
    
    private func configureOrderTypeObject(orderType: OrderType) {
        switch orderType {
        case .Buy:
            self.orderBySwitch.isOn = true
            self.orderTypeLabel.text = "Buy"
        case .Sell:
            self.orderBySwitch.isOn = false
            self.orderTypeLabel.text = "Sell"
        default:
            break
        }
    }
    
    @IBAction func createOrderPressed(_ sender: Any) {
        onCreateOrderCallback()
    }
    
    func getOrderModel() -> OrderModel {
        return OrderModel(orderType: .Buy, currencyPair: "", createdDate: Date(), price: 0.0, quantity: 0.0, amount: 0.0)
    }
    
    func setOnCreateOrderCallback(closure: @escaping () -> Void) {
        onCreateOrderCallback = closure
    }
}
