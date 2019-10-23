//
//  CHBaseViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

protocol CHBaseViewControllerProtocol {
    associatedtype ContentView
    var contentView: ContentView! { get }
}

extension CHBaseViewControllerProtocol where Self: CHBaseViewController {
    
    var contentView: ContentView! {
        return view as? ContentView
    }
    
}

class CHBaseViewController: ExmoUIViewController {
    
    // MARK: - Internal variables/properties

    let vinsoAPI   = AppDelegate.vinsoAPI
    let exmoAPI    = CHExmoAPI.shared
    let dbManager  = RealmDatabaseManager.shared
    
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    deinit {
        log.debug("☠️ deinit")
    }
    
}

// MARK: - Loading indicator

extension CHBaseViewController {
    
    func makeLoadingView() -> CHLoadingView {
        let loader = CHLoadingView.loadViewFromNib()
        return loader
    }
    
}

// MARK: - Displaying errors

extension CHBaseViewController {

    func handleError(_ error: Error) {
        let message: String
        
        if let vinsoError = error as? CHVinsoAPIError {
            message = vinsoError.localizedDescription
        } else {
            message = error.localizedDescription
        }
        showAlert(title: navigationItem.title, message: message)
    }
    
    func showAlert(title: String?, message: String?, comment: String? = nil) {
        showAlert(title: title, message: message, comment: comment, okTitle: "OK".localized, okActionHandler: nil)
    }
    
    func showAlert(title: String?, message: String?, comment: String?, okTitle: String?, okActionHandler: ((UIAlertAction) -> Void)?) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okActionHandler)
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
}
