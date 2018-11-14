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
    
    var lefTextSwitchContainer: [String] = [] {
        didSet {
            self.updateLeftText()
        }
    }
    
    var shouldUpdateLeftTextOnChangeState = false {
        didSet {
            self.updateLeftText()
        }
    }
    
    var data: ModelOrderViewCell? = nil {
        didSet {
            if let d = self.data {
                setContentData(data: d)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.uiSwitch.tintColor = UIColor.dark1
        self.uiSwitch.onTintColor = UIColor.dodgerBlue
        self.uiSwitch.addTarget(self, action: #selector(uiSwitchValueChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
 
    private func setContentData(data: ModelOrderViewCell) {
        self.headerLabel.text = data.getHeaderText()
        self.leftLabel.text = data.getPlaceholderText()
    }
    
    override func getBoolValue() -> Bool {
        return self.uiSwitch.isOn
    }
    
    func updateLeftText() {
        if !self.shouldUpdateLeftTextOnChangeState {
            return
        }
        
        var index = 0
        switch self.uiSwitch.isOn {
        case true:
            index = 0
        case false:
            index = 1
        }
        
        self.leftLabel.text = self.lefTextSwitchContainer[index]
    }
    
    @objc private func uiSwitchValueChanged(_ sender : Any) {
        self.updateLeftText()
    }
}
