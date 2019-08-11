//
// Created by Bogdan Sasko on 12/30/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import StoreKit

final class CHAppStoreReviewManager: NSObject {
    
    private override init() {
        super.init()
    }
    static let shared = CHAppStoreReviewManager()

}

// MARK: - Handle app count opened

extension CHAppStoreReviewManager {
    
    func incrementAppOpenedCount() {
        var appOpenCount = Defaults.getCountOpenedApp()
        appOpenCount += 1
        Defaults.setCountAppOpened(appOpenCount)
    }
    
    func resetAppOpenedCount() {
        Defaults.setCountAppOpened(0)
    }
    
}

// MARK: - Review

extension CHAppStoreReviewManager {
    
    func checkAndAskForReview() {
        let appOpenCount = Defaults.getCountOpenedApp()
        if appOpenCount == 0 {
            Defaults.setCountAppOpened(1)
            return
        }
        
        if (appOpenCount % 100 == 0) || (appOpenCount == 6) {
            requestReview()
        } else {
            print("App run count is : \(appOpenCount)")
        }
    }
    
    func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            print("Fallback on earlier versions")
            print("Try any other 3rd party or manual method here.")
        }
    }
    
}

// MARK: - UIApplicationDelegate

extension CHAppStoreReviewManager: UIApplicationDelegate {
    
    @discardableResult
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        incrementAppOpenedCount()
        checkAndAskForReview()
        return true
    }
    
}
