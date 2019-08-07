//
//  CHMenuViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import SnapKit

final class CHMenuViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHMenuView
    
    // MARK: - Private properties
    
    fileprivate var presenter: CHMenuViewPresenter!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - Setup

private extension CHMenuViewController {
    
    func setupUI() {
        navigationItem.title = "TAB_MENU".localized
        setupPresenter()
    }
    
    func setupPresenter() {
        presenter = CHMenuViewPresenter()
        presenter.delegate = self
        presenter.set(tableView: contentView.tableView)
    }
    
}

extension CHMenuViewController: CHMenuViewPresenterDelegate {
    
    func menuViewPresenter(_ presenter: CHMenuViewPresenter, didSelect type: CHMenuCellType) {
        print("\(type)")
    }

}
