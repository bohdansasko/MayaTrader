//
//  CHWalletView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletView: UIView {
    @IBOutlet fileprivate weak var balanceContainer: UIView!
    @IBOutlet fileprivate weak var currenciesTableView: UITableView!
              fileprivate lazy var balanceView = CHWalletBalanceView.loadViewFromNib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}

// MARK: - Setup

private extension CHWalletView {
    
    func setupUI() {
        balanceContainer.backgroundColor = .clear
        balanceContainer.addSubview(balanceView)
        balanceView.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
}

// MARK: - Setters

extension CHWalletView {

    func set(wallet: ExmoWallet) {
        balanceView.set(amountBTC: wallet.amountBTC, amountUSD: wallet.amountUSD)
    }
    
}
