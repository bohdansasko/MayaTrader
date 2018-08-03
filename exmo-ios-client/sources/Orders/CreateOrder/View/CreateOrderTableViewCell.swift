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
    
    
    @IBAction func handleChangeValueOrderActionType(_ sender: Any) {
        let text = orderTypeSwitch.isOn ? "Buy" : "Sell"
        self.orderTypeLabel.text = text
    }

    @IBAction func handleChangeValueOrderBy(_ sender: Any) {
        let text = orderBySwitch.isOn ? "Market" : "CurrencyExchange"
        self.orderByLabel.text = text
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureOrderByObject() {
        self.orderBySwitch.isOn = true
        self.orderByLabel.text = "Market"
    }
    
    private func configureOrderActionTypeObject(orderType: OrderActionType) {
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
