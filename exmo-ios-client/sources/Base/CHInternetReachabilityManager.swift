//
//  CHInternetReachabilityManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/6/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Alamofire

final class CHInternetReachabilityManager: NSObject {    
    static let shared = CHInternetReachabilityManager()
    
    private let networkManager = NetworkReachabilityManager()
    
    private override init() {
        super.init()
    }
    
}

// MARK: - Handle listening

extension CHInternetReachabilityManager {
   
    func startListening() {
        networkManager?.listener = { [unowned self] status in
            self.handleStatus(with: status)
        }
        networkManager?.startListening()
    }
    
    func stopListening() {
        networkManager?.stopListening()
    }
    
}

// MARK: - Handle status

private extension CHInternetReachabilityManager {
    
    func handleStatus(with status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .notReachable:
            NotificationCenter.default.post(name: InternetReachabilityNotification.reachable.name)
        case .reachable(_), .unknown:
            NotificationCenter.default.post(name: InternetReachabilityNotification.notReachable.name)
        }
    }
    
}

// MARK: - UIApplicationDelegate

extension CHInternetReachabilityManager: UIApplicationDelegate {
    
    @discardableResult
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        startListening()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        stopListening()
    }
    
}
