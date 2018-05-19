//
//  UITouchableViewWithIndicator.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/14/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

@IBDesignable
class UITouchableViewWithIndicator: UITouchableNibView {    
    //
    // @MARK: outlets
    //
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    //
    // @MARK: getters and setters
    //
    @IBInspectable var headerText: String {
        get { return self.headerLabel.text! }
    
        set {
            self.headerLabel.text = newValue
        }
    }
    
    @IBInspectable var contentText: String {
        get { return self.contentLabel.text! }
        
        set {
            self.contentLabel.text = newValue
        }
    }
}
