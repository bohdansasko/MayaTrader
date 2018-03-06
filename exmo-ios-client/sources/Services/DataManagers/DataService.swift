//
//  DataService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class DataService {
    static var appSettings = UserDefaults.standard
    static var cache = UserCoreDataEngine.sharedInstance
}
