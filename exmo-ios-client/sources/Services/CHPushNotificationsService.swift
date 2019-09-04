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
import RxSwift

final class CHPushNotificationsService: NSObject {
    private override init() {
        super.init()
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    static let shared = CHPushNotificationsService()
    
}

// MARK: - Getters

extension CHPushNotificationsService {
    
    var deviceToken: String? {
        return KeychainSwift().get(KeychainDefaultKeys.apnsDeviceToken.rawValue)
    }
    
    private func registerAPNSDeviceTokenOnServer(_ apnsDeviceToken: String?) {
        guard let apnsDeviceToken = apnsDeviceToken, !apnsDeviceToken.isEmpty else {
            assertionFailure("should be valide always")
            return
        }
        
        AppDelegate.vinsoAPI.rx.registerAPNSDeviceToken(apnsDeviceToken)
            .subscribe(onCompleted: {
                log.info("APNS Token \"\(apnsDeviceToken)\" has been registered succesfull")
            }, onError: { err in
                log.error(err.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    @objc private func handleNotificationUserAuthorization(_ n: Notification) {
        registerAPNSDeviceTokenOnServer(deviceToken)
    }
    
}

// MARK: - Handle registering APNs

private extension CHPushNotificationsService {
    
    func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .authorized:
                log.info("Authorized push notifications by user")
                self.registerPushNotifications()
            case .denied:
                log.info("show user view explaining why it's better to enable")
                self.registerPushNotifications()
            case .notDetermined:
                self.requestPushNotifications(center: center) { isGranted in
                    if isGranted {
                        self.registerPushNotifications()
                    }
                    log.info("User have\((isGranted ? "" : "n't")) granted app for get APNS")
                }
            case .provisional:
                log.info("App provisional post push notifications")
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
            log.info("APNs => is granted = \(granted)")
            
            if let err = error {
                log.error(err.localizedDescription)
            }
            
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
        
        log.debug("APNs device token =", token)
        
        KeychainSwift().set(token, forKey: KeychainDefaultKeys.apnsDeviceToken.rawValue)
        
        
        if VinsoAPI.shared.isAuthorized {
            registerAPNSDeviceTokenOnServer(token)
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleNotificationUserAuthorization(_:)),
                                                   name: ConnectionNotification.authorizationSuccess)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error(error.localizedDescription)
    }

}
