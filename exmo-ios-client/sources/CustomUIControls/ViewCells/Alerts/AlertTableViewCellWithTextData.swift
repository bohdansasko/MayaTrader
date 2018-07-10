//
//  AlertTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertTableViewCellWithTextData: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        setupSelectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupSelectionView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        self.selectedBackgroundView = bgColorView
    }
    
    func getTextData() -> String {
        return ""
    }
    
    func getDoubleValue() -> Double {
        return 0.0
    }
    
    func getBoolValue() -> Bool {
        return true
    }
}
