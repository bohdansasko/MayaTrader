//
//  CHMenuSectionHeader.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/7/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHMenuSectionHeader: UIView {
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
}

extension CHMenuSectionHeader {
    
    func set(text: String?) {
        titleLabel.text = text
    }
    
}
