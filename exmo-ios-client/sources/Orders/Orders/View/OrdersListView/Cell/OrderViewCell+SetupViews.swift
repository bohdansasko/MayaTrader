
//
//  OrderViewCell+UI.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

extension OrderViewCell {
    func setupViews() {
        backgroundColor = nil
        
        setupLeftViews()
        setupRightViews()
    }
    
    func setupLeftViews() {
        addSubview(labelTimeCreateOrder)
        labelTimeCreateOrder.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        labelTimeCreateOrder.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        addSubview(orderTypeLabel)
        orderTypeLabel.anchor(labelTimeCreateOrder.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 55, heightConstant: 25)
        
        addSubview(imageSeparator)
        imageSeparator.anchor(self.topAnchor, left: labelTimeCreateOrder.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 10, heightConstant: 0)
    }

    func setupRightViews() {
        let contentView = UIView()
        addSubview(contentView)
        contentView.anchor(self.topAnchor, left: imageSeparator.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        
        let spaceBetweenRows: CGFloat = 17.0
        let topOffset: CGFloat = -2.0
        
        // MARK: left column
        let currencyStackView = UIStackView(arrangedSubviews: [currencyTitleLabel, currencyLabel])
        currencyStackView.axis = .vertical
        
        let amountStackView = UIStackView(arrangedSubviews: [amountTitleLabel, amountValueLabel])
        amountStackView.axis = .vertical
        
        let leftColumnStackView = UIStackView(arrangedSubviews: [currencyStackView, amountStackView])
        contentView.addSubview(leftColumnStackView)
        leftColumnStackView.spacing = spaceBetweenRows
        leftColumnStackView.axis = .vertical
        leftColumnStackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        
        // MARK: right column
        let quantityStackView = UIStackView(arrangedSubviews: [quantityTitleLabel, quantityValueLabel])
        quantityStackView.axis = .vertical
        
        let priceStackView = UIStackView(arrangedSubviews: [priceTitleLabel, priceValueLabel])
        priceStackView.axis = .vertical
        
        let rightColumnStackView = UIStackView(arrangedSubviews: [quantityStackView, priceStackView])
        contentView.addSubview(rightColumnStackView)
        rightColumnStackView.spacing = spaceBetweenRows
        rightColumnStackView.axis = .vertical
        rightColumnStackView.alignment = .leading
        rightColumnStackView.anchor(contentView.topAnchor, left: nil, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 0)
    }
}

extension OrderViewCell {
    func getOrderActionTypeLabelTextColor(orderType: OrderActionType) -> UIColor {
        switch orderType {
        case .buy: return .dodgerBlue
        case .sell: return UIColor(red: 131.0/255, green: 132.0/255, blue: 150.0/255, alpha: 1.0)
        default: return UIColor.black
        }
    }

    static func getTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 13)
        label.textAlignment = .left
        label.textColor = .steel
        return label
    }

    static func getValueLabel() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }
}
