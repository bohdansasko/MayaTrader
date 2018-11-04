//
//  MainTabBarController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/4/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var selectedTabIndicatorImage: UIImageView!
    
    var containerInitial: [NSObject] = []
    
    override func viewDidLoad() {
        self.delegate = self as? UITabBarControllerDelegate
        
        super.viewDidLoad()
        
        setupTabBarItems()
        setupTabBar()
        
        if AppDelegate.session.isUserWasLoggedInExmoAccount() {
            AppDelegate.session.exmoLoginWithCacheData()
        }
        AppDelegate.session.roobikLogin()
    }
    
    private func setupTabBarItems() {
        let watchlistInitializer = WatchlistFavouriteCurrenciesModuleInitializer()
        let menuInitializer = MenuModuleInitializer()
        
        viewControllers = [
            UINavigationController(rootViewController: watchlistInitializer.viewController),
            UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "OrdersNavigationController"),
            UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "WalletNavigationController"),
            UIStoryboard(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "AlertsNavigationController"),
            UINavigationController(rootViewController: menuInitializer.viewController)
        ]
        
        guard let watchlistTabBarItem = tabBar.items?[0] else { return }
        watchlistTabBarItem.image = UIImage(named: "icTabbarWatchlist")
        watchlistTabBarItem.selectedImage = UIImage(named: "icTabbarWatchlistSelected")
        
        guard let menuTabBarItem = tabBar.items?[4] else { return }
        menuTabBarItem.image = UIImage(named: "icTabbarMenu")
        menuTabBarItem.selectedImage = UIImage(named: "icTabbarMenuSelected")
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        
        addSelectedTabIndicator()
        updateIndicatorPosition(index: 0)
    }
    
    private func addSelectedTabIndicator() {
        selectedTabIndicatorImage = UIImageView(image: #imageLiteral(resourceName: "icTabbarSelected"))
        selectedTabIndicatorImage.translatesAutoresizingMaskIntoConstraints = true
        let icOffset: CGFloat = AppDelegate.isIPhone(model: .X) ? 22 : 10
        selectedTabIndicatorImage.center = CGPoint(x: 0, y: self.tabBar.bounds.maxY - icOffset)
        selectedTabIndicatorImage.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        self.tabBar.addSubview(selectedTabIndicatorImage)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.index(of: item) else { return }
        updateIndicatorPosition(index: index)
    }
    
    private func updateIndicatorPosition(index: Int) {
        let count = 5
        let width = CGFloat(self.tabBar.frame.width) / CGFloat(count)
        let posX = width * CGFloat(index) + CGFloat(width/2)
        selectedTabIndicatorImage.center.x = CGFloat(posX)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // do nothing
    }
}
