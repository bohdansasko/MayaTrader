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
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: LoginViewInput
    func setupInitialState() {
        setupInputFields()
    }
    
    func setupInputFields() {
        keyField.delegate = self
        secretField.delegate = self
        
        keyField.keyboardType = .asciiCapable
        secretField.keyboardType = .asciiCapable
        
        let inputFieldPlaceHolderAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3),
            NSAttributedStringKey.font: UIFont(name: "Exo2-Regular", size: 14)
        ]
        self.keyField.attributedPlaceholder = NSAttributedString(string: "Enter your API-secret", attributes: inputFieldPlaceHolderAttributes)
        self.secretField.attributedPlaceholder = NSAttributedString(string: "Enter your API-key", attributes: inputFieldPlaceHolderAttributes)
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
        let qrModel = QRLoginModel(exmoIdentifier: SDefaultValues.ExmoIdentifier.rawValue, key: "K-6cb40a588299195fd7b51d37798d14fdda2a62c8", secret: "S-85cf265b82cae660ff5cdea7363087947f75ecc0")
        output.loadUserInfo(loginModel: qrModel)
    }
    
    @IBAction func handlePressedCloseBtn(_ sender: Any) {
        output.handlePressedCloseBtn()
    }
}
