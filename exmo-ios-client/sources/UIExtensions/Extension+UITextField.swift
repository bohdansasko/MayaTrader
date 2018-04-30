
//
//  Extension+UITextField.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UITextField

extension UITextField {
    
    @IBInspectable var placeholderColor : UIColor {
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue])
        }
        get {
            return self.placeholderColor
        }
    }
}

