//
//  IAPViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class IAPModuleInitializer {
    lazy var viewController = IAPViewController()
    init() {
        // do nothing
    }
}

class IAPViewController: ExmoUIViewController {
    var buyLitePackageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lite package", for: .normal)
        return button
    }()
    
    var buyProPackageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pro package", for: .normal)
        return button
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark
        
        setupViews()
    }
    
    func setupViews() {
        buyLitePackageButton.addTarget(self, action: #selector(onTouchBuyLitePackageButton(_:)), for: .touchUpInside)
        buyProPackageButton.addTarget(self, action: #selector(onTouchBuyProPackageButton(_:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(onTouchCloseButton(_:)), for: .touchUpInside)
        
        let stackButtons = UIStackView(arrangedSubviews: [
            buyLitePackageButton,
            buyProPackageButton,
            closeButton
        ])
        view.addSubview(stackButtons)
        stackButtons.anchorCenterSuperview()
        stackButtons.axis = .vertical
        stackButtons.spacing = 20
    }
    
    @objc
    func onTouchBuyLitePackageButton(_ sender: UIButton) {
        IAPService.shared.purchase(product: .litePackage)
    }
    
    @objc
    func onTouchBuyProPackageButton(_ sender: UIButton) {
        IAPService.shared.purchase(product: .proPackage)
    }
    
    @objc
    func onTouchCloseButton(_ sender: UIButton) {
        close()
    }
}
