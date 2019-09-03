//
//  IAPProduct.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/5/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

enum IAPProduct: String {
    case noAds = "com.exmotrader.package.noadvertisement"
    case litePackage = "com.exmotrader.package.lite"
    case proPackage   = "com.exmotrader.package.pro"
}

extension IAPProduct: CaseIterable {
    // do nothing
}

