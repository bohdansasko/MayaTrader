//
//  UITouchableViewWithIndicator.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/14/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

@IBDesignable
class UITouchableViewWithIndicator: NibView {
    private enum ButtonState {
        case Normal
        case Highlighted
    }
    
    //
    // @MARK: outlets
    //
    @IBOutlet weak var backgroundButton: UIButton!
    
    var callbackOnTouch: VoidClosure? = nil
    
    //
    // @MARK: inherited methods
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    //
    // MARK: private methods
    //
    fileprivate func setupUI() {
        backgroundButton.addTarget(self, action: #selector(self.onTouchDown), for: .touchDown)
        backgroundButton.addTarget(self, action: #selector(self.onTouchInside), for: .touchUpInside)
        backgroundButton.addTarget(self, action: #selector(self.onTouchOutSide), for: .touchUpOutside)
        backgroundButton.addTarget(self, action: #selector(self.onTouchCancel), for: .touchCancel)
    }
    
    private func handleButtonState(_ buttonState: ButtonState) {
        switch buttonState {
        case .Normal:
            backgroundButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        case .Highlighted:
            backgroundButton.backgroundColor = UIColor.clear
        default:
            // do nothing
            break
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
