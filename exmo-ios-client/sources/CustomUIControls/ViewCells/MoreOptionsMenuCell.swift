//
//  MoreOptionsMenuCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class MoreOptionsMenuCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContentData(itemData: MenuItem) {
        self.titleLabel?.text = itemData.name
        self.leftIcon.image = UIImage(named: itemData.iconNamed)
    }
}
