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
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let components = type(of: self).description().components(separatedBy: ".")
        let nibName = components.last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
