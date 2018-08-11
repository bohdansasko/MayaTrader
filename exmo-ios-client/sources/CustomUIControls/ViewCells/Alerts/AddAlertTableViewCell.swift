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
    
    private var onTextFieldTextDidChanged: TextInVoidOutClosure? = nil
    var data: UIFieldModel? {
        didSet {
            guard let d = data else {
                return
            }
            self.headerLabel.text = d.getHeaderText()
            self.inputField.placeholder = d.getLeftText()
            self.inputField.placeholderColor = UIColor.white.withAlphaComponent(0.3)
            self.inputField.addTarget(self, action: #selector(self.onTextFieldEditingChanged), for: .editingChanged)
        }
    }
    
    func setData(data: String?) {
        self.inputField.text = data
    }
    
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
    
    private func getTextFromTextField(_ textField: UITextField) -> String {
        guard let text = textField.text else {
            return ""
        }
        return text
    }
    
    func setOnTextFieldTextDidChanged(onTextFieldTextDidChanged: TextInVoidOutClosure?) {
        self.onTextFieldTextDidChanged = onTextFieldTextDidChanged
    }

    @objc func onTextFieldEditingChanged(_ button: Any) {
        let text = self.getTextFromTextField(self.inputField)
        if !text.isEmpty {
            self.onTextFieldTextDidChanged?(text)
        }
    }
}
