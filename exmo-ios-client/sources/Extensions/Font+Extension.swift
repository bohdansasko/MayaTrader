//
// Created by Bogdan Sasko on 7/21/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit.UIFont

extension UIFont {
    enum Exo2Color {
        case regular
        case semibold
        case bold
        case medium
        
        func name() -> String {
            switch self {
            case .regular: return "Exo2-Regular"
            case .semibold: return "Exo2-SemiBold"
            case .bold: return "Exo2-Bold"
            case .medium: return "Exo2-Medium"
            }
        }
    }

    static func getExo2Font(fontType: UIFont.Exo2Color, fontSize: CGFloat) -> UIFont {
        switch fontType {
        case .regular:
            return UIFont(name: fontType.name(), size: fontSize)!
        case .semibold:
            return UIFont(name: fontType.name(), size: fontSize)!
        case .bold:
            return UIFont(name: fontType.name(), size: fontSize)!
        case .medium:
            return UIFont(name: fontType.name(), size: fontSize)!
        }
    }
    
    static func getTitleFont() -> UIFont {
        return getExo2Font(fontType: .semibold, fontSize: 20)
    }
}
