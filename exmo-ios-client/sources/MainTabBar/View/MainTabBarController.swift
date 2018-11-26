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
    
    var selectedTabIndicatorImage: UIImageView!
    var containerInitial: [NSObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.index(of: item) else { return }
        updateIndicatorPosition(index: index)
    }
    
    func updateIndicatorPosition(index: Int) {
        let count = 5
        let width = CGFloat(self.tabBar.frame.width) / CGFloat(count)
        let posX = width * CGFloat(index) + CGFloat(width/2)
        selectedTabIndicatorImage.center.x = CGFloat(posX)
    }
}

// @MARK: setup UI
extension MainTabBarController {
    func setupViews() {
        setupTabBarItems()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        
        addSelectedTabIndicator()
        updateIndicatorPosition(index: 0)
    }
    
    private func setupTabBarItems() {
        let watchlistInitializer = WatchlistFavouriteCurrenciesModuleInitializer()
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
    
    private func addSelectedTabIndicator() {
        selectedTabIndicatorImage = UIImageView(image: #imageLiteral(resourceName: "icTabbarSelected"))
        selectedTabIndicatorImage.translatesAutoresizingMaskIntoConstraints = true
        let icOffset: CGFloat = AppDelegate.isIPhone(model: .X) ? 22 : 10
        selectedTabIndicatorImage.center = CGPoint(x: 0, y: self.tabBar.bounds.maxY - icOffset)
        selectedTabIndicatorImage.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        self.tabBar.addSubview(selectedTabIndicatorImage)
    }
}

// @MARK: MainTabBarInput
extension MainTabBarController: MainTabBarViewInput {
    // do nothing
}
