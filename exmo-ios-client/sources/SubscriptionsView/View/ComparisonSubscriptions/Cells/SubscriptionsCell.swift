//
//  SubscriptionsCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/27/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class SubscriptionsCell: ExmoCollectionCell {
    let featureNameLabel: UILabel = SubscriptionsCell.getTitleLabel(text: "", textAlignment: .left)
    let freeLabel: UILabel = SubscriptionsCell.getTitleLabel(text: "")
    let liteLabel: UILabel = SubscriptionsCell.getTitleLabel(text: "")
    let proLabel: UILabel = SubscriptionsCell.getTitleLabel(text: "")
    
    let freeStateImg: UIImageView = SubscriptionsCell.getStateImageInstance()
    let liteStateImg: UIImageView = SubscriptionsCell.getStateImageInstance()
    let proStateImg: UIImageView = SubscriptionsCell.getStateImageInstance()
    
    
    override var datasourceItem: Any? {
        didSet { onItemDidSet()  }
    }

    override func setupViews() {
        super.setupViews()
        
        addSubview(featureNameLabel)
        addSubview(freeLabel)
        addSubview(liteLabel)
        addSubview(proLabel)
        
        addSubview(freeStateImg)
        addSubview(liteStateImg)
        addSubview(proStateImg)
        
        featureNameLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0.4 * frame.width, heightConstant: 0)
        
        freeLabel.anchor(topAnchor, left: featureNameLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0.15 * frame.width, heightConstant: 0)
        liteLabel.anchor(topAnchor, left: freeLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0.15 * frame.width, heightConstant: 0)
        proLabel.anchor(topAnchor, left: liteLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0.15 * frame.width, heightConstant: 0)
        
        freeStateImg.centerYAnchor.constraint(equalTo: freeLabel.centerYAnchor).isActive = true
        liteStateImg.centerYAnchor.constraint(equalTo: liteLabel.centerYAnchor).isActive = true
        proStateImg.centerYAnchor.constraint(equalTo: proLabel.centerYAnchor).isActive = true
        
        freeStateImg.centerXAnchor.constraint(equalTo: freeLabel.centerXAnchor).isActive = true
        liteStateImg.centerXAnchor.constraint(equalTo: liteLabel.centerXAnchor).isActive = true
        proStateImg.centerXAnchor.constraint(equalTo: proLabel.centerXAnchor).isActive = true

        let stateImgHeightAndWidth: CGFloat = 20
        freeStateImg.widthAnchor.constraint(equalToConstant: stateImgHeightAndWidth).isActive = true
        liteStateImg.widthAnchor.constraint(equalTo: freeStateImg.widthAnchor).isActive = true
        proStateImg.widthAnchor.constraint(equalTo: freeStateImg.widthAnchor).isActive = true

        freeStateImg.heightAnchor.constraint(equalToConstant: stateImgHeightAndWidth).isActive = true
        liteStateImg.heightAnchor.constraint(equalTo: freeStateImg.heightAnchor).isActive = true
        proStateImg.heightAnchor.constraint(equalTo: freeStateImg.heightAnchor).isActive = true
    }
}

extension SubscriptionsCell {
    func onItemDidSet() {
        guard let item = datasourceItem as? SubscriptionsCellModel else { return }
        featureNameLabel.text = item.name
        showState(freeLabel, freeStateImg, item.forFree)
        showState(liteLabel, liteStateImg, item.forLite)
        showState(proLabel, proStateImg, item.forPro)
    }
    
    private func showState(_ label: UILabel, _ stateImg: UIImageView, _ value: Any) {
        if value is Int {
            label.text = String(value as! Int)
        } else if value is String {
            label.text = value as? String
        } else if value is Bool {
            label.isHidden = true
            
            let imgState = value as! Bool
            stateImg.isHidden = false
            stateImg.image = UIImage(named: imgState ? "icSmallCheck" : "icSmallCross")
        }
    }
}

extension SubscriptionsCell {
    static func getTitleLabel(text: String, textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 13)
        label.textAlignment = textAlignment
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }
    
    static func getStateImageInstance() -> UIImageView {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.isHidden = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }
}
