//
//  ExmoFloatingNumberCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class ExmoFloatingNumberCell: UITableViewCell, FloatingNumberFormConformity {
    var formItem: FloatingNumberFormItem?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 14)
        return label
    }()
    
    var textInput: UITextField = {
        let textInpt = UITextField()
        textInpt.textColor = .white
        textInpt.borderStyle = .none
        textInpt.textAlignment = .left
        textInpt.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        textInpt.attributedPlaceholder = NSAttributedString(string: "",
                                                            attributes: [NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .Regular, fontSize: 14)])
        return textInpt
    }()
    
    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't have implementation")
    }
    
    private func setupViews() {
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = .clear
        selectedBackgroundView = selectedBgView
        
        addSubview(titleLabel)
        titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        addSubview(textInput)
        textInput.delegate = self
        textInput.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        textInput.addTarget(self, action: #selector(onTextDidChange(_:)), for: .editingChanged)
        
        addSubview(separatorHLineView)
        separatorHLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)
    }
    
    @objc func onTextDidChange(_ textField: UITextField) {
        formItem?.valueCompletion?(textField.text)
    }
}

extension ExmoFloatingNumberCell: FormUpdatable {
    func update(item: FormItem?) {
        guard let fi = item as? FloatingNumberFormItem else { return }
        formItem = fi
        titleLabel.text = fi.title
        titleLabel.textColor = fi.uiProperties.titleColor
        textInput.placeholder = fi.placeholder
        textInput.keyboardType = fi.uiProperties.keyboardType
        textInput.placeholderColor = .white30
    }
}

extension ExmoFloatingNumberCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let fi = formItem else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= fi.uiProperties.textMaxLength
    }
}
