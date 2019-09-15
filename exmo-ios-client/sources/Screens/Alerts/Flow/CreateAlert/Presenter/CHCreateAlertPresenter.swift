//
//  CHCreateAlertPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol CHCreateAlertPresenterDelegate: class {
    func createAlertPresenterDidSelectCurrency(_ presenter: CHCreateAlertPresenter)
}

final class CHCreateAlertPresenter: NSObject {    
    fileprivate let form: CHCreateAlertHighLowForm
    
    weak var delegate: CHCreateAlertPresenterDelegate?
    
    // MARK: - View lifecycle
    
    init(form: CHCreateAlertHighLowForm) {
        self.form = form
        
        super.init()
        
        self.form.delegate = self
    }
    
}

// MARK: - Network

private extension CHCreateAlertPresenter {
    
    func doCreateAlert() {
        log.debug(form.currencyPair, form.topBound, form.bottomBound, form.notes)
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
                log.debug("form is valid")
                doCreateAlert()
            } else {
                log.debug("form isn't valid")
            }
        default:
            break
        }
    }
    
}
