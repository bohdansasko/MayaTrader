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
    
    // constraints
    @IBOutlet weak var timeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func setContent(orderData: OrderModel) {
        self.currencyPairLabel.text = orderData.getDisplayCurrencyPair()
        self.orderCreateDateLabel.text = orderData.getDateCreatedAsStr()
        self.priceValueLabel.text = orderData.getPriceAsStr()
        self.quantityValueLabel.text = orderData.getQuantityAsStr()
        self.amountValueLabel.text = orderData.getAmountAsStr()
        
        self.operationValueLabel.text = orderData.getOrderActionTypeAsStr()
        self.operationValueLabel.backgroundColor = getOrderActionTypeLabelTextColor(orderType: orderData.getOrderActionType())
        self.operationValueLabel.layer.masksToBounds = true
        self.operationValueLabel.layer.cornerRadius = 5

        // update constraints
        if AppDelegate.getIPhoneModel() == .Five {
            self.timeLabelWidthConstraint.constant = 70
            self.timeLabelHeightConstraint.constant = 40
        } else {
            self.timeLabelWidthConstraint.constant = 100
            self.timeLabelHeightConstraint.constant = 20
        }
    }
    
    private func getOrderActionTypeLabelTextColor(orderType: OrderActionType) -> UIColor {
        switch orderType {
        case .Buy:
            return UIColor(red: 74.0/255, green: 132.0/255, blue: 244.0/255, alpha: 1.0)
        case .Sell:
            return UIColor(red: 131.0/255, green: 132.0/255, blue: 150.0/255, alpha: 1.0)
        default:
            return UIColor.black
        }
    }
}

