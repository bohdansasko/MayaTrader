//
//  InternetConnectionManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/6/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Alamofire

class InternetConnectionManager {
    enum StatusNotification: String, NotificationName {
        case reachable
        case notReachable
    }
    private let networkManager = NetworkReachabilityManager()
    
    static let shared = InternetConnectionManager()
    private init() {}
    
    func listen() {
        networkManager?.listener = { [weak self] status in
            self?.handleStatus(with: status)
        }
        networkManager?.startListening()
    }
    
    private func handleStatus(with status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        switch status {
        case .notReachable:
            NotificationCenter.default.post(name: StatusNotification.reachable.name)
        case .reachable(_), .unknown:
            NotificationCenter.default.post(name: StatusNotification.notReachable.name)
        }
    }
}
