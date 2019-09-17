//
//  CHCreateAlertViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

final class CHCreateAlertViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHCreateAlertView
    
    // MARK: - Private
    
    fileprivate enum Segues: String {
        case selectCurrency
    }
    
    fileprivate var form: CHCreateAlertHighLowForm!
    
    // MARK: - Public
    
    /// use for editing existing alert
    var editAlert: Alert? {
        didSet { assert(!self.isViewLoaded) }
    }
    
    var isEditingMode: Bool {
        return editAlert != nil
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupForm()
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
        navigationItem.title = isEditingMode
            ? "SCREEN_UPDATE_ALERT_TITLE".localized
            : "SCREEN_CREATE_ALERT_TITLE".localized
        
        setupRightBarButtonItem(title: "CANCEL".localized,
                                normalColor: .orangePink,
                                highlightedColor: .orangePink,
                                action: #selector(actClose(_:)))
    }
    
    func setupForm() {
        form = CHCreateAlertHighLowForm(tableView: contentView.tableView)
        if let alert = editAlert {
            form.set(alert: alert)
        }
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
            self.form.set(currency: selectedCurrency)
        }
    }
    
}

// MARK: - User interaction

private extension CHCreateAlertViewController {
    
    @objc func actClose(_ sender: Any) {
        self.close()
    }
    
}

// MARK: - Network

private extension CHCreateAlertViewController {
    
    func doCreateAlert() {
        let alert = parseAlert(from: self.form)
        let request = vinsoAPI.rx.createAlert(alert: alert)
        rx.showLoadingView(request: request)
            .subscribe(onSuccess: { [unowned self] alert in
                self.close()
                }, onError: { [unowned self] err in
                    self.handleError(err)
            })
            .disposed(by: disposeBag)
    }
    
    func doUpdateAlert() {
        let alert = parseAlert(from: self.form)
        let request = vinsoAPI.rx.updateAlert(alert)
        rx.showLoadingView(request: request)
            .subscribe(onSuccess: { [unowned self] alert in
                self.close()
                }, onError: { [unowned self] err in
                    self.handleError(err)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Help

private extension CHCreateAlertViewController {
    
    func parseAlert(from form: CHCreateAlertHighLowForm) -> Alert {
        let topBound: Double? = form.topBound != nil ? Utils.getJSONFormattedNumb(from: form.topBound!) : nil
        let bottomBound: Double? = form.bottomBound != nil ? Utils.getJSONFormattedNumb(from: form.bottomBound!) : nil
        
        // TODO bohdans: fetch priceAtCreateMoment
        // let priceAtCreateMoment = selectedPair?.lastTrade ?? editAlert?.priceAtCreateMoment ?? 0
        
        let newAlert = Alert(id: 0,
                             currencyPairName: form.selectedCurrency!.name,
                             priceAtCreateMoment: form.selectedCurrency!.sellPrice,
                             notes: form.notes,
                             topBoundary: topBound,
                             bottomBoundary: bottomBound,
                             isPersistentNotification: false)
        return newAlert
    }
    
}

// MARK: - CHCreateAlertHighLowFormDelegate

extension CHCreateAlertViewController: CHCreateAlertHighLowFormDelegate {
    
    func createAlertHighLowForm(_ form: CHCreateAlertHighLowForm, didTouch cell: CHCreateAlertHighLowForm.CellId) {
        switch cell {
        case .currency:
            performSegue(withIdentifier: Segues.selectCurrency.rawValue)
        case .notes, .currencyTopValue, .currencyBottomValue:
            break
        case .cta:
            if !form.isValid() {
                return
            }
            
            if isEditingMode {
                doUpdateAlert()
            } else {
                doCreateAlert()
            }
        }
    }
    
}
