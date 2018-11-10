//
//  WalletCurrenciesListWalletCurrenciesListInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController
import Alamofire
import SwiftyJSON

class WalletCurrenciesListInteractor: WalletCurrenciesListInteractorInput {
    weak var output: WalletCurrenciesListInteractorOutput!
    var networkWorker: IWalletCurrenciesListNetworkWorker!
    
    func viewIsReady() {
        networkWorker.delegate = self
    }
    
    func viewIsReadyToLoadData() {
        networkWorker.loadWalletInfo()
    }

    func saveWalletDataToCache() {
        print("WalletCurrenciesListInteractor: save wallet to cache")
        let isUserSavedToLocalStorage = AppDelegate.cacheController.userCoreManager.saveUserData(user: AppDelegate.session.getUser())
        if isUserSavedToLocalStorage {
            print("user info cached")
        }
    }
}

extension WalletCurrenciesListInteractor: IWalletCurrenciesListNetworkWorkerDelegate {
    func onDidLoadWalletInfo(response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                let json = try JSON(data: response.data!)
                guard let wallet = WalletModel(JSONString: json.description) else { return }
                output.onDidLoadWallet(wallet)
            } catch {
                print("NetworkWorker: we caught a problem in handle response")
            }
        case .failure(_):
            output.onDidLoadWallet(WalletModel())
        }
    }
}
