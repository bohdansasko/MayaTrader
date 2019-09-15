//
//  CHTextInputCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHTextInputCell: ExmoTableViewCell, TextFormConformity {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var textInput : UITextField!

    var formItem: TextFormItem?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setupViews() {
        super.setupViews()
        separatorLineView.isHidden = false
    }
    
    
}

// MARK: - User interaction

private extension CHTextInputCell {
    
    @IBAction func onTextDidChange(_ textField: UITextField) {
        formItem?.onTextChanged?(textField.text)
    }
    
}

// MARK: - FormUpdatable

extension CHTextInputCell: FormUpdatable {
    
    func update(item: FormItem?) {
        guard let fi = item as? TextFormItem else { return }
        formItem = fi
        titleLabel.text = fi.title
        titleLabel.textColor = fi.uiProperties.titleColor
        textInput.text = fi.value
        textInput.placeholder = fi.placeholder
        textInput.keyboardType = fi.uiProperties.keyboardType
        textInput.placeholderColor = .white30
    }
    
}

// MARK: - UITextFieldDelegate

extension CHTextInputCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
            let fi = formItem else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= fi.uiProperties.textMaxLength
    }
    
}
