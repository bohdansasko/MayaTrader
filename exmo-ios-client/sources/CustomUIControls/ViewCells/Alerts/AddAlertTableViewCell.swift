//
//  AlertTableViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/19/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

extension String {
    func isValidDoubleValue() -> Bool {
        let formatter = NumberFormatter()

        if formatter.number(from: self) != nil {
            return true
        }
        
        return false
    }
}

class AddAlertTableViewCell: AlertTableViewCellWithTextData {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    private var onTextFieldTextDidChanged: TextInVoidOutClosure? = nil
    var data: ModelOrderViewCell? {
        didSet {
            guard let d = data else {
                return
            }
            self.headerLabel.text = d.getHeaderText()
            self.inputField.placeholder = d.getPlaceholderText()
            self.inputField.placeholderColor = UIColor.white.withAlphaComponent(0.3)
            self.inputField.delegate = self
            self.inputField.addTarget(self, action: #selector(self.onTextFieldEditingChanged), for: .editingChanged)
        }
    }
    
    //
    // MARK: getters
    //
    override func getDoubleValue() -> Double {
        guard let text = self.inputField.text else {
            return 0.0
        }
        
        return text.isEmpty ? 0.0 : Double(text)!
    }
    
    override func getTextData() -> String {
        guard let text = self.inputField.text else {
            return ""
        }
        return text
    }
    
    fileprivate func getTextFromTextField(_ textField: UITextField) -> String {
        guard let text = textField.text else {
            return ""
        }
        return text
    }
}

extension AddAlertTableViewCell {
    func setTextInInputField(string: String?) {
        self.inputField.text = string
        self.currencyLabel.isHidden = string != nil ? string!.isEmpty : true
    }

    func setPlaceholderText(string: String) {
        self.inputField.placeholder = "0 " + string
        self.inputField.placeholderColor = UIColor.white.withAlphaComponent(0.3)
        self.currencyLabel.text = string
    }

    func setOnTextFieldTextDidChanged(onTextFieldTextDidChanged: TextInVoidOutClosure?) {
        self.onTextFieldTextDidChanged = onTextFieldTextDidChanged
    }
    
    @objc func onTextFieldEditingChanged(_ button: Any) {
        let text = self.getTextFromTextField(self.inputField)
        self.currencyLabel.isHidden = self.getTextData().isEmpty
        self.onTextFieldTextDidChanged?(text)
    }
}

//
// MARK: text field delegate
//
extension AddAlertTableViewCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = textField.text ?? ""
        let str = textFieldText + string
    
        if str.hasPrefix("00")  {
            return false
        }

        return str.isEmpty || str.isValidDoubleValue()
    }
}
