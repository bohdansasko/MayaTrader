//
//  AlertViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyPairName: UILabel!
    @IBOutlet weak var currencyPairPrice: UILabel!
    @IBOutlet weak var topBound: UILabel!
    @IBOutlet weak var bottomBound: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var date: UILabel!
    
    // constraints
    @IBOutlet weak var timeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelHeightConstraint: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // selected - should be false for next reason:
        //  - after user selected row and returned to menu then row still selected,
        //    but in our case we need unselected row
        super.setSelected(false, animated: animated)
    }

    func setData(data: AlertItem) {
        self.currencyPairName.text = data.getCurrencyPairForDisplay()
        self.currencyPairPrice.text = String(data.priceAtCreateMoment)
        self.topBound.text = data.topBoundary != nil ? String(data.topBoundary!) : "-"
        self.bottomBound.text = data.topBoundary != nil ? String(data.bottomBoundary!) : "-"
        
        self.status.layer.cornerRadius = 5.0
        self.status.layer.masksToBounds = true
        self.setStatus(status: data.status)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        self.date.text = dateFormatter.string(from: data.dateCreated)
        
        // update constraints
        if AppDelegate.getIPhoneModel() == .Five {
            self.timeLabelWidthConstraint.constant = 70
            self.timeLabelHeightConstraint.constant = 40
        } else {
            self.timeLabelWidthConstraint.constant = 106
            self.timeLabelHeightConstraint.constant = 20
        }
    }

    func setStatus(status: AlertStatus) {
        updateStatusLabelColorAndValue(status: status)
    }
    
    private func updateStatusLabelColorAndValue(status: AlertStatus) {
        self.status.text = getTextStatusValue(status: status)
        self.status.backgroundColor = status == AlertStatus.Active ? UIColor.greenBlue : UIColor.steel
    }
    
    private func getTextStatusValue(status: AlertStatus) -> String {
        switch status {
        case .Active:
            return "Active"
        case .Inactive:
            return "Inactive"
        default:
            return ""
        }
    }
}