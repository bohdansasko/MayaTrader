//
//  CHPushNotificationsService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import UserNotifications
import KeychainSwift

final class CHPushNotificationsService: NSObject {
    private override init() {
        super.init()
    }
    static let shared = CHPushNotificationsService()
    
}

// MARK: - Getters

extension CHPushNotificationsService {
    
    var deviceToken: String? {
        return KeychainSwift().get(KeychainDefaultKeys.apnsDeviceToken.rawValue)
    }
    
}

// MARK: - Handle registering APNs

private extension CHPushNotificationsService {
    
    func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { settings in
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
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func requestPushNotifications(center: UNUserNotificationCenter, _ result: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            print("APNs => granted = \(granted), error = \(error?.localizedDescription ?? "")")
            result(granted)
        })
    }
    
}

// MARK: - UIApplicationDelegate

extension CHPushNotificationsService: UIApplicationDelegate {
    
    @discardableResult
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerForRemoteNotifications()
        return true
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
