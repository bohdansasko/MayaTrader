//
//  WalletWalletInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

protocol IWalletNetworkWorker: NetworkWorker {
    func loadWalletInfo()
}

class ExmoWalletNetworkWorker : IWalletNetworkWorker {
    var onHandleResponseSuccesfull: ((Any) -> Void)?
    
    func loadWalletInfo() {
        let request = ExmoApiRequestBuilder.shared.getUserInfoRequest();
        Alamofire.request(request).responseJSON {
            [weak self] response in
            self?.handleResponse(response: response)
        }
    }
}

class WalletInteractor: WalletInteractorInput {
    weak var output: WalletInteractorOutput!
    var networkWorker: IWalletNetworkWorker!
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    func viewIsReady() {
        networkWorker.onHandleResponseSuccesfull = {
            [weak self] response in
            guard let json = response as? JSON else { return }
            guard let wallet = WalletModel(JSONString: json.description) else { return }
            self?.output.onDidLoadWallet(wallet)
        }
        
        subscribeOnEvents()
        if AppDelegate.session.isExmoAccountExists() {
            networkWorker.loadWalletInfo()
        }
    }
    
    private func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserSignIn), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserSignOut), name: .UserSignOut)
    }

    @objc func onUserSignIn() {
        networkWorker.loadWalletInfo()
    }
    
    @objc func onUserSignOut() {
        self.output.onDidLoadWallet(WalletModel())
    }

}
