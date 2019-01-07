//
//  MainTabBarController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/4/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var output: MainTabBarViewOutput!
    
    var containerInitial: [NSObject] = []
    var isApplicationWasInForeground = true
    var isPasscodeActive = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotificationListeners()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsReady()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainTabBarController {
    func setupNotificationListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(onApplicationEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onApplicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
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

extension MainTabBarController {
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
        let watchlistInitializer = WatchlistModuleInitializer()
        let orderInitializer = OrdersModuleInitializer()
        let walletInitializer = WalletModuleInitializer()
        let alertsInitializer = AlertsModuleInitializer()
        let menuInitializer = MenuModuleInitializer()
        
        viewControllers = [
            UINavigationController(rootViewController: watchlistInitializer.viewController),
            UINavigationController(rootViewController: orderInitializer.viewController),
            UINavigationController(rootViewController: walletInitializer.viewController),
            UINavigationController(rootViewController: alertsInitializer.viewController),
            UINavigationController(rootViewController: menuInitializer.viewController)
        ]

        let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.getExo2Font(fontType: .Regular, fontSize: 18)
        ]
        viewControllers?.forEach({ $0.navigationController?.navigationBar.titleTextAttributes = titleAttributes })

        let iconsNamesWithIndices = [
            0: "icTabbarWatchlist",
            1: "icTabbarOrders",
            2: "icTabbarWallet",
            3: "icTabbarAlerts",
            4: "icTabbarMenu"
        ]
        for (iconIndex, iconNameNormalState) in iconsNamesWithIndices {
            guard let watchlistTabBarItem = tabBar.items?[iconIndex] else { continue }
            watchlistTabBarItem.image = UIImage(named: iconNameNormalState)
            watchlistTabBarItem.selectedImage = UIImage(named: "\(iconNameNormalState)Selected")
        }
    }
}

// @MARK: MainTabBarInput
extension MainTabBarController: MainTabBarViewInput {
    // do nothing
}
