//
//  Extension+UIView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/14/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UINib {
        let classType = type(of: self)
        let className = String(describing: classType)
        return UINib(nibName: className, bundle: nil)
    }
    
}
