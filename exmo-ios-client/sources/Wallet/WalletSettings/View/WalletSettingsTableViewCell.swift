//
//  WalletSettingsTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WalletSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyLabel: UILabel!
    private var id: Int = 0
    
    var onSwitchValueCallback: (_ id: Int, _ isFavourite: Bool) -> Void = { _, _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @objc func onSwitchValue(sender: UISwitch!) {
        onSwitchValueCallback(self.id, sender.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(id: Int, currencyLabel: String?, isFavouriteSwitcher: Bool, onSwitchValueCallback: @escaping (_ id: Int, _ isFavourite: Bool) -> Void) {
        self.id = id
        self.currencyLabel.text = currencyLabel
        self.onSwitchValueCallback = onSwitchValueCallback
    }

}
