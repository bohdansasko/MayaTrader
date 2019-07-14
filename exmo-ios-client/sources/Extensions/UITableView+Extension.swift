//
//  UITableView+Extension.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Register nib for reuse
    func register<T: UITableViewCell>(nib cell: T.Type) {
        let nib = loadNib()
        let className = String(describing: self)
        register(nib, forCellReuseIdentifier: className)
    }
    
    /// Returns reusable cell
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let className = String(describing: self)
        return dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
    
}
