//
//  Cells.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/16/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

//
// @MARK: CurrenciesListHeaderCell
//
class CurrenciesListHeaderCell: DatasourceCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ALL PAIRS"
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .left
        label.textColor = .dark2
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 25, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

//
// @MARK: CurrenciesListCell
//
class CurrenciesListCell: DatasourceCell {
    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()
    
    var pairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    var currencyIcon: UIImageView = {
        let icon = UIImage(named: "")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: icon)
        return imageView
    }()
    
    override var datasourceItem: Any? {
        didSet {
            guard let currencyModel = datasourceItem as? WatchlistCurrencyModel else { return }
            pairNameLabel.text = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currencyModel.pairName)
            currencyIcon.image = UIImage(named: currencyModel.getIconImageName())?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(currencyIcon)
        addSubview(pairNameLabel)
        addSubview(separatorHLineView)
        
        setupConstraints()
    }
}

extension CurrenciesListCell {
    fileprivate func setupConstraints() {
        currencyIcon.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 20, leftConstant: 5, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        pairNameLabel.anchorCenterYToSuperview()
        pairNameLabel.leftAnchor.constraint(equalTo: currencyIcon.rightAnchor, constant: 15).isActive = true
        pairNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 80).isActive = true
        
        separatorHLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
}
