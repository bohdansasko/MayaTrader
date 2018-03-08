//
//  LoginLoginViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInput, UITextFieldDelegate {
    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var secretField: UITextField!
    
    var output: LoginViewOutput!

    // MARK: LoginViewInput
    func setupInitialState() {
        // do nothing
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        keyField.delegate = self
        secretField.delegate = self
        
        keyField.keyboardType = .asciiCapable
        secretField.keyboardType = .asciiCapable
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let qrViewController = segue.destination as? QRScannerViewController else { return }
        output.prepareToOpenQRView(qrViewController: qrViewController)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
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

    @IBAction func pressedLoginButton(_ sender: Any) {
        let qrModel = QRLoginModel(exmoIdentifier: "Exmo", key: keyField.text!, secret: secretField.text!)
        output.loadUserInfo(loginModel: qrModel)
    }
}
