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
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContentData(itemData: MenuItem) {
        self.titleLabel?.text = itemData.title
        self.leftIcon.image = UIImage(named: itemData.iconNamed)
        updateRightSide(itemData: itemData)
    }
    
    func updateRightSide(itemData: MenuItem) {
        switch itemData.rightViewOptions {
        case MenuItem.RightViewOptions.Empty:
            self.rightLabel?.removeFromSuperview()
            self.rightIcon.removeFromSuperview()
            break
        case MenuItem.RightViewOptions.Icon:
            self.rightLabel?.removeFromSuperview()
            break
        case MenuItem.RightViewOptions.Text:
            if self.rightLabel != nil {
                self.rightLabel.text = itemData.rightText!
            }
            self.rightIcon.removeFromSuperview()
            break
        default:
            break
        }
    }
}
