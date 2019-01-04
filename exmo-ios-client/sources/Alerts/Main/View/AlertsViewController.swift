//
//  AlertsAlertsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AlertsViewController: ExmoUIViewController, AlertsViewInput {
    var output: AlertsViewOutput!
    var listView: AlertsListView!
    var bannerView: GADBannerView!
    
    var btnCreateAlert: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "icNavbarPlus"),
                               style: .done,
                               target: nil,
                               action: nil)
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavBar = "Alerts"
        setupViews()
        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewIsReady()
    }
    
    @objc func showViewCreateOrder(_ sender: Any) {
        output.showFormCreateAlert()
    }
}

// MARK: setup initial UI state for view controller
extension AlertsViewController {
    func setupViews() {
        btnCreateAlert.target = self
        btnCreateAlert.action = #selector(showViewCreateOrder(_ :))
        
        view.addSubview(listView)
        
        setupNavigationBar()
        setupConstraints()
        
        setupBannerView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = btnCreateAlert
    }
    
    private func setupConstraints() {
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
