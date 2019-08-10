//
//  CHTabBarController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/10/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHTabBarController: UITabBarController {
    fileprivate var isPasscodeActive = false
    fileprivate var noInternetView: NoInternetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeOnNotificationApplicationDidEnterBackground()
        subscribeOnInternetConnectionNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - No internet connection

private extension CHTabBarController {
    
    func subscribeOnInternetConnectionNotifications() {
        AppDelegate.notificationController.addObserver(
            self,
            selector: #selector(showNoInternetView),
            name: InternetConnectionManager.StatusNotification.reachable.name)
        AppDelegate.notificationController.addObserver(
            self,
            selector: #selector(hideNoInternetView),
            name: InternetConnectionManager.StatusNotification.notReachable.name)
    }
    
    @objc func showNoInternetView() {
        if noInternetView?.superview == nil {
            noInternetView = NoInternetView()
            noInternetView?.onTouchButtonRefresh = {
                self.noInternetView?.showLoader()
            }
            view.addSubview(noInternetView!)
            noInternetView?.fillSuperview()
        }
    }
    
    @objc func hideNoInternetView() {
        if noInternetView?.superview != nil {
            noInternetView?.removeFromSuperview()
            noInternetView = nil
        }
    }
    
}

// MARK: - Security

private extension CHTabBarController {
    
    func subscribeOnNotificationApplicationDidEnterBackground() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showSecurityViewControllerIfNeeded),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc func showSecurityViewControllerIfNeeded() {
        print("onApplicationEnterForeground")
        if !isPasscodeActive && Defaults.isPasscodeActive() {
            print("show PasswordModuleConfigurator")
            isPasscodeActive = true
            let vc = PasscodeViewController()
            vc.onClose = {
                [weak self] in
                self?.isPasscodeActive = false
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
}
