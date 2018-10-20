//
//  WatchlistCurrenciesListWatchlistCurrenciesListRouterInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit

protocol WatchlistCurrenciesListRouterInput {
    func closeVC(vc: UIViewController)
    func openCurrenciesListWithCurrenciesRelativeTo(vc: UIViewController, listGroupModel: WatchlistCurrenciesListGroup)
}
