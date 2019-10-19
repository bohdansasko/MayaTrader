//
//  LoginLoginViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class LoginViewController: ExmoUIViewController, LoginViewInput {
    fileprivate enum Segues: String {
        case scanQR = "ScanQR"
    }
    
    var output: LoginViewOutput!
    var activeTextField: UITextField?
    
    var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "bgLoginOpacity")
        return imageView
    }()
    
    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
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
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 14)
        return label
    }()
    
    var apiKeyField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Enter your API key"
        textField.placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        textField.textColor = .white
        textField.font = UIFont.getExo2Font(fontType: .regular, fontSize: 14)
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    var secretKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "Secret Key:"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 14)
        return label
    }()

    var secretKeyField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Enter your API secret key"
        textField.placeholderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        textField.textColor = .white
        textField.keyboardType = .asciiCapable
        textField.font = UIFont.getExo2Font(fontType: .regular, fontSize: 14)
        return textField
    }()

    let scanQRButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SCAN QR", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .bold, fontSize: 12)
        button.titleLabel?.textAlignment = .center
        button.setBackgroundImage(UIImage(named: "icGrayButtonSe"), for: .normal)
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .bold, fontSize: 12)
        button.titleLabel?.textAlignment = .center
        button.setBackgroundImage(UIImage(named: "icBlueButtonSe"), for: .normal)
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip authorization", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .medium, fontSize: 14)
        return button
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subscribeOnKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeAllEvents()
        setNavigationBarVisible(isHidden: false)
        hideLoader()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController,
              let vc = nav.topViewController as? QRScannerViewController else {
            assertionFailure("fix me")
            return
        }
        
        if let qrPresenter = vc.outputProtocol as? QRScannerModuleInput {
            qrPresenter.setLoginPresenter(presenter: self.output as! LoginPresenter)
        }
    }
    
    func subscribeOnKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidShow(_:)), name: UIControl.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: UIControl.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeAllEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onKeyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size else { return }
        
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        let toolbarHeight = navigationController?.toolbar.frame.size.height ?? 0
        let bottomInset = keyboardSize.height - tabBarHeight - toolbarHeight
        
        scrollView.contentInset.bottom = bottomInset
        scrollView.scrollIndicatorInsets.bottom = bottomInset
        
        guard var activeFieldFrame = activeTextField?.superview?.frame else { return }
        activeFieldFrame.size.height += keyboardSize.height
        
        scrollView.setContentOffset(activeFieldFrame.origin, animated: true)
    }

    @objc func onKeyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func setNavigationBarVisible(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
        navigationController?.tabBarController?.tabBar.isHidden = isHidden
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func updateButtonsEnableState(isTouchEnabled: Bool) {
        scanQRButton.isEnabled = isTouchEnabled
        signInButton.isEnabled = isTouchEnabled
        skipButton.isEnabled = isTouchEnabled
    }
}

// MARK: LoginViewInput
extension LoginViewController {
    func setLoginData(loginModel: ExmoQR?) {
        guard let loginModel = loginModel else {
            showAlert(title: "Login", message: "Sorry, we can't recognize QR code.")
            return
        }
        
        if loginModel.isValidate() {
            apiKeyField.text = loginModel.key
            secretKeyField.text = loginModel.secret
        }
        login()
    }
    
    func login() {
        guard let key = apiKeyField.text, let secret = secretKeyField.text else {
            log.error("API (and/or) Secret (are/is) empty!")
            return
        }
        
        showLoader()
        updateButtonsEnableState(isTouchEnabled: false)
        let qrModel = ExmoQR(exmoIdentifier: UserDefaultsKeys.exmoId.rawValue, key: key, secret: secret)
        output.loadUserInfo(loginModel: qrModel)
    }
    
    func showAlert(title: String, message: String) {
        updateButtonsEnableState(isTouchEnabled: true)
        hideLoader()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak self] action in
            self?.output.closeViewController()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: actions
extension LoginViewController {
    @objc func onTouchSignInButton(_ sender: Any) {
        login()
    }

    @objc func onTouchScanQRButton(_ sender: Any) {
         performSegue(withIdentifier: Segues.scanQR.rawValue)
    }

    @objc func onTouchSkipButton(_ sender: Any) {
        output.closeViewController()
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
