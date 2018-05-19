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
    
    func setContentData(data: CreateAlertItem) {
        self.headerLabel.text = data.getHeaderText()
        self.leftLabel.text = data.getLeftText()
    }
    
    override func getTextData() -> String {
        return self.leftLabel.text!
    }
}
