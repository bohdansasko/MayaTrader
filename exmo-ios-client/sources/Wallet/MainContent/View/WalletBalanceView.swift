//
//  WalletBalanceView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/8/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class WalletBalanceView: UIView {
    var btcTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textColor = .steel
        label.text = "BTC"
        return label
    }()
    
    var btcValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 24)
        label.textColor = .dodgerBlue
        label.text = "56.19284"
        return label
    }()
    
    var usdTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textColor = .steel
        label.text = "USD"
        return label
    }()
    
    var usdValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 24)
        label.textColor = .dodgerBlue
        label.text = "$ 271 362"
        return label
    }()
    
    var currencyDividerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icWalletDivider")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(currencyDividerImage)
        
        addSubview(btcTextLabel)
        addSubview(btcValueLabel)
        
        addSubview(usdTextLabel)
        addSubview(usdValueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("This method doesn't have implemention")
    }
}
