//
//  UISearchBar+Extension.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UISearchBar

extension UISearchBar {
    func removeGlassIcon() {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else { return }
        guard let  glassIconView = textFieldInsideSearchBar.leftView as? UIImageView else { return }
        glassIconView.image = nil
    }
    
    func setInputTextFont(_ font: UIFont, textColor: UIColor = .white) {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else { return }
        textFieldInsideSearchBar.font = font
        textFieldInsideSearchBar.textColor = textColor
    }
}
