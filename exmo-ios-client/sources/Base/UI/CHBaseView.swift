//
//  CHBaseView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

enum CHTutorialStubState {
    case none
    case notAuthorized(UIImage?, String?)
    case noContent(UIImage?, String?)
}

class CHBaseView: UIView {
    // do nothing
}

class CHBaseTabView: CHBaseView {
    
    // MARK: - Private properties
    
    fileprivate var tutorialImg: CHStubView?
    
    // MARK: - Public properties
    
    var stubState: CHTutorialStubState = .none {
        didSet {
            switch stubState {
            case .none:
                removeTutorial()
            case .notAuthorized(let image, let text):
                setupTutorial(image: image, text: text)
            case .noContent(let image, let text):
                setupTutorial(image: image, text: text)
            }
        }
    }

    func setTutorialVisible(isUserAuthorized: Bool, hasContent: Bool) {
        // do nothing
    }
    
}

// MARK: - Tutorial methods

private extension CHBaseTabView {
    
    func setupTutorial(image: UIImage?, text: String?) {
        if tutorialImg == nil {
            tutorialImg = CHStubView.loadViewFromNib()
            addSubview(tutorialImg!)
            tutorialImg!.snp.makeConstraints { $0.centerX.centerY.equalToSuperview() }
        }
        tutorialImg!.set(image: image, text: text)

    }
    
    func removeTutorial() {
        tutorialImg?.removeFromSuperview()
        tutorialImg = nil
    }
    
}
