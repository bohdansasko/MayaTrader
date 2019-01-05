//
//  AppDelegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/20/18.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import Firebase

enum IPhoneModel: Int {
    case None = 0
    case Five
    case SixOrSevenEight
    case SixSevenEightPlus
    case X
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        setupAdMob()
        setupWindow()
        callStoreReview()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        AppDelegate.dbController.saveContext()
    }
}

extension AppDelegate {
    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarModuleInitializer().tabBarController
        window?.windowLevel = UIWindow.Level.normal
        window?.makeKeyAndVisible()
        
        UITextField.appearance().keyboardAppearance = .dark
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    func setupAdMob() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Use Firebase library to configure APIs
        if let url = Bundle.main.url(forResource: AdvertisingValues.CONFIG_NAME.rawValue, withExtension: AdvertisingValues.CONFIG_EXT.rawValue),
            let myDict = NSDictionary(contentsOf: url) as? [String:Any] {
            guard let adsAppId = myDict[AdvertisingValues.AD_UNIT_ID_FOR_BANNER_TEST.rawValue] as? String else {
                return
            }
            GADMobileAds.configure(withApplicationID: adsAppId)
            print("GADMobileAds.configure(withApplicationID: \(adsAppId)")
        }
        
    }
    
    func callStoreReview() {
        StoreReviewHelper.incrementAppOpenedCount()
        StoreReviewHelper.checkAndAskForReview()
    }
}

//
// @MARK: notification controller
//
class NotificationController {
    func postBroadcastMessage(name: NSNotification.Name, data: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: data)
    }

    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

//
// @MARK: static instances
//
extension AppDelegate {
    static let session = Session()
    static let exmoController = ExmoAccountController()
    static let roobikController = RoobikApiHandler()
    static let notificationController = NotificationController()
    static let dbController = CoreDataManager()
    static var cacheController = CacheManager()
}

//
// @MARK: static methods
//
extension AppDelegate {
    static func isIPhone(model: IPhoneModel) -> Bool {
        return getIPhoneModel() == model
    }
    
    static func getIPhoneModel() -> IPhoneModel {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return .None
        }

        switch (UIScreen.main.nativeBounds.height) {
        case 1136: return .Five
        case 1334: return .SixOrSevenEight
        case 2208: return .SixSevenEightPlus
        case 2436: return .X
          default: return .None
        }
    }
}
