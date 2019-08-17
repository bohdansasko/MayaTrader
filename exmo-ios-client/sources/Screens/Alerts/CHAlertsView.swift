//
//  CHAlertsView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHAlertsView: UIView {
    @IBOutlet fileprivate      weak var summaryAlertsLabel: UILabel!
    @IBOutlet fileprivate(set) weak var tableView         : UITableView!
    
    fileprivate let tutorialImg: TutorialImage = {
        let img = TutorialImage()
        img.imageName = "imgTutorialAlert"
        img.contentMode = .scaleAspectFit
        return img
    }()
    
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
    
    func setVisibleTutorialView(isVisible: Bool) {
        if isVisible && tutorialImg.superview == nil {
            addSubview(tutorialImg)
            tutorialImg.snp.makeConstraints{
                $0.centerX.centerY.equalToSuperview()
            }
        }
        if isVisible {
            tutorialImg.show()
        } else {
            tutorialImg.hide()
        }
    }
    
}
