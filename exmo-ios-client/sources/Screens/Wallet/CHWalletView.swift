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
    
    override var tutorialImageName: String { return "imgTutorialWallet" }

    var isWalletVisible: Bool = false {
        didSet {
            balanceContainer.isHidden = !isWalletVisible
            currenciesTableView.isHidden = balanceContainer.isHidden
            isTutorialStubVisible = balanceContainer.isHidden
        }
    }
    
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
        
        currenciesTableView.tableFooterView = UIView()
        
        isWalletVisible = false
    }
    
}

// MARK: - Setters

extension CHWalletView {

    func set(walletForBalanceView wallet: ExmoWallet) {
        balanceView.set(amountBTC: wallet.amountBTC, amountUSD: wallet.amountUSD)
    }
    
}
