//
//  CHCreateAlertPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHCreateAlertPresenter: NSObject {    
    fileprivate let form: CHCreateAlertHighLowForm
    
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
//        log.debug(currencyPair, topBound, bottomBound, notes)
    }
    
}

extension CHCreateAlertPresenter: CHCreateAlertHighLowFormDelegate {
    
    func createAlertHighLowFormDidActCTA(_ form: CHCreateAlertHighLowForm) {
        if form.isValid() {
            log.debug("form is valid")
            doCreateAlert()
        } else {
            log.debug("form isn't valid")
        }
    }
    
}
