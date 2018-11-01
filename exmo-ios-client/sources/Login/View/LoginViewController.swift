//
//  LoginLoginViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInput {
    var output: LoginViewOutput!
    
    var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bgLoginOpacity")
        return imageView
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icAuthLogo")
        return imageView
    }()
    
    var apiKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "API Key:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        return label
    }()
    
    var apiKeyField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Enter your API key"
        textField.placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        textField.textColor = .white
        textField.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        textField.keyboardType = .asciiCapable
        textField.text = "K-369302d5be6ba084fde09cdad7e81b6127d240c2"
        return textField
    }()
    
    var secretKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "Secret Key:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        return label
    }()

    var secretKeyField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Enter your API secret key"
        textField.placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        textField.textColor = .white
        textField.keyboardType = .asciiCapable
        textField.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        textField.text = "S-0468871fa277d9c7da6a402bd6c9e1810e45a913"
        return textField
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icWalletClose"), for: .normal)
        return button
    }()

    let scanQRButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SCAN QR", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        button.titleLabel?.textAlignment = .center
        button.setBackgroundImage(UIImage(named: "icGrayButtonSe"), for: .normal)
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 12)
        button.titleLabel?.textAlignment = .center
        button.setBackgroundImage(UIImage(named: "icBlueButtonSe"), for: .normal)
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip authorization", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .Medium, fontSize: 14)
        return button
    }()

    public let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        return aiv
    }()
    
    var inputFieldsStackView: UIStackView!
    
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
    
    //
    func setNavigationBarVisible(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
        navigationController?.tabBarController?.tabBar.isHidden = isHidden
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// @MARK: LoginViewInput
extension LoginViewController {
    func setLoginData(loginModel: QRLoginModel?) {
        guard let loginModel = loginModel else {
            showAlert(title: "Login", message: "Sorry, we can't recognize QR code.")
            return
        }
        
        if loginModel.isValidate() {
            apiKeyField.text = loginModel.key
            secretKeyField.text = loginModel.secret
        }
    }
    
    func login() {
        showLoader()
        guard let key = apiKeyField.text, let secret = secretKeyField.text else {
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
    @objc func onTouchSignInButton(_ sender: Any) {
        login()
    }

    @objc func onTouchScanQRButton(_ sender: Any) {
        output.handleTouchOnScanQRButton()
    }

    @objc func onTouchSkipButton(_ sender: Any) {
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
