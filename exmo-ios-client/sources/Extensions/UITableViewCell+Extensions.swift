//
//  UITableViewCell+Extensions.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class ExmoTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSelectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSelectionView()
    }
    
    func setupSelectionView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .backgroundColorSelectedCell
        self.selectedBackgroundView = bgColorView
    }
}
