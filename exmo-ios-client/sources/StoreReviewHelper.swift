//
// Created by Bogdan Sasko on 12/30/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    private init() {
        // do nothing
    }

    static func incrementAppOpenedCount() {
        var appOpenCount = Defaults.getCountOpenedApp()
        appOpenCount += 1
        Defaults.setCountAppOpened(appOpenCount)
    }

    static func resetAppOpenedCount() {
        Defaults.setCountAppOpened(0)
    }

    static func checkAndAskForReview() {
        let appOpenCount = Defaults.getCountOpenedApp()
        if appOpenCount == 0 {
            Defaults.setCountAppOpened(1)
            return
        }

        if appOpenCount%100 == 0 || appOpenCount == 6 {
            requestReview()
        } else {
            print("App run count is : \(appOpenCount)")
        }
    }

    static func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            print("Fallback on earlier versions")
            print("Try any other 3rd party or manual method here.")
        }
    }
}
