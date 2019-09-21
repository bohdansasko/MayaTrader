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
        
        if isEditingMode {
            fetchCurrency()
        }
        
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
        form = CHCreateAlertHighLowForm(tableView: contentView.tableView, isEditingMode: isEditingMode)
        form.delegate = self
        
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

// MARK: - API

private extension CHCreateAlertViewController {
    
    func doCreateAlert() {
        let alert = parseAlert(from: self.form)
        let request = vinsoAPI.rx.createAlert(alert: alert)
        rx.showLoadingView(fullscreen: true, request: request)
            .subscribe(
                onSuccess: { [unowned self] alert in
                    self.close()
                },
                onError: { [unowned self] err in
                    self.handleError(err)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func doUpdateAlert() {
        let alert = parseAlert(from: self.form)
        let request = vinsoAPI.rx.updateAlert(alert)
        rx.showLoadingView(fullscreen: true, request: request)
            .subscribe(onSuccess: { [unowned self] alert in
                self.close()
                }, onError: { [unowned self] err in
                    self.handleError(err)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchCurrency() {
        let req = vinsoAPI.rx.getCurrencies(selectedCurrencies: [ editAlert!.stockExchange.rawValue: [editAlert!.currencyCode] ])
        rx.showLoadingView(fullscreen: true, request: req)
            .subscribe(
                onSuccess: { [weak self] currencies in
                    guard let `self` = self, let currency = currencies.first else { return }
                    self.form.set(currency: currency)
                },
                onError: { [weak self] err in
                    guard let `self` = self else { return }
                    self.handleError(err)
                })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Help

private extension CHCreateAlertViewController {
    
    func parseAlert(from form: CHCreateAlertHighLowForm) -> Alert {
        let id = editAlert?.id ?? 0
        let topBound: Double? = form.topBound != nil ? Utils.getJSONFormattedNumb(from: form.topBound!) : nil
        let bottomBound: Double? = form.bottomBound != nil ? Utils.getJSONFormattedNumb(from: form.bottomBound!) : nil
        
        // TODO bohdans: fetch priceAtCreateMoment
        // let priceAtCreateMoment = selectedPair?.lastTrade ?? editAlert?.priceAtCreateMoment ?? 0
        
        let newAlert = Alert(id: id,
                             currencyPairName: form.selectedCurrency!.name,
                             priceAtCreateMoment: form.selectedCurrency!.sellPrice,
                             notes: form.notes,
                             topBoundary: topBound,
                             bottomBoundary: bottomBound,
                             isPersistentNotification: false,
                             stock: form.selectedCurrency!.stock)
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
