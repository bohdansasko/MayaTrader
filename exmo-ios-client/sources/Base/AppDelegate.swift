//
//  AppDelegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/20/18.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import RxSwift
import Fabric
import Crashlytics

enum IPhoneModel: Int {
    case none = 0
    case five
    case sixOrSevenEight
    case sixSevenEightPlus
    case ten
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    fileprivate var services: [UIApplicationDelegate] = [
        CHInternetReachabilityManager.shared,
        CHAppStoreReviewManager.shared,
        CHPushNotificationsService.shared,
        CHExmoAuthorizationService.shared,
        CHSecurityService.shared
    ]
    fileprivate let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        setupAdMob()
        
        services.forEach {
            _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }

        UITextField.appearance().keyboardAppearance = .dark
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        VinsoAPI.shared.establishConnection()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        services.forEach{
            _ = $0.applicationDidEnterBackground?(application)
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        services.forEach{
            _ = $0.applicationDidBecomeActive?(application)
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        services.forEach{
            _ = $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        services.forEach{
            _ = $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }

}

// MARK: - Handle connection to Vinso Server

extension AppDelegate: VinsoAPIConnectionDelegate  {

    func onConnectionOpened() {
        if !Defaults.isRequiredResetVinsoUser() {
            AppDelegate.vinsoAPI.resetUser()
        }
    }

    func onResetUserSuccessful() {
        Defaults.resetVinsoUserSuccessful()
    }
    
}

extension AppDelegate {

    func setupAdMob() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true

        guard let config = try? PListFile<ConfigInfoPList>() else {
            log.error("Can't open plist file")
            return
        }
        GADMobileAds.configure(withApplicationID: config.model.configuration.admobAdsId)
        log.debug("admobAdsId =", config.model.configuration.admobAdsId)
    }
    
}

// MARK: - Static instances

extension AppDelegate {
    static let exmoController = CHExmoAPI.shared
    static let vinsoAPI = VinsoAPI.shared
}

// MARK: - Static methods

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
        case 2436: return .ten
          default: return .none
        }
    }
    
}
