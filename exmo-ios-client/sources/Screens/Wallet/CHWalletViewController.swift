//
//  CHWalletViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHWalletView
    
    fileprivate enum Segues: String {
        case manageWallet = "ManageWallet"
    }
    
    fileprivate var presenter: CHWalletCurrenciesListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - Setup

private extension CHWalletViewController {
    
    func setupUI() {
        navigationItem.title = "TAB_WALLET".localized
        setupRightBarButtonItem(image: #imageLiteral(resourcen: "icWalletOptions"), action: #selector(actManageWalletCurrencies(_:)))
        
        presenter = CHWalletCurrenciesListPresenter(tableView: contentView.currenciesTableView)
    }
    
}

// MARK: - Actions

private extension CHWalletViewController {
    
    @objc func actManageWalletCurrencies(_ sender: Any) {
        performSegue(withIdentifier: Segues.manageWallet.rawValue)
    }
    
}
