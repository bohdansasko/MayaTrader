//
//  OrderViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class OrderViewCell: UITableViewCell {
    var labelTimeCreateOrder: UILabel = {
        let label = OrderViewCell.getTitleLabel(text: "quantity")
        label.text = "29.12.1972 12:13"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var orderTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 13)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return label
    }()
    
    var imageSeparator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icVerticalLine")
        imageView.contentMode = .center
        return imageView
    }()

    var currencyTitleLabel: UILabel = {
        return OrderViewCell.getTitleLabel(text: "currency")
    }()
    var currencyLabel: UILabel = {
        return OrderViewCell.getValueLabel()
    }()
    
    var quantityTitleLabel: UILabel = {
        return OrderViewCell.getTitleLabel(text: "quantity")
    }()
    var quantityValueLabel: UILabel = {
        return OrderViewCell.getValueLabel()
    }()
    
    var amountTitleLabel: UILabel = {
        return OrderViewCell.getTitleLabel(text: "amount")
    }()
    var amountValueLabel: UILabel = {
        return OrderViewCell.getValueLabel()
    }()
    
    var priceTitleLabel: UILabel = {
        return OrderViewCell.getTitleLabel(text: "price")
    }()
    var priceValueLabel: UILabel = {
        return OrderViewCell.getValueLabel()
    }()
    
    var order: OrderModel? {
        didSet {
            guard let orderData = order else { return }
            
            labelTimeCreateOrder.text = orderData.getDateCreatedAsStr()
            if AppDelegate.isIPhone(model: .Five) {
                labelTimeCreateOrder.widthAnchor.constraint(equalToConstant: 70).isActive = true
            }
            
            orderTypeLabel.text = orderData.getOrderActionTypeAsStr()
            orderTypeLabel.backgroundColor = getOrderActionTypeLabelTextColor(orderType: orderData.getOrderActionType())
            
            currencyLabel.text = orderData.getDisplayCurrencyPair()
            amountValueLabel.text = orderData.getAmountAsStr()
            
            priceValueLabel.text = orderData.getPriceAsStr()
            quantityValueLabel.text = orderData.getQuantityAsStr()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// @MARK: setup UI
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
        
        // @MARK: left column
        let currencyStackView = UIStackView(arrangedSubviews: [currencyTitleLabel, currencyLabel])
        currencyStackView.axis = .vertical

        let amountStackView = UIStackView(arrangedSubviews: [amountTitleLabel, amountValueLabel])
        amountStackView.axis = .vertical

        let leftColumnStackView = UIStackView(arrangedSubviews: [currencyStackView, amountStackView])
        contentView.addSubview(leftColumnStackView)
        leftColumnStackView.spacing = spaceBetweenRows
        leftColumnStackView.axis = .vertical
        leftColumnStackView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        
        // @MARK: right column
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
    
    fileprivate func getOrderActionTypeLabelTextColor(orderType: OrderActionType) -> UIColor {
        switch orderType {
        case .Buy: return .dodgerBlue
        case .Sell: return UIColor(red: 131.0/255, green: 132.0/255, blue: 150.0/255, alpha: 1.0)
        default: return UIColor.black
        }
    }
    
    fileprivate static func getTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 13)
        label.textAlignment = .left
        label.textColor = .steel
        return label
    }
    
    fileprivate static func getValueLabel() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }
}
