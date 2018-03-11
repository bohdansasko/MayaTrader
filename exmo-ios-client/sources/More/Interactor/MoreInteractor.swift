//
//  MoreMoreInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit

class MoreInteractor: MoreInteractorInput {
    weak var output: MoreInteractorOutput!
    var displayManager: MoreDataDisplayManager!

    init() {
        displayManager = MoreDataDisplayManager()
        displayManager.interactor = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func viewIsReady(tableView: UITableView!) {
        displayManager.setTableView(tableView: tableView)

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
    }

    func onDidSelectMenuItem(segueIdentifier: String) {
        output.onDidSelectMenuItem(segueIdentifier: segueIdentifier)
    }

    func updateDisplayInfo() {
        displayManager.updateInfo()
    }
}
