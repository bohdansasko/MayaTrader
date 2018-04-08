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
    @IBOutlet weak var actionButton: UIButton!
    private var id: Int = 0
    private var isFavourite = false
    
    var onSwitchValueCallback: (_ id: Int, _ isFavourite: Bool) -> Void = { _, _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func handleActionButtonPressed(sender: Any?) {
        self.isFavourite = !isFavourite
        onSwitchValueCallback(self.id, self.isFavourite)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(id: Int, currencyLabel: String?, isFavourite: Bool, onSwitchValueCallback: @escaping (_ id: Int, _ isFavourite: Bool) -> Void) {
        self.id = id
        
        let imageName = isFavourite ? "icWalletUnassign" : "icWalletAssign"
        
        self.isFavourite = isFavourite
        self.currencyLabel.text = currencyLabel
        self.actionButton.setImage(UIImage(named: imageName), for: .normal)
        self.onSwitchValueCallback = onSwitchValueCallback
    }
}
