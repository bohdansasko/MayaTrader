//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

enum VinsoResponseCode: Int {
    case succeed = 200
    case error = 0
}

enum ServerMessage: Int {
    case bad = -1
    case connect = 0
    case registration = 1
    case authorization = 2
    case confirmRegistration = 3
    case createAlert = 4
    case updateAlert = 5
    case deleteAlert = 6
    case fireAlert = 7
    case resetUser = 9
    case alertsHistory = 10
    case registerAPNsDeviceToken = 11
    case subscriptionConfigs = 12
    case setSubscriptionType = 13
}


enum APIURLs: String {
    case global = "ws://193.228.52.26:45667"
    case local = "ws://192.168.0.102:45667"
}
