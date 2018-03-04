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
        output.prepareToOpenQRView(qrViewController: qrViewController)
    }

    func setLoginData(loginModel: QRLoginModel?) {
        if let qrInfo = loginModel {
            keyField.text = qrInfo.key
            secretField.text = qrInfo.secret

            // show activity indicator
            // disable all buttons and transitions
            output.loadUserInfo(loginModel: loginModel)
        }
    }
    
    func showLoader() {
        print("showLoader()")
    }
    
    func hideLoader() {
        print("hideLoader()")
    }
    
    
    // MARK: LoginViewInput
    func setupInitialState() {
        // do nothing
    }
}
