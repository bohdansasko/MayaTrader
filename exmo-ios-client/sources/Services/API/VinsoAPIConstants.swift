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
    case Bad = -1
    case Connect = 0
    case Registration = 1
    case Authorization = 2
    case ConfirmRegistration = 3
    case CreateAlert = 4
    case UpdateAlert = 5
    case DeleteAlert = 6
    case FireAlert = 7
    case ResetUser = 9
    case AlertsHistory = 10
    case RegisterAPNsDeviceToken = 11
}


enum APIURLs: String {
    case global = "ws://193.228.52.26:45667"
    case local = "ws://192.168.0.102:45667"
}