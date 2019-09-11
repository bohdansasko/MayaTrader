//
//  CHCreateAlertPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHCreateAlertPresenter: NSObject {
    fileprivate let tableView: UITableView
    fileprivate let layout: CHCreateAlertLayout
    
    init(tableView: UITableView, layout: CHCreateAlertLayout) {
        self.tableView = tableView
        self.layout = layout
        
        super.init()
        
        self.tableView.dataSource = layout
        self.tableView.delegate = self
    }
    
}

extension CHCreateAlertPresenter: UITableViewDelegate {
    
    
}
