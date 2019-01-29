//
//  SearchDatasourceListCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class SearchDatasourceListCell: ExmoTableViewCell {
    var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 14)
        label.textAlignment = .left
        label.text = "XRP/USD"
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
    
    var bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .dark1
        return view
    }()
    
    var model: SearchCurrencyPairModel? {
        didSet {
            currencyNameLabel.text = model?.getDisplayName()
            amountCurrencyLabel.text = model?.getPairPriceAsStr()
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
        setupBackgroundColor()
        setupUILayout()
    }
}

extension SearchDatasourceListCell {    
    func setupBackgroundColor() {
        backgroundColor = .black
        contentView.backgroundColor = .black
        backgroundView?.backgroundColor = .black
    }
    
    func setupUILayout() {
        addSubview(currencyNameLabel)
        currencyNameLabel.anchor(self.topAnchor,
                                 left: self.leftAnchor,
                                 bottom: self.bottomAnchor,
                                 right: nil,
                                 topConstant: 15,
                                 leftConstant: 30,
                                 bottomConstant: 33,
                                 rightConstant: 0,
                                 widthConstant: 100,
                                 heightConstant: 0)
        
        addSubview(amountCurrencyLabel)
        amountCurrencyLabel.anchor(currencyNameLabel.bottomAnchor,
                                   left: currencyNameLabel.leftAnchor,
                                   bottom: self.bottomAnchor,
                                   right: self.rightAnchor,
                                   topConstant: 0,
                                   leftConstant: 0,
                                   bottomConstant: 11,
                                   rightConstant: 85,
                                   widthConstant: 0,
                                   heightConstant: 0)
        
        addSubview(bottomSeparatorLine)
        bottomSeparatorLine.anchor(nil,
                                   left: self.leftAnchor,
                                   bottom: self.bottomAnchor,
                                   right: self.rightAnchor,
                                   topConstant: 0,
                                   leftConstant: 30,
                                   bottomConstant: 0,
                                   rightConstant: 30,
                                   widthConstant: 0,
                                   heightConstant: 1)
    }
}
