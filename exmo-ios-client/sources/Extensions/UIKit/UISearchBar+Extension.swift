//
//  UISearchBar+Extension.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/17/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UISearchBar

// MARK: - Getters

extension UISearchBar {
    
    var searchField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        } else {
            guard let searchTF = self.value(forKey: "searchField") as? UITextField else {
                return nil
            }
            return searchTF
        }
    }
    
}

// MARK: - Methods

extension UISearchBar {
    
    func removeGlassIcon() {
        guard let textFieldInsideSearchBar = searchField else { return }
        guard let  glassIconView = textFieldInsideSearchBar.leftView as? UIImageView else { return }
        glassIconView.image = nil
    }
    
    /// font for typing text
    func set(font: UIFont) {
        guard let textFieldInsideSearchBar = searchField else { return }
        textFieldInsideSearchBar.font = font
    }
    
    /// color for typing text
    func set(textColor: UIColor) {
        guard let textFieldInsideSearchBar = searchField else { return }
        textFieldInsideSearchBar.textColor = textColor
    }

}
