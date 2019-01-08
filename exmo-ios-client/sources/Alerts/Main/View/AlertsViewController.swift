//
//  AlertsAlertsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AlertsViewController: ExmoUIViewController {
    enum DeleteAction: Int {
        case All = 0
        case Active
        case Inactive
    }
    var output: AlertsViewOutput!
    var listView: AlertsListView!
    var bannerView: GADBannerView!
    var pickerViewManager: DarkeningPickerViewManager!

    var btnCreateAlert: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icNavbarPlus"),
                               style: .done,
                               target: nil,
                               action: nil)
    }()

    var buttonDeleteAlers: UIButton = {
        let image = UIImage(named: "icNavbarTrash")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return button
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavBar = "Alerts"
        setupViews()
        output.viewIsReady()
        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    @objc func showViewCreateOrder(_ sender: Any) {
        output.showFormCreateAlert()
    }

    @objc func onTouchButtonDelete(_ sender: Any) {
        pickerViewManager.showPickerViewWithDarkening()
    }

    private func onSelectedDeleteAction(actionIndex: Int) {
        print("onSelectedDeleteAction: \(actionIndex)")

        switch (actionIndex) {
        case DeleteAction.All.rawValue: print("Alerts => delete all")
        case DeleteAction.Active.rawValue: print("Alerts => delete Active")
        case DeleteAction.Inactive.rawValue: print("Alerts => delete Inactive")
        default: print("Alerts => selected index out of range")
            break
        }
    }
}

extension AlertsViewController: AlertsViewInput {
    func update(_ alerts: [Alert]) {
        listView.alerts.set(alerts)
        listView.invalidate()
    }

    func updateAlert(_ alert: Alert) {
        listView.updateAlert(alertItem: alert)
    }

    func deleteAlert(withId id: Int) {
        listView.deleteById(alertId: id)
    }
}
// MARK: setup initial UI state for view controller
extension AlertsViewController {
    func setupViews() {
        setupNavigationBar()

        pickerViewManager.setCallbackOnSelectAction(callback: {
            [weak self] actionIndex in
            self?.onSelectedDeleteAction(actionIndex: actionIndex)
        })

        setupListView()
        setupBannerView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false

        buttonDeleteAlers.addTarget(self, action: #selector(onTouchButtonDelete(_:)), for: .touchUpInside)
        let navButtonDeleteAlers = UIBarButtonItem(customView: buttonDeleteAlers)
        navigationItem.leftBarButtonItem = navButtonDeleteAlers

        btnCreateAlert.target = self
        btnCreateAlert.action = #selector(showViewCreateOrder(_ :))
        navigationItem.rightBarButtonItem = btnCreateAlert
    }
    
    private func setupListView() {
        view.addSubview(listView)
        listView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
    }
    
    func addBannerToView(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        bannerView.anchor(nil, left: view.layoutMarginsGuide.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

}

// @MARK: GADBannerViewDelegate
extension AlertsViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        if let _ = bannerView.superview {
            bannerView.alpha = 0
            UIView.animate(withDuration: 1) {
                bannerView.alpha = 1
                self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -50).isActive = true
            }
        } else {
            addBannerToView(bannerView)
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 0
            self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        }
    }
}
