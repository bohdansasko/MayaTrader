//
//  OrdersInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol OrdersInteractorInput {
    func viewIsReady()
}

protocol OrdersInteractorOutput: class {
    func onDidLoadOrders(loadedOrders: [Orders.DisplayType : Orders])
}
