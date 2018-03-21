//
//  MoreMoreViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UITableView

protocol MoreViewOutput {
    func viewIsReady()
    func onDidSelectMenuItem(segueIdentifier: String)
}
