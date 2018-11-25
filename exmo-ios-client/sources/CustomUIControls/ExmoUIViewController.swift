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
    
    func updateNavigationBar(shouldHideNavigationBar: Bool) {
        let dummyImage: UIImage? = shouldHideNavigationBar ? UIImage() : nil
        
        self.navigationController?.navigationBar.setBackgroundImage(dummyImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = dummyImage
        self.navigationController?.navigationBar.isTranslucent = shouldHideNavigationBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar(shouldHideNavigationBar: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationBar(shouldHideNavigationBar: false)
    }
    
    func showOkAlert(title: String, message: String,  onTapOkButton: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            onTapOkButton?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoader() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func hideLoader() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }

}
