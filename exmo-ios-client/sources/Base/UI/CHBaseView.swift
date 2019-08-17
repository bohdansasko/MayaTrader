//
//  CHBaseView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class CHBaseView: UIView {
    
}

class CHBaseTabView: CHBaseView {
    
    // MARK: - Tutorial properties

    fileprivate var tutorialImg: TutorialImage?
    
    var tutorialImageName: String {
        fatalError("required")
    }
    
    /// update tutorial visibility
    var isTutorialStubVisible: Bool = false {
        didSet {
            setTutorialView(isVisible: isTutorialStubVisible)
        }
    }

}

// MARK: - Tutorial methods

private extension CHBaseTabView {
    
    func getTutorialImage() -> TutorialImage {
        let img = TutorialImage()
        img.imageName = self.tutorialImageName
        img.contentMode = .scaleAspectFit
        return img
    }
    
    func setTutorialView(isVisible: Bool) {
        if isVisible && (tutorialImg == nil || tutorialImg!.superview == nil) {
            tutorialImg = getTutorialImage()
            addSubview(tutorialImg!)
            tutorialImg!.snp.makeConstraints{
                $0.centerX.centerY.equalToSuperview()
            }
        }
        
        if isVisible {
            tutorialImg!.show()
        } else if tutorialImg != nil {
            tutorialImg?.removeFromSuperview()
            tutorialImg = nil
        }
    }
    
}
