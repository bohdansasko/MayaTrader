//
//  UserModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let uid: Int64
    let balances: [String:String]
    
//    func encodeBalancesToString() -> String {
//        let jsonEncode = JSONEncoder().encode(self)
//    }
    

    
}

struct UserModel {
    var qrModel: QRLoginModel?
    var userInfo: UserInfo?
}
