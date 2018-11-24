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
        return aiv
    }()
    
    func updateNavigationBar(shouldHideNavigationBar: Bool) {
        let dummyImage: UIImage? = shouldHideNavigationBar ? UIImage() : nil
        
        self.navigationController?.navigationBar.setBackgroundImage(dummyImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = dummyImage
        self.navigationController?.navigationBar.isTranslucent = shouldHideNavigationBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar(shouldHideNavigationBar: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        updateNavigationBar(shouldHideNavigationBar: false)
    }
    
}
