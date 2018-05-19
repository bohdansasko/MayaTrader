//
//  AlertTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AddAlertTableViewCell: AlertTableViewCellWithTextData {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    func setContentData(data: CreateAlertItem) {
        self.headerLabel.text = data.getHeaderText()
        self.inputField.placeholder = data.getLeftText()
        self.inputField.placeholderColor = UIColor.white.withAlphaComponent(0.3)
    }
    
    override func getTextData() -> String {
        return self.inputField.text!
    }
}
