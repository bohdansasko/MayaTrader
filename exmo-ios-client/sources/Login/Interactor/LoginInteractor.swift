//
//  LoginLoginInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import ObjectMapper

class LoginInteractor: LoginInteractorInput {
    weak var output: LoginInteractorOutput!
    
    func viewIsReady() {
        self.subscribeOnEvents()
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    private func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserSignIn), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserFailSignIn), name: .UserFailSignIn)
    }
    
    func loadUserInfo(loginModel: QRLoginModel) {
        if !loginModel.isValidate() {
            print("qr data doesn't validate")
            return
        }
        AppDelegate.session.exmoLogin(loginModel: loginModel)
        //
        // TODO-REF: show loader view
        //
    }
    
    @objc func onUserSignIn() {
        AppDelegate.session.loadOrders(orderType: .Deals, serverType: .Exmo)
        AppDelegate.session.loadOrders(orderType: .Canceled, serverType: .Exmo)
        output.emitCloseView()
    }
    
    @objc func onUserFailSignIn() {
        //
        // hide loader view
        // show alert with message
        //
    }
}
