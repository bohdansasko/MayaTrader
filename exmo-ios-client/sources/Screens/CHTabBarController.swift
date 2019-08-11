//
//  CHTabBarController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/10/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHTabBarController: UITabBarController {
    fileprivate var noInternetView: NoInternetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeOnInternetConnectionNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - No internet connection

private extension CHTabBarController {
    
    func subscribeOnInternetConnectionNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showNoInternetView),
            name: InternetReachabilityNotification.reachable.name)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideNoInternetView),
            name: InternetReachabilityNotification.notReachable.name)
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
