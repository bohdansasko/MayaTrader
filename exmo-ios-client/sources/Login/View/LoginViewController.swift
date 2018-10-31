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
    public let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        return aiv
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisible(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavigationBarVisible(isHidden: false)
        hideLoader()
    }
    
    func setNavigationBarVisible(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
        navigationController?.tabBarController?.tabBar.isHidden = isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let qrViewController = segue.destination as? QRScannerViewController else { return }
        output.prepareToOpenQRView(qrViewController: qrViewController)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController {
    func setupViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupActivityViewIndicator()
        setupInputFields()
    }
    
    private func setupActivityViewIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
        activityIndicatorView.isHidden = true
    }
    
    private func setupInputFields() {
        keyField.delegate = self
        secretField.delegate = self
        
        keyField.keyboardType = .asciiCapable
        keyField.text = "K-369302d5be6ba084fde09cdad7e81b6127d240c2"
        secretField.keyboardType = .asciiCapable
        secretField.text = "S-0468871fa277d9c7da6a402bd6c9e1810e45a913"
        
        let inputFieldPlaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3),
            NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        ]
        keyField.attributedPlaceholder = NSAttributedString(string: "Enter your API-secret", attributes: inputFieldPlaceHolderAttributes)
        secretField.attributedPlaceholder = NSAttributedString(string: "Enter your API-key", attributes: inputFieldPlaceHolderAttributes)
    }
}
// @MARK: LoginViewInput
extension LoginViewController {
    func setLoginData(loginModel: QRLoginModel?) {
        guard let loginModel = loginModel else {
            // TODO: show alert
            return
        }
        
        keyField.text = loginModel.key
        secretField.text = loginModel.secret
    }
    
    func login() {
        showLoader()
        guard let key = keyField.text, let secret = secretField.text else {
            print("Fields is empty!")
            return
        }
        
        let qrModel = QRLoginModel(exmoIdentifier: SDefaultValues.ExmoIdentifier.rawValue, key: key, secret: secret)
        output.loadUserInfo(loginModel: qrModel)
    }
    
    func showLoader() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func hideLoader() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func showAlert(title: String, message: String) {
        hideLoader()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak self] action in
            self?.output.closeViewController()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// @MARK: actions
extension LoginViewController {
    @IBAction func pressedLoginButton(_ sender: Any) {
        login()
    }
    
    @IBAction func handlePressedCloseBtn(_ sender: Any) {
        output.closeViewController()
    }
}

// @MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
