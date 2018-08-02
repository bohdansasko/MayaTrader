//
//  TableViewCellWithTwoButtons.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class TableViewCellWithTwoButtons: AlertTableViewCellWithTextData {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    private var callbackTouchOnLeftButton: VoidClosure? = nil
    private var callbackTouchOnRightButton: VoidClosure? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.leftButton.addTarget(self,
                                    action: #selector(self.onTouchUpInsideButton),
                                    for: .touchUpInside)
        self.rightButton.addTarget(self,
                                  action: #selector(self.onTouchUpInsideButton),
                                  for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func onTouchUpInsideButton(_ sender: UIButton?) {
        if sender == self.leftButton {
            self.callbackTouchOnLeftButton?()
        } else {
            self.callbackTouchOnRightButton?()
        }
    }
    
    func setCallbackOnTouchLeftButton(callback: VoidClosure?) {
        self.callbackTouchOnLeftButton = callback
    }
    
    func setCallbackOnTouchRightButton(callback: VoidClosure?) {
        self.callbackTouchOnRightButton = callback
    }
}
