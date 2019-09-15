//
//  AlertViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class AlertViewCell: ExmoTableViewCell {
    var labelTimeCreate: UILabel = {
        let label = OrderViewCell.getTitleLabel(text: "quantity")
        label.text = "29.12.1972 06:02"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var labelAlertStatus: UILabel = {
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
    
    var priceTitleLabel: UILabel = {
        return OrderViewCell.getTitleLabel(text: "price")
    }()
    var priceValueLabel: UILabel = {
        return OrderViewCell.getValueLabel()
    }()
    
    var topBoundTitleLabel: UILabel = {
        return OrderViewCell.getTitleLabel(text: "max price")
    }()
    var labelTopBound: UILabel = {
        return OrderViewCell.getValueLabel()
    }()
    
    var bottomBoundTitleLabel: UILabel = {
        return OrderViewCell.getTitleLabel(text: "min price")
    }()
    var labelBottomBound: UILabel = {
        return OrderViewCell.getValueLabel()
    }()

    var descriptionLabel: UILabel = {
        let label = OrderViewCell.getTitleLabel(text: "")
        return label
    }()

    var item: Alert? {
        didSet {
            onItemDidSet()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = nil
        
        setupLeftViews()
        setupRightViews()
        setupDescriptionLabel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateAlertStatusBackground()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateAlertStatusBackground()
    }
}

private extension AlertViewCell {
    
    func onItemDidSet() {
        guard let item = item else {
            fatalError("required")
        }
        
        labelTimeCreate.text = item.formatedDate()
        if AppDelegate.isIPhone(model: .five) {
            labelTimeCreate.widthAnchor.constraint(equalToConstant: 70).isActive = true
        }

        labelAlertStatus.text = item.status.name
        updateAlertStatusBackground()

        currencyLabel.text = Utils.getDisplayCurrencyPair(rawCurrencyPairName: item.currencyCode)
        priceValueLabel.text = Utils.getFormatedPrice(value: item.priceAtCreateMoment, maxFractDigits: 10)

        labelTopBound.text = item.topBoundary != nil ? Utils.getFormatedPrice(value: item.topBoundary!, maxFractDigits: 10) : "-"
        labelBottomBound.text = item.bottomBoundary != nil ? Utils.getFormatedPrice(value: item.bottomBoundary!, maxFractDigits: 10) : "-"

        let description = item.notes == nil || item.notes!.isEmpty
                ? "Write your note..."
                : item.notes
        descriptionLabel.text = description
    }

    func updateAlertStatusBackground() {
        guard let item = item else {
            return
        }
        labelAlertStatus.backgroundColor = item.status == AlertStatus.active ? .greenBlue : .steel
    }
    
}
