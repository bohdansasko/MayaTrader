//
//  CHBaseCollectionCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class CHBaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? UIColor.white.withAlphaComponent(0.1) : .clear
        }
    }
    
    func setupUI() {
        // do nothing
    }
    
}
