//
//  AlertTableViewCellWithArrow.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertTableViewCellWithArrow: AlertTableViewCellWithTextData {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    func setContentData(data: CreateAlertItem) {
        self.headerLabel.text = data.getHeaderText()
        self.leftLabel.text = data.getLeftText()
        self.rightLabel.text = data.getRightText()
    }
    
    override func getTextData() -> String {
        return self.leftLabel.text!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func updateData(name: String, price: Double) {
        self.leftLabel.text = name
        self.rightLabel.text = String(price)
    }
}
