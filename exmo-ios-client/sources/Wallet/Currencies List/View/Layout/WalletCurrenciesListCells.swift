//
//  WalletCurrenciesListTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// MARK: WalletCurrenciesListTableHeaderCell
class WalletCurrenciesListTableHeaderCell: UITableViewHeaderFooterView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .bold, fontSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black

        addSubview(titleLabel)
        titleLabel.anchor(topAnchor, left: leftAnchor,
                          bottom: bottomAnchor, right: rightAnchor,
                          topConstant: 0, leftConstant: 30,
                          bottomConstant: 0, rightConstant: 30,
                          widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: WalletCurrenciesListTableViewCell
class WalletCurrenciesListTableViewCell: UITableViewCell {
    var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    var amountCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dark2
        label.text = "9600.235"
        return label
    }()

    var inOrdersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dark2
        label.text = "0"
        return label
    }()

    var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icWalletAssign"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icWalletUnassign"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "icWalletUnassign"), for: .selected)
        return button
    }()
    
    var burgerImage: UIImageView = {
        let image = UIImage(named: "icWalletDragDrop")?.withRenderingMode(.alwaysOriginal)
        let button = UIImageView()
        button.image = image
        button.contentMode = .center
        button.isExclusiveTouch = true
        return button
    }()
    
    var bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .dark1
        return view
    }()
    
    var currency: ExmoWalletCurrency? {
        didSet {
            guard let lCurrency = currency else { return }
            currencyNameLabel.text = lCurrency.code
            amountCurrencyLabel.text = "Balance: " + Utils.getFormatedPrice(value: lCurrency.balance, maxFractDigits: 10)
            inOrdersLabel.text = "In Orders: " + String(Int(lCurrency.countInOrders))
            actionButton.isSelected = lCurrency.isFavourite
        }
    }

    var onSwitchValueCallback: ((_ currency: ExmoWalletCurrency) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        contentView.backgroundColor = .black
        backgroundView?.backgroundColor = .black
        
        showsReorderControl = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WalletCurrenciesListTableViewCell {
    func setupViews() {
        addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(handleTouchActionButton(_ :)), for: .touchUpInside)
        actionButton.anchor(self.topAnchor, left: self.leftAnchor,
                            bottom: self.bottomAnchor, right: nil,
                            topConstant: 20, leftConstant: 30,
                            bottomConstant: 20, rightConstant: 0,
                            widthConstant: 25, heightConstant: 25)
        
        addSubview(currencyNameLabel)
        currencyNameLabel.anchor(self.topAnchor, left: actionButton.rightAnchor,
                                 bottom: self.bottomAnchor, right: nil,
                                 topConstant: 10, leftConstant: 20,
                                 bottomConstant: 33, rightConstant: 0,
                                 widthConstant: 100, heightConstant: 0)

        let bottomStackView = UIStackView(arrangedSubviews: [amountCurrencyLabel, inOrdersLabel])
        addSubview(bottomStackView)
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .leading
        bottomStackView.anchor(currencyNameLabel.bottomAnchor, left: currencyNameLabel.leftAnchor,
                               bottom: self.bottomAnchor, right: self.rightAnchor,
                               topConstant: 0, leftConstant: 0,
                               bottomConstant: 6, rightConstant: 85,
                               widthConstant: 0, heightConstant: 0)

        addSubview(burgerImage)
        burgerImage.anchor(actionButton.topAnchor, left: bottomStackView.rightAnchor,
                           bottom: actionButton.bottomAnchor, right: self.rightAnchor,
                           topConstant: 0, leftConstant: 20,
                           bottomConstant: 0, rightConstant: 30,
                           widthConstant: 0, heightConstant: 0)
        
        addSubview(bottomSeparatorLine)
        bottomSeparatorLine.anchor(nil, left: self.leftAnchor,
                                   bottom: self.bottomAnchor, right: self.rightAnchor,
                                   topConstant: 0, leftConstant: 30,
                                   bottomConstant: 0, rightConstant: 30,
                                   widthConstant: 0, heightConstant: 1)
    }
    
    @objc func handleTouchActionButton(_ sender: Any) {
        guard let lCurrency = currency else { return }
        lCurrency.isFavourite = !lCurrency.isFavourite
        actionButton.isSelected = lCurrency.isFavourite
        onSwitchValueCallback?(lCurrency)
    }
}
