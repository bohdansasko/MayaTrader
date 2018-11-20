//
//  LoginNetworkProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol ILoginNetworkWorkerDelegate: class {
    func onDidLoadUserSuccessful(user: ExmoUser)
    func onDidLoadUserFail(errorMessage: String?)
}

protocol ILoginNetworkWorker {
    var delegate: ILoginNetworkWorkerDelegate! { get set }
    
    func loadUserInfo(loginModel: ExmoQRModel)
}
