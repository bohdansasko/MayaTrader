//
//  AlertsAlertsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class AlertsViewController: ExmoUIViewController, AlertsViewInput {
    var output: AlertsViewOutput!
    var listView: AlertsListView!
    
    var currencySettingsBtn: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icWalletOptions"),
                               style: .done,
                               target: nil,
                               action: nil)
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavBar = "Alerts"
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewIsReady()
    }
    
    @objc func showViewCreateOrder(_ sender: Any) {
        print("showViewCreateOrder")
    }
}

// MARK: setup initial UI state for view controller
extension AlertsViewController {
    func setupViews() {
        currencySettingsBtn.target = self
        currencySettingsBtn.action = #selector(showViewCreateOrder(_ :))
        
        view.addSubview(listView)
        
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = currencySettingsBtn
    }
    
    private func setupConstraints() {
        listView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
