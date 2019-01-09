//
//  AlertViewCell+SetupViews.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//


import UIKit

extension AlertViewCell {    
    func setupLeftViews() {
        addSubview(labelTimeCreate)
        labelTimeCreate.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        labelTimeCreate.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        addSubview(labelAlertStatus)
        labelAlertStatus.anchor(labelTimeCreate.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 55, heightConstant: 25)
        
        addSubview(imageSeparator)
        imageSeparator.anchor(self.topAnchor, left: labelTimeCreate.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 5, leftConstant: 10, bottomConstant: 20, rightConstant: 0, widthConstant: 10, heightConstant: 0)
    }
    
    func setupRightViews() {
        let contentView = UIView()
        addSubview(contentView)
        contentView.anchor(imageSeparator.topAnchor, left: imageSeparator.rightAnchor, bottom: imageSeparator.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 3, rightConstant: 30, widthConstant: 0, heightConstant: 0)

        let spaceBetweenRows: CGFloat = 10.0
        let topOffset: CGFloat = -5
        
        // @MARK: left column
        let currencyStackView = UIStackView(arrangedSubviews: [currencyTitleLabel, currencyLabel])
        currencyStackView.axis = .vertical
        
        let amountStackView = UIStackView(arrangedSubviews: [priceTitleLabel, priceValueLabel])
        amountStackView.axis = .vertical
        
        let leftColumnStackView = UIStackView(arrangedSubviews: [currencyStackView, amountStackView])
        contentView.addSubview(leftColumnStackView)
        leftColumnStackView.spacing = spaceBetweenRows
        leftColumnStackView.axis = .vertical
        leftColumnStackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        
        // @MARK: right column
        let quantityStackView = UIStackView(arrangedSubviews: [topBoundTitleLabel, labelTopBound])
        quantityStackView.axis = .vertical
        
        let priceStackView = UIStackView(arrangedSubviews: [bottomBoundTitleLabel, labelBottomBound])
        priceStackView.axis = .vertical
        
        let rightColumnStackView = UIStackView(arrangedSubviews: [quantityStackView, priceStackView])
        contentView.addSubview(rightColumnStackView)
        rightColumnStackView.spacing = spaceBetweenRows
        rightColumnStackView.axis = .vertical
        rightColumnStackView.anchor(contentView.topAnchor, left: nil, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 0)
    }

    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.anchor(
                imageSeparator.bottomAnchor,
                left: labelTimeCreate.leftAnchor,
                bottom: self.bottomAnchor,
                right: self.rightAnchor,
                topConstant: 0,
                leftConstant: 0,
                bottomConstant: 0,
                rightConstant: 30,
                widthConstant: 0,
                heightConstant: 0)
    }
    
    static func getTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 13)
        label.textAlignment = .left
        label.textColor = .steel
        return label
    }
    
    static func getValueLabel() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }
}
