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
    
    fileprivate enum Segues: String {
        case selectCurrency
    }
    
    fileprivate var presenter: CHCreateAlertPresenter!
    
    /// use for editing existing alert
    var editAlert: Alert? {
        didSet { assert(!self.isViewLoaded) }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupPresenter()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId = Segues(rawValue: segue.identifier!)!
        switch segueId {
        case .selectCurrency:
            prepareSearchViewController(for: segue, sender: sender)
        }
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
        presenter = CHCreateAlertPresenter(vinsoAPI: vinsoAPI, form: form)
        presenter.delegate = self
    }
    
}

// MARK: - Prepare view controller for segue

private extension CHCreateAlertViewController {
    
    func prepareSearchViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! CHExchangesViewController
        vc.selectionMode = .currency
        vc.onClose = { [unowned self] selectedCurrency in
            log.info("selected currency", selectedCurrency)
            self.presenter.set(currency: selectedCurrency)
        }
    }
    
}

// MARK: - User interaction

private extension CHCreateAlertViewController {
    
    @objc func actClose(_ sender: Any) {
        self.close()
    }
    
}

extension CHCreateAlertViewController: CHCreateAlertPresenterDelegate {
    
    func createAlertPresenterDidSelectCurrency(_ presenter: CHCreateAlertPresenter) {
        performSegue(withIdentifier: Segues.selectCurrency.rawValue)
    
    }
    
    func createAlertPresenter(_ presenter: CHCreateAlertPresenter, didActCreateAlert alert: Alert) {
        let request = presenter.createAlert(alert)
        rx.showLoadingView(request: request)
            .subscribe(onSuccess: { [unowned self] alert in
                self.close()
            }, onError: { [unowned self] err in
                self.handleError(err)
            })
            .disposed(by: disposeBag)
    }
    
    func createAlertPresenter(_ presenter: CHCreateAlertPresenter, onError error: Error) {
        handleError(error)
    }
    
}
