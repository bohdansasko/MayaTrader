//
//  IAPViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class SubscriptionsViewController: ExmoUIViewController {
    var output: SubscriptionsViewOutput!

    let exImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icEXMobile")
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let subscriptionsView = ComparisonSubscriptionsView()
    let underTableLabel = SubscriptionsViewController.getLabel(text: "**Get free 2 month with Pro subscription", textAlignment: .left, fontSize: 12)
    let buyLitePackageButton = SubscriptionsViewController.getButton(text: "Lite", icName: "icSmallBlueButton")
    let buyProPackageButton = SubscriptionsViewController.getButton(text: "Pro", icName: "icSmallBlueButton")
    let restoreSubscriptionsButton = SubscriptionsViewController.getButton(text: "Restore", icName: "icSmallGrayButton")

    let closeButton: UIButton = {
        let icon = UIImage(named: "icWalletClose")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setImage(icon, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        output.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoader()
        output.viewWillAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }
}

extension SubscriptionsViewController: SubscriptionsViewInput {
    func showAlert(msg: String) {
        hideLoader()
        showOkAlert(title: titleNavBar!, message: msg, onTapOkButton: nil)
    }
    
    func updateTable(with items: [SubscriptionsCellModel]) {
        hideLoader()
        subscriptionsView.datasource = SubscriptionsDatasource(items: items)
    }
    
    func hideLoaderActivity() {
        hideLoader()
    }
}


// MARK: help for UI
extension SubscriptionsViewController {
    private static func getLabel(text: String, textAlignment: NSTextAlignment, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = textAlignment
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: fontSize)
        return label
    }

    private static func getButton(text: String, icName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: icName), for: .normal)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .medium, fontSize: 16)
        return button
    }
}

extension SubscriptionsViewController {
    @objc
    func onTouchBuyLitePackageButton(_ sender: UIButton) {
        showLoader()
        output.onTouchButtonBuyLitePackage()
    }
    
    @objc
    func onTouchBuyProPackageButton(_ sender: UIButton) {
        showLoader()
        output.onTouchButtonBuyProPackage()
    }
    
    @objc
    func onTouchRestorePackageButton(_ sender: UIButton) {
        showLoader()
        output.onTouchButtonRestorePurchases()
    }
    
    @objc
    func onTouchCloseButton(_ sender: UIButton) {
        output.onTouchButtonClose()
    }
}

// MARK: setup UI
extension SubscriptionsViewController {
    func setupViews() {
        titleNavBar = "Subscriptions"

        setupExImage();
        setupTableView()

        view.addSubview(underTableLabel)
        underTableLabel.anchor(
                subscriptionsView.bottomAnchor, left: view.leftAnchor,
                bottom: nil, right: view.rightAnchor,
                topConstant: 5, leftConstant: 10,
                bottomConstant: 0, rightConstant: 10,
                widthConstant: 0, heightConstant: 20)

        setupManageSubscriptionsButtons()

        closeButton.addTarget(self, action: #selector(onTouchCloseButton(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    func setupExImage() {
        view.addSubview(exImage)
        exImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        exImage.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
    }

    func setupTableView() {
        view.addSubview(subscriptionsView)
        subscriptionsView.anchor(
            exImage.bottomAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            topConstant: 30, leftConstant: 0,
            bottomConstant: 0, rightConstant: 0,
            widthConstant: 0, heightConstant: 310)

        subscriptionsView.datasource = SubscriptionsDatasource(items: [])
    }
    
    func setupManageSubscriptionsButtons() {
        let stackButtons = UIStackView(arrangedSubviews: [
            buyLitePackageButton,
            buyProPackageButton,
            restoreSubscriptionsButton
        ])
        view.addSubview(stackButtons)
        stackButtons.anchor(
                underTableLabel.bottomAnchor, left: underTableLabel.leftAnchor,
                bottom: nil, right: underTableLabel.rightAnchor,
                topConstant: 20, leftConstant: 0,
                bottomConstant: 0, rightConstant: 0,
                widthConstant: 0, heightConstant: 42)
        stackButtons.axis = .horizontal
        stackButtons.distribution = .fillProportionally
        stackButtons.spacing = 15
        
        buyLitePackageButton.addTarget(self, action: #selector(onTouchBuyLitePackageButton(_:)), for: .touchUpInside)
        buyProPackageButton.addTarget(self, action: #selector(onTouchBuyProPackageButton(_:)), for: .touchUpInside)
        restoreSubscriptionsButton.addTarget(self, action: #selector(onTouchRestorePackageButton(_:)), for: .touchUpInside)
    }
}
