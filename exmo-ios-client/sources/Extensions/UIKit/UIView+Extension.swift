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
    static func loadNib() -> UINib {
        let classType = type(of: self)
        let className = String(describing: classType)
        return UINib(nibName: className, bundle: nil)
    }
    
    /** Loads instance of view from nib with the same name. */
    static func loadViewFromNib() -> Self {
        return self.viewFromNib()!
    }
    
    static func viewFromNib<T>() -> T? {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first
        return view as? T
    }
    
}
