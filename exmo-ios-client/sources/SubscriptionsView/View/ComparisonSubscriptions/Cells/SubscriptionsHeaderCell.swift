//
//  SubscriptionHeader.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/27/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class SubscriptionsHeaderCell: ExmoCollectionCell {
    var featureNameLabel: UILabel = {
        let label = SubscriptionsCell.getTitleLabel(text: "Features", textAlignment: .left)
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 15)
        return label
    }()
    
    var freeLabel: UILabel = {
        let label = SubscriptionsCell.getTitleLabel(text: "Free")
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 15)
        return label
    }()
    
    var liteLabel: UILabel = {
        let label = SubscriptionsCell.getTitleLabel(text: "Lite")
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 15)
        return label
    }()
    
    var proLabel: UILabel = {
        let label = SubscriptionsCell.getTitleLabel(text: "Pro")
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 15)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .dodgerBlue
        
        addSubview(featureNameLabel)
        featureNameLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        featureNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4, constant: 0).isActive = true
        
        addSubview(freeLabel)
        freeLabel.anchor(topAnchor, left: featureNameLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0.15 * frame.width, heightConstant: 0)

        addSubview(liteLabel)
        liteLabel.anchor(topAnchor, left: freeLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0.15 * frame.width, heightConstant: 0)

        addSubview(proLabel)
        proLabel.anchor(topAnchor, left: liteLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0.15 * frame.width, heightConstant: 0)
    }
}
