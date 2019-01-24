//
//  AlertsAlertsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

enum AlertsDeleteAction: Int {
    case active
    case inactive
    case all
}

class AlertsViewController: ExmoUIViewController {
    var output: AlertsViewOutput!
    var listView: AlertsListView!
    var pickerViewManager: DarkeningPickerViewManager!
    var subscriptionPackage: ISubscriptionPackage?

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

    private func onSelectedAlertsDeleteAction(actionIndex: Int) {
        print("onSelectedAlertsDeleteAction: \(actionIndex)")
        guard let action = AlertsDeleteAction(rawValue: actionIndex) else {
            print("Alerts => selected index out of range")
            return
        }

        var alertsForRemove = [Alert]()
        switch (action) {
        case AlertsDeleteAction.all:
            alertsForRemove = listView.alerts.items
            print("Alerts => delete all")
        case AlertsDeleteAction.active:
            alertsForRemove = listView.alerts.filter({ $0.status == AlertStatus.active })
            print("Alerts => delete Active")
        case AlertsDeleteAction.inactive:
            alertsForRemove = listView.alerts.filter({ $0.status == AlertStatus.inactive })
            print("Alerts => delete Inactive")
        }

        output.deleteAlerts(ids: alertsForRemove.map({ $0.id }))
    }
}

extension AlertsViewController: AlertsViewInput {
    func update(_ alerts: [Alert]) {
        listView.alerts.items = alerts
        listView.maxPairs = LimitObjects(amount: alerts.count, max: subscriptionPackage?.maxAlerts ?? 0)
        listView.invalidate()
    }

    func updateAlert(_ alert: Alert) {
        listView.updateAlert(alertItem: alert)
    }

    func deleteAlerts(withIds ids: [Int]) {
        listView.deleteAlerts(ids: ids)
    }

    func setSubscription(_ package: ISubscriptionPackage) {
        print("Alerts: \(#function)")
        subscriptionPackage = package
        if package.isAdsPresent {
            showAdsView(completion: {
                self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -50).isActive = true
            })
        } else {
            hideAdsView(completion: {
                self.listView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            })
        }

        listView.maxPairs = LimitObjects(amount: listView.alerts.count(), max: subscriptionPackage?.maxAlerts ?? 0)
    }

    func showAlert(msg: String) {
        hideLoader()
        showOkAlert(title: titleNavBar!, message: msg, onTapOkButton: nil)
    }
}

// MARK: setup initial UI state for view controller
extension AlertsViewController {
    func setupViews() {
        setupNavigationBar()

        pickerViewManager.setCallbackOnSelectAction(callback: {
            [weak self] actionIndex in
            self?.onSelectedAlertsDeleteAction(actionIndex: actionIndex)
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
        listView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor,
                        bottom: view.bottomAnchor, right: view.rightAnchor,
                        topConstant: 0, leftConstant: 0,
                        bottomConstant: 0, rightConstant: 0,
                        widthConstant: 0, heightConstant: 0)
    }
}
