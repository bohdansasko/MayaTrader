//
//  PlaceholderNoDataView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class PlaceholderNoDataView: NibView {
    enum DescriptionType {
        case None
        case Orders
        case Alerts
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setDescriptionType(descriptionType: DescriptionType) {
        self.descriptionLabel.text = self.getDescriptionText(descriptionType: descriptionType)
    }
    
    private func getDescriptionText(descriptionType: DescriptionType) -> String {
        switch descriptionType {
        case .Orders:
            return "You have no orders right now"
        case .Alerts:
            return "You have no alerts right now"
        default:
            return ""
        }
    }
}
