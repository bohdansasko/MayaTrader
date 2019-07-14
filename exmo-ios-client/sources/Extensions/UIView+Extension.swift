//
//  Extension+UIView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/14/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

extension UIView {
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UINib {
        let className = String(describing: self)
        return UINib(nibName: className, bundle: nil)
    }
    
}
