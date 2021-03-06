//
//  WatchlistRouterInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol WatchlistRouterInput {
    func showCurrenciesListVC(senderVC: UIViewController)
    func showChartVC(senderVC: UIViewController, currencyPairName: String)
}
