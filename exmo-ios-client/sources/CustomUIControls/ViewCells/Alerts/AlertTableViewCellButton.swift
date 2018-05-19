//
//  AlertTableViewCellButton.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertTableViewCellButton: AlertTableViewCellWithTextData {
    private var callbackOnTouch: VoidClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCallbackOnTouch(callback: VoidClosure?) {
        self.callbackOnTouch = callback
    }
    
    @IBAction func handleButtonTouch(_ sender: Any) {
        self.callbackOnTouch?()
    }
}
