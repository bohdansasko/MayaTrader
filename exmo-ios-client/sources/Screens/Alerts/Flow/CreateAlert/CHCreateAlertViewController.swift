//
//  CHCreateAlertViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHCreateAlertViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHCreateAlertView
    
    fileprivate var presenter: CHCreateAlertPresenter!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupPresenter()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        assertionFailure("required")
    }
    
}

// MARK: - Setup

private extension CHCreateAlertViewController {
    
    func setupNavigation() {
        navigationItem.title = "SCREEN_CREATE_ALERT_TITLE".localized
        setupRightBarButtonItem(title: "CANCEL".localized,
                                normalColor: .orangePink,
                                highlightedColor: .orangePink,
                                action: #selector(actClose(_:)))
    }
    
    func setupPresenter() {
        let form = CHCreateAlertHighLowForm(tableView: contentView.tableView)
        presenter = CHCreateAlertPresenter(form: form)
    }
    
}

// MARK: - User interaction

private extension CHCreateAlertViewController {
    
    @objc func actClose(_ sender: Any) {
        self.close()
    }
    
}
