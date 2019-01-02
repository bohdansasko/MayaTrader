//
//  ExmoUIViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class ExmoUIViewController: UIViewController {
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        aiv.isHidden = true
        return aiv
    }()
    
    var glowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icWalletGlow")
        imageView.contentMode = .center
        return imageView
    }()

    var titleNavBar: String? {
        didSet {
            setupTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupInitialViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar(shouldHideNavigationBar: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationBar(shouldHideNavigationBar: false)
    }
    
    func shouldUseGlow() -> Bool {
        return true
    }
    
    func setTouchEnabled(_ isTouchEnabled: Bool) {
        // do nothing
    }
    
    func showAlert(title: String, message: String, closure: VoidClosure?) {
        hideLoader()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            closure?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ExmoUIViewController {
    func setupInitialViews() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
        
        if shouldUseGlow() {
            view.addSubview(glowImage)
            glowImage.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -90, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
    }
    
    private func setupTitle() {
        let titleView = UILabel()
        titleView.text = titleNavBar
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
}

extension ExmoUIViewController {
    func updateNavigationBar(shouldHideNavigationBar: Bool) {
        if !shouldUseGlow() {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            return
        }
        
        let dummyImage: UIImage? = shouldHideNavigationBar ? UIImage() : nil
        
        self.navigationController?.navigationBar.setBackgroundImage(dummyImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = dummyImage
        self.navigationController?.navigationBar.isTranslucent = shouldHideNavigationBar
    }
    
    func showOkAlert(title: String, message: String,  onTapOkButton: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            onTapOkButton?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ExmoUIViewController {
    func showLoader() {
        if !isLoaderShowing() {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }
    }
    
    func hideLoader() {
        if isLoaderShowing() {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }

    func isLoaderShowing() -> Bool {
        return activityIndicatorView.isHidden == false
    }
}
