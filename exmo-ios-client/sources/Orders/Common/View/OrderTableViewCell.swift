//
//  OrderTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyPairLabel: UILabel!
    @IBOutlet weak var orderCreateDateLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var quantityValueLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var operationValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func setContent(orderData: OrderModel) {
        self.currencyPairLabel.text = orderData.getCurrencyPair()
        self.orderCreateDateLabel.text = orderData.getDateCreatedAsStr()
        self.priceValueLabel.text = orderData.getPrice()
        self.quantityValueLabel.text = orderData.getQuantity()
        self.amountValueLabel.text = orderData.getAmount()
        self.operationValueLabel.text = orderData.getOrderTypeAsStr()
        self.operationValueLabel.textColor = getOrderTypeLabelTextColor(orderType: orderData.getOrderType())
    }
    
    private func getOrderTypeLabelTextColor(orderType: OrderType) -> UIColor {
        switch orderType {
        case .Buy:
            return UIColor(red: 66/255, green: 126/255, blue: 243/255, alpha: 1.0)
        case .Sell:
            return UIColor(red: 235/255, green: 65/255, blue: 77/255, alpha: 1.0)
        default:
            return UIColor.black
        }
    }
}

