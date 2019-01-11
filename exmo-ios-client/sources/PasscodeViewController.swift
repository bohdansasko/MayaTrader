//
//  PasscodeViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/1/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import SmileLock

class PasswordModuleConfigurator {
    let passcodeVC = PasscodeViewController()
    let navigationVC: UINavigationController!
    init() {
        navigationVC = UINavigationController(rootViewController: passcodeVC)
    }
}

class PasscodeViewController: ExmoUIViewController {
    enum PasscodeState {
        case lock
        case confirmLock
        case unlock
        
        var description: String? {
            switch self {
            case .lock: return "To enable the Security please choose a 4-digit code"
            case .confirmLock: return "Please confirm your 4-digit code"
            case .unlock: return "Enter EXMobile passcode"
            }
        }
    }
    
    var onClose: VoidClosure?
    var passcodeState = PasscodeState.lock
    var enteredPasscodeForLock: String?
    
    var buttonClose: UIButton = {
        let image = UIImage(named: "icBack")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return button
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "To enable the Passcode please choose a 4-digit code"
        label.numberOfLines = 0
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 14)
        return label
    }()
    
    var passwordStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    // MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("*️⃣ active passcode = \(Defaults.getPasscode())")
        passcodeState = Defaults.isPasscodeActive() ? .unlock : .lock
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if passcodeState == .unlock {
            passwordContainerView.touchAuthentication()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onClose?()
    }
    
    @objc
    func onTouchButtonClose(_ sender: UIButton) {
        close()
    }
}

extension PasscodeViewController {
    func setupViews() {
        titleNavBar = "Security"
        view.backgroundColor = .black
        
        buttonClose.isHidden = passcodeState == .unlock
        descriptionLabel.text = passcodeState.description
        
        setupCloseButton()
        setupPasswordStackView()
        setupPasswordView()
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(
            view.layoutMarginsGuide.topAnchor,
            left: passwordStackView.leftAnchor,
            bottom: passwordStackView.topAnchor,
            right: passwordStackView.rightAnchor,
            topConstant: 0,
            leftConstant: 0,
            bottomConstant: 25,
            rightConstant: 0,
            widthConstant: 0,
            heightConstant: 0)
    }
    
    private func setupCloseButton() {
        buttonClose.addTarget(self, action: #selector(onTouchButtonClose(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonClose)
    }
    
    func setupPasswordStackView() {
        view.addSubview(passwordStackView)
        passwordStackView.anchorCenterSuperview()
        passwordStackView.axis = .vertical
        passwordStackView.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: 50).isActive = true
        passwordStackView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: 50).isActive = true
    }
    
    private func setupPasswordView() {
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        passwordContainerView.touchAuthenticationEnabled = true
        passwordContainerView.deleteButtonLocalizedTitle = "Delete"
        
        // customize password UI
        passwordContainerView.tintColor = .lightGray
        passwordContainerView.highlightedColor = .white
        
        passwordContainerView.passwordInputViews.forEach {
            $0.textColor = .white
            $0.borderColor = .lightGray
            $0.circleBackgroundColor = .black
            $0.highlightBackgroundColor = UIColor.white.withAlphaComponent(0.2)
            $0.labelFont = UIFont.getExo2Font(fontType: .semibold, fontSize: 26)
        }
        
        passwordContainerView.deleteButton.setTitleColor(.white, for: UIControl.State())
        passwordContainerView.deleteButton.titleLabel?.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 16)
    }
}

extension PasscodeViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        if validation(input) {
            switch passcodeState {
            case .lock:
                passcodeState = .confirmLock
                enteredPasscodeForLock = input
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.descriptionLabel.text = self.passcodeState.description
                    passwordContainerView.clearInput()
                })
            case .confirmLock, .unlock:
                validationSuccess()
            }
        } else {
            switch passcodeState {
            case .confirmLock:
                passcodeState = .lock
                enteredPasscodeForLock = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.descriptionLabel.text = self.passcodeState.description
                    passwordContainerView.clearInput()
                })
            case .unlock:
                validationFail()
            default: break
            }
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            self.validationSuccess()
        } else {
            passwordContainerView.clearInput()
        }
    }
}

private extension PasscodeViewController {
    func validation(_ input: String) -> Bool {
        switch passcodeState {
        case .lock:
            return true
        case .confirmLock:
            guard let passcode = enteredPasscodeForLock else { return false }
            return input == passcode
        case .unlock:
            return input == Defaults.getPasscode()
        }
    }
    
    func validationSuccess() {
        if passcodeState == .confirmLock {
            print("*️⃣ success! passcode = \(enteredPasscodeForLock ?? "")")
            Defaults.savePasscode(enteredPasscodeForLock!)
            showAlert(title: "Security enabled!",
                      message: "Now your passcode lock will be asked every time when you open EXMobile",
                      closure: { [weak self] in
                        self?.dismiss(animated: true, completion: nil)
                      }
            )
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        passwordContainerView.wrongPassword()
    }
}
