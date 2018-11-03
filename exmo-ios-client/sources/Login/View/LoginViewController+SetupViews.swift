//
//  LoginViewControllerUI.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController {
    func setupViews() {
        view.addSubview(backgroundImage)
        backgroundImage.fillSuperview()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        setupInputViews()
        setupLogo()
        setupBottomButtons()
        setupActivityViewIndicator()
    }
    
    private func setupActivityViewIndicator() {
        scrollView.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
        activityIndicatorView.isHidden = true
    }
    
    private func setupLogo() {
        scrollView.addSubview(logoImage)
        logoImage.anchor(inputFieldsStackView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -85, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupInputViews() {
        apiKeyField.delegate = self
        secretKeyField.delegate = self
        
        let apiKeyStackView = UIStackView(arrangedSubviews: [apiKeyLabel, apiKeyField])
        apiKeyStackView.axis = .vertical
        apiKeyStackView.distribution = .fill
        apiKeyStackView.spacing = 10
        
        let apiSecretKeyStackView = UIStackView(arrangedSubviews: [secretKeyLabel, secretKeyField])
        apiSecretKeyStackView.axis = .vertical
        apiSecretKeyStackView.distribution = .fill
        apiSecretKeyStackView.spacing = 10
        
        inputFieldsStackView = UIStackView(arrangedSubviews: [apiKeyStackView, apiSecretKeyStackView])
        scrollView.addSubview(inputFieldsStackView)
        inputFieldsStackView.axis = .vertical
        inputFieldsStackView.distribution = .fill
        inputFieldsStackView.spacing = 20
        
        inputFieldsStackView.anchorCenterXToSuperview()
        inputFieldsStackView.anchorCenterYToSuperview()
        inputFieldsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
    }
    
    func setupBottomButtons() {
        signInButton.addTarget(self, action: #selector(onTouchSignInButton(_ :)), for: .touchUpInside)
        scanQRButton.addTarget(self, action: #selector(onTouchScanQRButton(_ :)), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(onTouchSkipButton(_ :)), for: .touchUpInside)
        
        let bottomButtonsStacksView = UIStackView(arrangedSubviews: [scanQRButton, signInButton])
        scrollView.addSubview(bottomButtonsStacksView)
        bottomButtonsStacksView.axis = .horizontal
        bottomButtonsStacksView.distribution = .fillEqually
        bottomButtonsStacksView.spacing = 30
        
        bottomButtonsStacksView.anchor(inputFieldsStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 60, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        
        scrollView.addSubview(skipButton)
        skipButton.anchor(bottomButtonsStacksView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 25)
    }
}
