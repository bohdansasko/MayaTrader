//
//  LoginLoginViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInput {
    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var secretField: UITextField!
    
    var output: LoginViewOutput!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let qrViewController = segue.destination as? QRScannerViewController else { return }
        
        qrViewController.outputProtocol.setLoginPresenter(presenter: output as! LoginModuleInput)
    }

    func setLoginData(loginModel: QRLoginModel?) {
        if let qrInfo = loginModel {
            keyField.text = qrInfo.key
            secretField.text = qrInfo.secret

            // TODO: show activity view and hide it when data loaded +- 2 seconds
            output.loadUserInfo(loginModel: loginModel)
        }
    }

    // MARK: LoginViewInput
    func setupInitialState() {
        // do nothing
    }
}
