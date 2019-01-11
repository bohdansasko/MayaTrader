//
//  UITouchableNibView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

@IBDesignable
class UITouchableNibView: NibView {
    enum ButtonState {
        case Normal
        case Highlighted
    }
    
    @IBOutlet private weak var backgroundButton: UIButton!
    
    var callbackOnTouch: VoidClosure? = nil
    
    //
    // MARK: inherited methods
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundButtonCallbacks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupBackgroundButtonCallbacks()
    }
    
    //
    // MARK: private methods
    //
    func setupBackgroundButtonCallbacks() {
        backgroundButton.addTarget(self, action: #selector(self.onTouchDown), for: .touchDown)
        backgroundButton.addTarget(self, action: #selector(self.onTouchInside), for: .touchUpInside)
        backgroundButton.addTarget(self, action: #selector(self.onTouchOutSide), for: .touchUpOutside)
        backgroundButton.addTarget(self, action: #selector(self.onTouchCancel), for: .touchCancel)
    }
    
    private func handleButtonState(_ buttonState: ButtonState) {
        switch buttonState {
        case .Normal:
            backgroundButton.backgroundColor = UIColor.clear
        case .Highlighted:
            backgroundButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        }
    }
    
    //
    // MARK: selectors
    //
    @objc func onTouchDown(_ sender: Any) {
        print("onTouchDown")
        handleButtonState(.Highlighted)
    }
    
    @objc func onTouchInside(_ sender: Any) {
        print("onTouchInside")
        self.callbackOnTouch?()
        handleButtonState(.Normal)
    }
    
    @objc func onTouchOutSide(_ sender: Any) {
        print("onTouchOutSide")
        handleButtonState(.Normal)
    }
    
    @objc func onTouchCancel(_ sender: Any) {
        print("onTouchCancel")
        handleButtonState(.Normal)
    }
    
    //
    // MARK: callbacks
    //
    func setCallbackOnTouch(callback: VoidClosure?) {
        self.callbackOnTouch = callback
    }
}
