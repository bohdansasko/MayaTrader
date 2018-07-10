//
//  SwitcherTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class SwitcherTableViewCell: AlertTableViewCellWithTextData {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setContentData(data: CreateAlertItem) {
        self.headerLabel.text = data.getHeaderText()
        self.leftLabel.text = data.getLeftText()
    }
    
    override func getBoolValue() -> Bool {
        return self.uiSwitch.isOn
    }
}
