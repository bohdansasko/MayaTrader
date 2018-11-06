//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class WalletSegueBlock: SegueBlock {
    private(set) var dataProvider: WalletModel!
    
    init(dataModel: WalletModel?) {
        dataProvider = dataModel
    }
}

class WalletTableCurrenciesView: UIView {
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        return tv;
    }()
    
    var dataProvider: WalletModel! {
        didSet {
            
            dataProvider.filterCurrenciesByFavourites()
            tableView.reloadData()
        }
    }
    
    let currencyCellId = "currencyCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Doesn't have implementation")
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WalletCurrencyCell.self, forCellReuseIdentifier: currencyCellId)
        tableView.fillSuperview()
    }

    func reloadData() {
//        dataProvider = AppDelegate.session.getUser().getWalletInfo()
//        balanceView.btcValueLabel.text = Utils.getFormatedPrice(value: dataProvider.getAmountMoneyInBTC(), maxFractDigits: 6)
//        balanceView.usdValueLabel.text = Utils.getFormatedPrice(value: dataProvider.getAmountMoneyInUSD(), maxFractDigits: 4)
//        tableView.reloadData()
    }
    
    func getWalletModelAsSegueBlock() -> SegueBlock? {
        return WalletSegueBlock(dataModel: dataProvider)
    }
}

extension WalletTableCurrenciesView: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.getCountUsedCurrencies()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return WalletCurrencyHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currencyModel = dataProvider.getCurrencyByIndexPath(indexPath: indexPath, numberOfSections: 1)
        let cell = tableView.dequeueReusableCell(withIdentifier: currencyCellId, for: indexPath) as! WalletCurrencyCell
        cell.index = indexPath.row
        cell.currencyModel = currencyModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
