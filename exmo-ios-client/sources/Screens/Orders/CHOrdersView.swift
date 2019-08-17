//
//  CHOrdersView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHOrdersView: CHBaseTabView {
    
    override var tutorialImageName: String { return "imgTutorialOrder" }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}

// MARK: - Setup

extension CHOrdersView {
    
    func setupUI() {
        isTutorialStubVisible = true
    }
    
}
