//
//  CHAlertsView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHAlertsView: CHBaseTabView {
    @IBOutlet fileprivate      weak var summaryAlertsLabel: UILabel!
    @IBOutlet fileprivate(set) weak var tableView         : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func setTutorialVisible(isUserAuthorized: Bool, hasContent: Bool) {
        if isUserAuthorized {
            stubState = hasContent ? .none : .noContent(#imageLiteral(resourceName: "imgTutorialAlert"), nil)
        } else {
            stubState = .notAuthorized(nil, nil)
        }
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
