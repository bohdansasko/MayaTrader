//
// Created by Bogdan Sasko on 7/21/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIFont

extension UIFont {
    enum Exo2Color {
        case Regular
        case SemiBold
        case Bold
        case Medium
    }

    static func getExo2Font(fontType: UIFont.Exo2Color, fontSize: CGFloat) -> UIFont {
        switch fontType {
        case .Regular:
            return UIFont(name: "Exo2-Regular", size: fontSize)!
        case .SemiBold:
            return UIFont(name: "Exo2-SemiBold", size: fontSize)!
        case .Bold:
            return UIFont(name: "Exo2-Bold", size: fontSize)!
        case .Medium:
            return UIFont(name: "Exo2-Medium", size: fontSize)!
        }
    }
    
    static func getTitleFont() -> UIFont {
        return getExo2Font(fontType: .SemiBold, fontSize: 20)
    }
}
