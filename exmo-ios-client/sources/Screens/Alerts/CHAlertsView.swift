//
//  CHAlertsView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHAlertsView: CHBaseTabView {
    @IBOutlet fileprivate      weak var maxAlertsLabel: UILabel!
    @IBOutlet fileprivate(set) weak var tableView     : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func setTutorialVisible(isUserAuthorizedToExmo: Bool, hasContent: Bool) {
        stubState = hasContent ? .none : .noContent(#imageLiteral(resourceName: "imgTutorialAlert"), nil)
    }
    
}

// MARK: - Setup

private extension CHAlertsView {
    
    func setupUI() {
        maxAlertsLabel.text = nil
        tableView.tableFooterView = UIView()
    }
    
}

// MARK: - Set

extension CHAlertsView {
    
    func set(maxAlerts text: String?) {
        maxAlertsLabel.text = text
    }
    
}
