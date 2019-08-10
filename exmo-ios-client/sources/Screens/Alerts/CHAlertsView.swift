//
//  CHAlertsView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHAlertsView: UIView {
    @IBOutlet fileprivate weak var summaryAlertsLabel: UILabel!
    @IBOutlet             weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
}

// MARK: - Setup

private extension CHAlertsView {
    
    func setupUI() {
        summaryAlertsLabel.text = nil
        tableView.tableFooterView = UIView()
    }
    
}

// MARK: - Set

extension CHAlertsView {
    
    func set(summary text: String) {
        summaryAlertsLabel.text = text
    }
    
}
