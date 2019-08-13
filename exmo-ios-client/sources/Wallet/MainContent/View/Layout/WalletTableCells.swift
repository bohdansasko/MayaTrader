//
//  WalletCurrencyCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// MARK: WalletCurrencyCell
class WalletCurrencyCell: UITableViewCell {
    var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    
    var currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    
    var countInOrdersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    
    var index: Int? {
        didSet {
            guard let index = index else { return }
            self.backgroundColor = (index + 1) % 2 == 0 ? .dark : .clear
        }
    }
    var currencyModel: ExmoWalletCurrency? {
        didSet {
            guard let currencyModel = currencyModel else { return }
            balanceLabel.text = Utils.getFormatedPrice(value: currencyModel.balance)
            currencyLabel.text = currencyModel.code
            countInOrdersLabel.text = String(currencyModel.countInOrders)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, balanceLabel, countInOrdersLabel])
        addSubview(stackView)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
