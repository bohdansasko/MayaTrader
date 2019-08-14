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
    @IBOutlet fileprivate(set) weak var currenciesTableView: UITableView!
              fileprivate      lazy var balanceView = CHWalletBalanceView.loadViewFromNib()
    
    fileprivate let tutorialImg: TutorialImage = {
        let img = TutorialImage()
        img.imageName = "imgTutorialWallet"
        img.contentMode = .scaleAspectFit
        return img
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
//    func showPlaceholderIfRequired() {
//        guard let lWallet = wallet, lWallet.favBalances.isEmpty == false else {
//            tutorialImg.show()
//            return
//        }
//        tutorialImg.hide()
//    }
    
}

// MARK: - Setup

private extension CHWalletView {
    
    func setupUI() {
        balanceContainer.backgroundColor = .clear
        balanceContainer.addSubview(balanceView)
        balanceView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        currenciesTableView.tableFooterView = UIView()
    }
    
    func setupTutorialImg() {
        addSubview(tutorialImg)
        tutorialImg.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 45, left: 0, bottom: 20, right: 0))
        }
    }
    
}

// MARK: - Setters

extension CHWalletView {

    func set(walletForBalanceView wallet: ExmoWallet) {
        balanceView.set(amountBTC: wallet.amountBTC, amountUSD: wallet.amountUSD)
    }
    
}
