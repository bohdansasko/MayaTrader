//
//  CHWalletView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletView: CHBaseTabView {
    @IBOutlet fileprivate      weak var balanceContainer: UIView!
    @IBOutlet fileprivate(set) weak var currenciesTableView: UITableView!
              fileprivate      lazy var balanceView = CHWalletBalanceView.loadViewFromNib()

    var isWalletVisible: Bool = false {
        didSet {
            balanceContainer.isHidden = !isWalletVisible
            currenciesTableView.isHidden = balanceContainer.isHidden
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setTutorialVisible(isUserAuthorizedToExmo: Bool, hasContent: Bool) {
        if isUserAuthorizedToExmo {
            stubState = hasContent ? .none : .noContent(#imageLiteral(resourceName: "imgTutorialWallet"), nil)
        } else {
            stubState = .notAuthorized(nil, nil)
        }
    }
    
}

// MARK: - Setup

private extension CHWalletView {
    
    func setupUI() {
        balanceContainer.backgroundColor = .clear
        balanceContainer.addSubview(balanceView)
        balanceView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        currenciesTableView.tableFooterView = UIView()
        
        isWalletVisible = false
    }
    
}

// MARK: - Setters

extension CHWalletView {

    func set(balance: CHWalletBalance) {
        balanceView.set(amountBTC: balance.btc, amountUSD: balance.usd)
    }
    
}
