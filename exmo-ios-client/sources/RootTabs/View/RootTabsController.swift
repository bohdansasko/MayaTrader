//
//  RootTabsController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/4/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class RootTabsController: UITabBarController {
    var output: RootTabsViewOutput!
    
    var isApplicationWasInForeground = true
    var isPasscodeActive = false
    
    deinit {
        unsubscribeNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializingFinished() {
        subscribeOnNotifications()
        setupViews()
        output.viewDidLoad()
    }
}

// MARK: RootTabsInput
extension RootTabsController: RootTabsViewInput {
    // do nothing
}

extension RootTabsController {
    func subscribeOnNotifications() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onApplicationEnterForeground),
                name: UIApplication.willEnterForegroundNotification,
                object: nil)

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onApplicationDidBecomeActive),
                name: UIApplication.didBecomeActiveNotification,
                object: nil)
    }
    
    func unsubscribeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onApplicationEnterForeground() {
        print("onApplicationEnterForeground")
        isApplicationWasInForeground = true
    }

    @objc func onApplicationDidBecomeActive() {
        print("onApplicationDidBecomeActive")
        if !isPasscodeActive && isApplicationWasInForeground && Defaults.isPasscodeActive() {
            print("show PasswordModuleConfigurator")
            isPasscodeActive = true
            let module = PasswordModuleConfigurator()
            module.passcodeVC.onClose = {
                [weak self] in
                self?.isPasscodeActive = false
            }
            present(module.navigationVC, animated: true, completion: nil)
        }

        isApplicationWasInForeground = false
    }
}

extension RootTabsController {
    func setupViews() {
        setupTabBarItems()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        tabBar.itemPositioning = .centered
    }
    
    private func setupTabBarItems() {
        let modules: [ModuleInitializer] = [
            WatchlistModuleInitializer(),
            OrdersModuleInitializer(),
            WalletModuleInitializer(),
            AlertsModuleInitializer(),
            MenuModuleInitializer()
        ]
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.getExo2Font(fontType: .regular, fontSize: 18)
        ]

        viewControllers = modules.map({
            module in
            let navCtrl = UINavigationController(rootViewController: module.viewController)
            navCtrl.navigationBar.titleTextAttributes = titleAttributes
            return navCtrl
        })

        // MARK: setup tab bar icons
        let tabBarIcons = [
            "icTabbarWatchlist",
            "icTabbarOrders",
            "icTabbarWallet",
            "icTabbarAlerts",
            "icTabbarMenu"
        ]
        
        for iconIndex in (0..<tabBarIcons.count) {
            let iconNameNormalState = tabBarIcons[iconIndex]
            guard let watchlistTabBarItem = tabBar.items?[iconIndex] else { continue }
            watchlistTabBarItem.image = UIImage(named: iconNameNormalState)
            watchlistTabBarItem.selectedImage = UIImage(named: "\(iconNameNormalState)Selected")
        }

        // MARK: preload navigation controllers
        for viewController in viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
    }
}