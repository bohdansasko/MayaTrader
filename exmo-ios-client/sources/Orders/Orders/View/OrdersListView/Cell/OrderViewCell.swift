//
//  OrderViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class OrderViewCell: UITableViewCell {
    var labelTimeCreateOrder: UILabel = {
        let label = OrderViewCell.getTitleLabel(text: "quantity")
        label.text = "29.12.1972 06:02"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var orderTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .bold, fontSize: 13)
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
            if AppDelegate.isIPhone(model: .five) {
                labelTimeCreateOrder.widthAnchor.constraint(equalToConstant: 70).isActive = true
            }
            
            orderTypeLabel.text = orderData.orderType.capsDescription()
            updateStatusBackground()
            
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
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateStatusBackground()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateStatusBackground()
    }
    
    private func updateStatusBackground() {
        guard let orderData = order else { return }
        orderTypeLabel.backgroundColor = getOrderActionTypeLabelTextColor(orderType: orderData.orderType)
    }
}
