//
// Created by Bogdan Sasko on 7/21/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

extension UIFont {
    enum Exo2Color {
        case Regular
        case SemiBold
        case Bold
    }

    static func getExo2Font(fontType: UIFont.Exo2Color, fontSize: CGFloat) -> UIFont {
        switch fontType {
        case .Regular:
            return UIFont(name: "Exo2-Regular", size: fontSize)!
        case .SemiBold:
            return UIFont(name: "Exo2-SemiBold", size: fontSize)!
        case .Bold:
            return UIFont(name: "Exo2-Bold", size: fontSize)!
        }
    }
}