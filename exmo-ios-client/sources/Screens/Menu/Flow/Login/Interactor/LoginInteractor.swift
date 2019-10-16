//
//  LoginLoginInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import ObjectMapper
import SwiftyJSON
import Alamofire

class LoginInteractor  {
    weak var output: LoginInteractorOutput!
    var networkWorker: ILoginNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: LoginInteractorInput
extension LoginInteractor: LoginInteractorInput {
    
    func viewIsReady() {
        NotificationCenter.default.addObserver(
            forName: AuthorizationNotification.userSignIn.name,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let `self` = self else { return }
                self.output.closeViewController()
        }

        NotificationCenter.default.addObserver(forName: AuthorizationNotification.userFailSignIn.name,
                                               object: nil,
                                               queue: .main) { [weak self] n in
                                                guard let `self` = self else { return }
            let reasonDescription = n.userInfo![CHUserInfoKeys.reason.rawValue] as! String
            self.output.showAlert(title: "Login", message: reasonDescription)
        }
    }
    
    func loadUserInfo(loginModel: ExmoQR) {
        CHExmoAuthorizationService.shared.login(by: loginModel)
    }
}
