//
//  IAPProduct.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/5/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

enum IAPProduct: String {
    case advertisements = "com.exmobile.vinso.advertisements"
    case litePackage = "com.exmobile.vinso.package.lite"
    case proPackage   = "com.exmobile.vinso.pro"
}

extension IAPProduct: CaseIterable {
    // do nothing
}

