//
//  UIViewController+Extension.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// load view controller from nib
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            let className = String(describing: T.self)
            return T.init(nibName: className, bundle: nil)
        }
        
        return instantiateFromNib()
    }
    
    func performSegue(withIdentifier id: String) {
        performSegue(withIdentifier: id, sender: nil)
    }
    
}
