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

        setupPresenter()
        setupRightBarButtonItem(title: "CANCEL".localized,
                                normalColor: .orangePink,
                                highlightedColor: .orangePink,
                                action: #selector(actClose(_:)))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        assertionFailure("required")
    }

}

// MARK: - Setup

private extension CHCreateAlertViewController {
    
    func setupPresenter() {
        presenter = CHCreateAlertPresenter(tableView: contentView.tableView, layout: CHCreateAlertHighLowLayout())
    }
    
}

// MARK: - User interaction

private extension CHCreateAlertViewController {
    
    @objc func actClose(_ sender: Any) {
        self.close()
    }
    
}
