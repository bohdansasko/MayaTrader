//
//  IAPViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class SubscriptionsViewController: ExmoUIViewController {
    let exImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icEXMobile")
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let underExLabel: UILabel = {
        let label = UILabel()
        label.text = "EXMobile subscriptions"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 18)
        return label
    }()
    
    let underTableLabel: UILabel = {
        let label = UILabel()
        label.text = "**Get free 2 month with Pro subscription"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 12)
        return label
    }()

    lazy var subsriptionsView = ComparisonSubscriptionsView()
    
    var buyLitePackageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lite", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "icSmallBlueButton"), for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .medium, fontSize: 16)
        return button
    }()
    
    var buyProPackageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pro", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "icSmallBlueButton"), for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .medium, fontSize: 16)
        return button
    }()
    
    var restoreSubscriptionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "icSmallGrayButton"), for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .medium, fontSize: 16)
        return button
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        return button
    }()

    let items: [SubscriptionsCellModel] = [
        SubscriptionsCellModel(name: "Max Alerts", forFree: 0, forLite: 10, forPro: 25),
        SubscriptionsCellModel(name: "Watchlist Max Pairs", forFree: 5, forLite: 10, forPro: 50),
        SubscriptionsCellModel(name: "Advertisement", forFree: true, forLite: false, forPro: false),
        SubscriptionsCellModel(name: "Free upcoming features", forFree: false, forLite: false, forPro: true),
        SubscriptionsCellModel(name: "Support", forFree: true, forLite: true, forPro: true),
        SubscriptionsCellModel(name: "Price/month", forFree: false, forLite: "$0.99", forPro: false),
        SubscriptionsCellModel(name: "Price/year", forFree: false, forLite: false, forPro: "$9.99")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(exImage)
        exImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        exImage.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(underExLabel)
        underExLabel.anchor(exImage.bottomAnchor, left: view.layoutMarginsGuide.leftAnchor, bottom: nil, right: view.layoutMarginsGuide.rightAnchor, topConstant: 10, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 30)

        setupTableView()
        
        view.addSubview(underTableLabel)
        underTableLabel.anchor(subsriptionsView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 20)
        
        setupManageSubscriptionsButtons()
        
        closeButton.addTarget(self, action: #selector(onTouchCloseButton(_:)), for: .touchUpInside)
    }
    
    override func shouldUseGlow() -> Bool {
        return false
    }
}

extension SubscriptionsViewController {
    @objc
    func onTouchBuyLitePackageButton(_ sender: UIButton) {
        IAPService.shared.purchase(product: .litePackage)
    }
    
    @objc
    func onTouchBuyProPackageButton(_ sender: UIButton) {
        IAPService.shared.purchase(product: .proPackage)
    }
    
    @objc
    func onTouchRestorePackageButton(_ sender: UIButton) {
        IAPService.shared.restorePurchases()
    }
    
    @objc
    func onTouchCloseButton(_ sender: UIButton) {
        close()
    }
}

extension SubscriptionsViewController {
    func setupTableView() {
        view.addSubview(subsriptionsView)
        subsriptionsView.anchor(
            underExLabel.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            topConstant: 10, leftConstant: 0,
            bottomConstant: 0, rightConstant: 0,
            widthConstant: 0, heightConstant: 310)
        subsriptionsView.datasource = SubscriptionsDatasource(items: items)
    }
    
    func setupManageSubscriptionsButtons() {
        let stackButtons = UIStackView(arrangedSubviews: [
            buyLitePackageButton,
            buyProPackageButton,
            restoreSubscriptionsButton
            ])
        view.addSubview(stackButtons)
        stackButtons.anchor(underTableLabel.bottomAnchor, left: underTableLabel.leftAnchor, bottom: nil, right: underTableLabel.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 42)
        stackButtons.axis = .horizontal
        stackButtons.distribution = .fillProportionally
        stackButtons.spacing = 15
        
        buyLitePackageButton.addTarget(self, action: #selector(onTouchBuyLitePackageButton(_:)), for: .touchUpInside)
        buyProPackageButton.addTarget(self, action: #selector(onTouchBuyProPackageButton(_:)), for: .touchUpInside)
        restoreSubscriptionsButton.addTarget(self, action: #selector(onTouchRestorePackageButton(_:)), for: .touchUpInside)
    }
}
