//
//  CurrenciesListCells.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

//
// MARK: CurrenciesListHeaderCell
//
class CurrenciesListHeaderCell: DatasourceCell {
    var favouriteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Fav."
        return label
    }()
    
    var pairTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Pair"
        return label
    }()
    
    var buyTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Buy"
        return label
    }()
    
    var sellTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Sell"
        return label
    }()
    
    var currencyChangesTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Changes"
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        self.backgroundColor = .dodgerBlue
        
        addSubview(favouriteLabel)
        addSubview(pairTextLabel)
        addSubview(buyTextLabel)
        addSubview(sellTextLabel)
        addSubview(currencyChangesTextLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let heartView = UIView()
        addSubview(heartView)
        heartView.translatesAutoresizingMaskIntoConstraints = false
        heartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        heartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        heartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        heartView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.13).isActive = true
        heartView.addSubview(favouriteLabel)
        favouriteLabel.fillSuperview()
        
        let pairNameView = UIView()
        addSubview(pairNameView)
        pairNameView.translatesAutoresizingMaskIntoConstraints = false
        pairNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pairNameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pairNameView.leftAnchor.constraint(equalTo: heartView.leftAnchor, constant: self.frame.width * 0.13).isActive = true
        pairNameView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17).isActive = true
        pairNameView.addSubview(pairTextLabel)
        pairTextLabel.fillSuperview()
        
        let buyValueView = UIView()
        addSubview(buyValueView)
        buyValueView.translatesAutoresizingMaskIntoConstraints = false
        buyValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buyValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buyValueView.leftAnchor.constraint(equalTo: pairNameView.leftAnchor, constant: self.frame.width * 0.17 + 5).isActive = true
        buyValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        buyValueView.addSubview(buyTextLabel)
        buyTextLabel.fillSuperview()
        
        let sellValueView = UIView()
        addSubview(sellValueView)
        sellValueView.translatesAutoresizingMaskIntoConstraints = false
        sellValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sellValueView.leftAnchor.constraint(equalTo: buyValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        sellValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        sellValueView.addSubview(sellTextLabel)
        sellTextLabel.fillSuperview()
        
        let changesValueView = UIView()
        addSubview(changesValueView)
        changesValueView.translatesAutoresizingMaskIntoConstraints = false
        changesValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        changesValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        changesValueView.leftAnchor.constraint(equalTo: sellValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        changesValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.16).isActive = true
        changesValueView.addSubview(currencyChangesTextLabel)
        currencyChangesTextLabel.fillSuperview()
    }
}

//
// MARK: CurrenciesListCell
//
class CurrenciesListCell: DatasourceCell {
    var addRemoveFromFavouritesListButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOff").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "icGlobalHeartOn").withRenderingMode(.alwaysOriginal), for: .selected)
        return btn
    }()
    
    var pairNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var buyValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var sellValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var currencyChangesValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 12)
        label.textAlignment = .center
        label.textColor = .greenBlue
        label.text = "+4.2 %"
        return label
    }()
    
    override var datasourceItem: Any? {
        didSet {
            guard let d = datasourceItem as? WatchlistCurrencyModel else { return }
            pairNameLabel.text = d.getDisplayCurrencyPairName()
            buyValueLabel.text = Utils.getFormatedPrice(value: d.buyPrice, maxFractDigits: 4)
            sellValueLabel.text = Utils.getFormatedPrice(value: d.buyPrice, maxFractDigits: 6)
            currencyChangesValueLabel.text = Utils.getFormatedCurrencyPairChanges(changesValue: d.getChanges())
            currencyChangesValueLabel.textColor = d.getChanges() < 0 ? .orangePink : .greenBlue
            self.backgroundColor = d.index % 2 == 1 ? .dark : .clear
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .dark
        
        addSubview(addRemoveFromFavouritesListButton)
        addSubview(pairNameLabel)
        addSubview(buyValueLabel)
        addSubview(sellValueLabel)
        addSubview(currencyChangesValueLabel)
        
        addRemoveFromFavouritesListButton.addTarget(self, action: #selector(onTouchFavBtn(_:)), for: .touchUpInside)
        
        setupConstraints()
    }
    
    @objc func onTouchFavBtn(_ sender: UIButton) {
        print(sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
    
    private func setupConstraints() {
        let heartView = UIView()
        addSubview(heartView)
        heartView.translatesAutoresizingMaskIntoConstraints = false
        heartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        heartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        heartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        heartView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.13).isActive = true
        heartView.addSubview(addRemoveFromFavouritesListButton)
        addRemoveFromFavouritesListButton.fillSuperview()
        
        let pairNameView = UIView()
        addSubview(pairNameView)
        pairNameView.translatesAutoresizingMaskIntoConstraints = false
        pairNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pairNameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pairNameView.leftAnchor.constraint(equalTo: heartView.leftAnchor, constant: self.frame.width * 0.13).isActive = true
        pairNameView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.17).isActive = true
        pairNameView.addSubview(pairNameLabel)
        pairNameLabel.fillSuperview()
        
        let buyValueView = UIView()
        addSubview(buyValueView)
        buyValueView.translatesAutoresizingMaskIntoConstraints = false
        buyValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buyValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buyValueView.leftAnchor.constraint(equalTo: pairNameView.leftAnchor, constant: self.frame.width * 0.17 + 5).isActive = true
        buyValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        buyValueView.addSubview(buyValueLabel)
        buyValueLabel.fillSuperview()
        
        let sellValueView = UIView()
        addSubview(sellValueView)
        sellValueView.translatesAutoresizingMaskIntoConstraints = false
        sellValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sellValueView.leftAnchor.constraint(equalTo: buyValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        sellValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.226).isActive = true
        sellValueView.addSubview(sellValueLabel)
        sellValueLabel.fillSuperview()
        
        let changesValueView = UIView()
        addSubview(changesValueView)
        changesValueView.translatesAutoresizingMaskIntoConstraints = false
        changesValueView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        changesValueView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        changesValueView.leftAnchor.constraint(equalTo: sellValueView.leftAnchor, constant: self.frame.width * 0.226 + 10).isActive = true
        changesValueView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.16).isActive = true
        changesValueView.addSubview(currencyChangesValueLabel)
        currencyChangesValueLabel.fillSuperview()
    }
}

