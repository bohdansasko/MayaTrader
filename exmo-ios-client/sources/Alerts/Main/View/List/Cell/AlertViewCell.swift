//
//  AlertViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertViewCell: ExmoTableViewCell {
    var labelTimeCreate: UILabel = {
        let label = OrderViewCell.getTitleLabel(text: "quantity")
        label.text = "29.12.1972 06:02"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var labelAlertStatus: UILabel = {
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
        super.init(coder: aDecoder)
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

extension AlertViewCell {
    func onItemDidSet() {
        guard let item = item else { return }
        labelTimeCreate.text = item.formatedDate()
        if AppDelegate.isIPhone(model: .Five) {
            labelTimeCreate.widthAnchor.constraint(equalToConstant: 70).isActive = true
        }

        labelAlertStatus.text = getTextStatusValue(status: item.status)
        updateAlertStatusBackground()

        currencyLabel.text = Utils.getDisplayCurrencyPair(rawCurrencyPairName: item.currencyCode)
        priceValueLabel.text = Utils.getFormatedPrice(value: item.priceAtCreateMoment)

        labelTopBound.text = item.topBoundary != nil ? Utils.getFormatedPrice(value: item.topBoundary!, maxFractDigits: 9) : "-"
        labelBottomBound.text = item.bottomBoundary != nil ? Utils.getFormatedPrice(value: item.bottomBoundary!, maxFractDigits: 9) : "-"
        descriptionLabel.text = item.description ?? "Write your note..."
    }

    func updateAlertStatusBackground() {
        guard let item = item else { return }
        labelAlertStatus.backgroundColor = item.status == AlertStatus.Active ? .greenBlue : .steel
    }

    func getTextStatusValue(status: AlertStatus) -> String {
        switch status {
        case .Active:
            return "Active"
        case .Inactive:
            return "Inactive"
        }
    }
}
