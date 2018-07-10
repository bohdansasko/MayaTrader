//
//  AlertTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AddAlertTableViewCell: AlertTableViewCellWithTextData {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    private var onTextFieldDidBeginEditing: VoidClosure? = nil
    private var onTextFieldDidEndEditing: VoidClosure? = nil
    
    func setContentData(data: CreateAlertItem) {
        self.headerLabel.text = data.getHeaderText()
        self.inputField.placeholder = data.getLeftText()
        self.inputField.placeholderColor = UIColor.white.withAlphaComponent(0.3)
        self.inputField.delegate = self
    }
    
    override func getDoubleValue() -> Double {
        return Double(self.inputField.text!)!
    }
    
    //
    // @callbacks
    //
    func setOnTextFieldDidBeginEditing(onTextFieldDidBeginEditing: VoidClosure?) {
        self.onTextFieldDidBeginEditing = onTextFieldDidBeginEditing
    }
    
    func setOnTextFieldDidEndEditing(onTextFieldDidEndEditing: VoidClosure?) {
        self.onTextFieldDidEndEditing = onTextFieldDidEndEditing
    }
}

extension AddAlertTableViewCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.onTextFieldDidBeginEditing?()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.onTextFieldDidEndEditing?()
    }
}
