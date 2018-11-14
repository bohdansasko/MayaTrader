//
//  OrdersRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class OrdersRouter: OrdersRouterInput {
    func showAddOrderVC(_ vc: UIViewController) {
        let moduleInit = CreateOrderModuleInitializer()
        vc
        vc.present(moduleInit.viewController, animated: true, completion: nil)
    }
}
