//
//  CHCreateAlertPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

protocol CHCreateAlertPresenterDelegate: class {
    func createAlertPresenterDidSelectCurrency(_ presenter: CHCreateAlertPresenter)
    func createAlertPresenter(_ presenter: CHCreateAlertPresenter, didActCreateAlert alert: Alert)
    func createAlertPresenter(_ presenter: CHCreateAlertPresenter, onError error: Error)
}

final class CHCreateAlertPresenter: NSObject {    
    fileprivate let vinsoAPI: VinsoAPI
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let form: CHCreateAlertHighLowForm
    
    weak var delegate: CHCreateAlertPresenterDelegate?
    
    // MARK: - View lifecycle
    
    init(vinsoAPI: VinsoAPI, form: CHCreateAlertHighLowForm) {
        self.form = form
        self.vinsoAPI = vinsoAPI
        
        super.init()
        
        self.form.delegate = self
    }
    
}

// MARK: - Setters

extension CHCreateAlertPresenter {
    
    func set(currency: CHLiteCurrencyModel) {
        form.set(currency: currency)
    }
    
}

// MARK: - User interaction

private extension CHCreateAlertPresenter {
    
    func doCreateAlert() {
        let topBound: Double? = form.topBound != nil ? Utils.getJSONFormattedNumb(from: form.topBound!) : nil
        let bottomBound: Double? = form.bottomBound != nil ? Utils.getJSONFormattedNumb(from: form.bottomBound!) : nil
        
        // TODO bohdansrz: fetch priceAtCreateMoment
        //        let priceAtCreateMoment = selectedPair?.lastTrade ?? editAlert?.priceAtCreateMoment ?? 0
        
        let newAlert = Alert(id: 0,
                             currencyPairName: form.selectedCurrency!.name,
                             priceAtCreateMoment: form.selectedCurrency!.sellPrice,
                             notes: form.notes,
                             topBoundary: topBound,
                             bottomBoundary: bottomBound,
                             isPersistentNotification: false)
        self.delegate?.createAlertPresenter(self, didActCreateAlert: newAlert)
    }
    
}

// MARK: - Network

extension CHCreateAlertPresenter {
    
    func createAlert(_ alert: Alert) -> Single<Alert> {
        let request = vinsoAPI.rx.createAlert(alert: alert)
        return request
    }
    
}

// MARK: - CHCreateAlertHighLowFormDelegate

extension CHCreateAlertPresenter: CHCreateAlertHighLowFormDelegate {
    
    func createAlertHighLowForm(_ form: CHCreateAlertHighLowForm, didTouch cell: CHCreateAlertHighLowForm.CellId) {
        switch cell {
        case .currency:
            self.delegate?.createAlertPresenterDidSelectCurrency(self)
        case .cta:
            if form.isValid() {
                doCreateAlert()
            }
        default:
            break
        }
    }
    
}
