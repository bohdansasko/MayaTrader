//
//  MoreTableMenuViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UITableView

protocol TableMenuViewInput: class {
    func setupInitialState()
}

protocol TableMenuViewOutput {
    func viewIsReady()
    func didTouchCell(type: MenuCellType)
}
