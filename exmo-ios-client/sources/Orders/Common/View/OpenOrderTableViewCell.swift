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
        self.operationValueLabel.text = orderData.getOperation()
    }
}

