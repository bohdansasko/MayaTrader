//
//  MenuItemTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
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
    
    func setTitleLabel(text: String) {
        titleLabel?.text = text
    }

}
