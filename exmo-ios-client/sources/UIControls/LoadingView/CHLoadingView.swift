//
//  CHLoadingView.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/21/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

enum CHLoadingViewStyle {
    case `default`
    
    var backgroundColor: UIColor {
        switch self {
        case .default: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
}

final class CHLoadingView: UIView {
    
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    var style: CHLoadingViewStyle = .default
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = style.backgroundColor
    }
    
}

extension CHLoadingView {
    
    func show() {
        activityIndicator.startAnimating()
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
    
}
