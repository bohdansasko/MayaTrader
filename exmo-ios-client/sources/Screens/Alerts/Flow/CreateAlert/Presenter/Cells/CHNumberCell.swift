//
//  CHNumberCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHNumberCell: ExmoTableViewCell, FloatingNumberFormConformity {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var textInput : UITextField!
    
    var formItem: FloatingNumberFormItem? {
        didSet {
            formItem?.valueChanged = {
                [weak self] strValue in
                self?.textInput.text = strValue
                self?.textInput.sendActions(for: .editingChanged)
            }
            
            formItem?.refreshPlaceholder = {
                [weak self] in
                guard let fi = self?.formItem else { return }
                self?.textInput.placeholder = fi.placeholder1?.appending(fi.placeholder2 ?? "")
                self?.textInput.placeholderColor = .white30
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = nil
        textInput.attributedPlaceholder = NSAttributedString(string: "",
                                                             attributes: [NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .regular, fontSize: 14)])
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = nil
        setupViews()
    }
    
    override func setupViews() {
        super.setupViews()
        separatorLineView.isHidden = false
//        let selectedBgView = UIView()
//        selectedBgView.backgroundColor = .clear
//        selectedBackgroundView = selectedBgView
        
//        addSubview(titleLabel)
//        titleLabel.anchor(self.topAnchor, left: self.leftAnchor,
//                          bottom: nil, right: self.rightAnchor,
//                          topConstant: 0, leftConstant: 30,
//                          bottomConstant: 0, rightConstant: 20,
//                          widthConstant: 0, heightConstant: 0)
//
//        addSubview(textInput)
//        textInput.delegate = self
//        textInput.anchor(titleLabel.bottomAnchor, left: self.leftAnchor,
//                         bottom: nil, right: self.rightAnchor,
//                         topConstant: 15, leftConstant: 30,
//                         bottomConstant: 0, rightConstant: 20,
//                         widthConstant: 0, heightConstant: 0)
//        textInput.addTarget(self, action: #selector(onTextDidChange(_:)), for: .editingChanged)
        
//        addSubview(separatorHLineView)
//        separatorHLineView.anchor(nil, left: self.leftAnchor,
//                                  bottom: self.bottomAnchor, right: self.rightAnchor,
//                                  topConstant: 0, leftConstant: 30,
//                                  bottomConstant: 0, rightConstant: 30,
//                                  widthConstant: 0, heightConstant: 1)
    }
    
    @objc func onTextDidChange(_ textField: UITextField) {
        formItem?.valueCompletion?(textField.text)
    }
}


// MARK: - FormUpdatable

extension CHNumberCell: FormUpdatable {

    func update(item: FormItem?) {
        guard let fi = item as? FloatingNumberFormItem else { return }
        formItem = fi
        
        titleLabel.text = fi.title
        titleLabel.textColor = fi.uiProperties.titleColor
        
        textInput.text = fi.value
        textInput.placeholder = fi.placeholder1?.appending(fi.placeholder2 ?? "")
        textInput.placeholderColor = .white30
        textInput.isUserInteractionEnabled = fi.uiProperties.isUserInteractionEnabled
        textInput.keyboardType = fi.uiProperties.keyboardType
        
//        textInput.attributedPlaceholder = NSAttributedString(string: "",
//                                                             attributes: [NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .regular, fontSize: 14)])
        
        onTextDidChange(textInput)
    }
    
}

// MARK: - UITextFieldDelegate

extension CHNumberCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // check text length
        guard let text = textField.text,
              let fi = formItem else { return true }
        let newLength = text.count + string.count - range.length
        
        // check correct input
        let str = text + string
        if str.hasPrefix("00")  {
            return false
        }
        
        return str.isDoubleValid() && newLength <= fi.uiProperties.textMaxLength
    }
    
}
