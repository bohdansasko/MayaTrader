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
import UserNotifications
import KeychainSwift

enum IPhoneModel: Int {
    case none = 0
    case five
    case sixOrSevenEight
    case sixSevenEightPlus
    case x
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppDelegate.vinsoAPI.addConnectionObserver(self)
        
        setupFabric()
        setupAdMob()
        setupWindow()
        registerForRemoteNotifications()
        callStoreReview()
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AppDelegate.vinsoAPI.disconnect()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppDelegate.vinsoAPI.establishConnect()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

// MARK: handle connection to Vinso Server
extension AppDelegate: VinsoAPIConnectionDelegate  {
    func onDidLogin() {
        if let apnsDeviceToken = KeychainSwift().get(KeychainDefaultKeys.apnsDeviceToken.rawValue) {
            AppDelegate.vinsoAPI.registerAPNSDeviceToken(apnsDeviceToken)
        }
    }
}

// MARK: handle registering APNs
extension AppDelegate {
    func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: {
            settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Authorized push notifications by user")
                self.registerPushNotifications()
            case .denied:
                print("show user view explaining why it's better to enable")
                self.registerPushNotifications()
            case .notDetermined:
                self.requestPushNotifications(center: center, {
                    isGranted in
                    if isGranted {
                        self.registerPushNotifications()
                    }
                    print("User haven't granted app for get APNS")
                })
            case .provisional:
                print("App provisional post push notifications")
            }
        })
    }
    
    func registerPushNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    fileprivate func requestPushNotifications(center: UNUserNotificationCenter, _ result: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            print("APNs => granted = \(granted), error = \(error?.localizedDescription ?? "")")
            result(granted)
        })
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map({ String(format: "%02.2hhx", $0) }).joined()
        print("APNs => device token = \(token)")
        KeychainSwift().set(token, forKey: KeychainDefaultKeys.apnsDeviceToken.rawValue)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs => error = \(error)")
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
    
    func setupFabric() {
        Fabric.with([Crashlytics.self])
    }

    func setupAdMob() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Use Firebase library to configure APIs
        if let url = Bundle.main.url(forResource: AdvertisingValues.googleConfigPlist.rawValue, withExtension: AdvertisingValues.googleConfigExt.rawValue),
            let myDict = NSDictionary(contentsOf: url) as? [String:Any] {
            guard let adsAppId = myDict[AdvertisingValues.adUnitIDForBannerTest.rawValue] as? String else {
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
// MARK: notification controller
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
// MARK: static instances
//
extension AppDelegate {
    static let exmoController = ExmoAccountController()
    static let vinsoAPI = VinsoAPI.shared
    static let notificationController = NotificationController()
}

//
// MARK: static methods
//
extension AppDelegate {
    static func isIPhone(model: IPhoneModel) -> Bool {
        return getIPhoneModel() == model
    }
    
    static func getIPhoneModel() -> IPhoneModel {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return .none
        }

        switch (UIScreen.main.nativeBounds.height) {
        case 1136: return .five
        case 1334: return .sixOrSevenEight
        case 2208: return .sixSevenEightPlus
        case 2436: return .x
          default: return .none
        }
    }
}
