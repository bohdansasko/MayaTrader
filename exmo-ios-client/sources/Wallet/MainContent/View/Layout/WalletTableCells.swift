//
//  WalletCurrencyCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// @MARK: WalletCurrencyHeaderView
class WalletCurrencyHeaderView: UIView {
    var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Currency"
        return label
    }()
    
    var currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Balance"
        return label
    }()
    
    var countInOrdersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "In Orders"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .dodgerBlue
        
        let stackView = UIStackView(arrangedSubviews: [balanceLabel, currencyLabel, countInOrdersLabel])
        addSubview(stackView)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// @MARK: WalletCurrencyCell
class WalletCurrencyCell: UITableViewCell {
    var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    
    var currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    
    var countInOrdersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
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
    var currencyModel: ExmoWalletCurrencyModel? {
        didSet {
            guard let currencyModel = currencyModel else { return }
            balanceLabel.text = String(currencyModel.balance)
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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
