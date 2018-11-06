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
        label.text = "\u{20BF} 56.19284"
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
        label.text = "$ 271, 362"
        return label
    }()
    
    var currencyDividerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icWalletDivider")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(currencyDividerImage)
        currencyDividerImage.anchorCenterSuperview()
        
        let btcStackView = UIStackView(arrangedSubviews: [btcTextLabel, btcValueLabel])
        addSubview(btcStackView)
        btcStackView.axis = .vertical
        btcStackView.spacing = 5
        btcStackView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 30, leftConstant: 30, bottomConstant: 48, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        let usdStackView = UIStackView(arrangedSubviews: [usdTextLabel, usdValueLabel])
        addSubview(usdStackView)
        usdStackView.axis = .vertical
        usdStackView.spacing = 5
        usdStackView.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 48, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("This method doesn't have implemention")
    }
}
