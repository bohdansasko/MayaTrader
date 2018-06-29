//
//  OrderByTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 6/29/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class OrderByTableViewCell: AlertTableViewCellWithTextData {
    
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var marketButton: UIButton!
    
    @IBOutlet weak var icDoneTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.selectionStyle = .none
        self.exchangeButton.addTarget(self,
                                      action: #selector(self.onTouchUpInsideButton),
                                      for: .touchUpInside)
        self.marketButton.addTarget(self,
                                    action: #selector(self.onTouchUpInsideButton),
                                    for: .touchUpInside)
        
        self.exchangeButton.addTarget(self,
                                      action: #selector(self.onTouchDownButton),
                                      for: .touchDown)
        self.marketButton.addTarget(self,
                                    action: #selector(self.onTouchDownButton),
                                    for: .touchDown)
        
        self.exchangeButton.addTarget(self,
                                      action: #selector(self.onTouchUpButton),
                                      for: .touchDragExit)
        self.marketButton.addTarget(self,
                                    action: #selector(self.onTouchUpButton),
                                    for: .touchDragExit)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func onTouchUpInsideButton(_ sender: UIButton?) {
        if sender == exchangeButton {
            self.icDoneTopConstraint.constant = 10
        } else {
            self.icDoneTopConstraint.constant = 66
        }
        onTouchUpButton(sender)
    }
    
    @objc func onTouchUpButton(_ sender: UIButton?) {
        self.exchangeButton.backgroundColor = UIColor.clear
        self.marketButton.backgroundColor = UIColor.clear
        
    }
    
    @objc func onTouchDownButton(_ sender: UIButton?) {
        if sender == exchangeButton {
            self.exchangeButton.backgroundColor = self.selectedBackgroundView?.backgroundColor
        } else {
            self.marketButton.backgroundColor = self.selectedBackgroundView?.backgroundColor
        }
    }

    
    
}
