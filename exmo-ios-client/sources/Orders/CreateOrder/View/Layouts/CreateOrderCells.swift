//
//  CreateOrderViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

enum OrderBy {
    case Market
    case CurrencyExchange
}

// @MARK: CellButton
class CellButton: UITableViewCell {
    var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "icWidthButtonBlue"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 14)
        return btn
    }()
    
    var model: UIFieldModel? {
        didSet {
            button.setTitle(model?.getHeaderText(), for: .normal)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = nil
        addSubview(button)
        
        button.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// @MARK: CellUISwitcher
class CellUISwitcher: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 14)
        return label
    }()
    
    var leftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        return label
    }()
    
    let uiSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .dodgerBlue
        return sw
    }()
    
    var textForStateOnOff: [String?] = [] {
        didSet {
            updateTextBasedOnSwitcher()
        }
    }
    
    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()
    
    var model: UIFieldModel? {
        didSet {
            titleLabel.text = model?.getHeaderText()
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = nil
        
        addSubview(titleLabel)
        addSubview(leftLabel)
        addSubview(uiSwitch)
        addSubview(separatorHLineView)
        
        titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        leftLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        uiSwitch.anchorCenterYToSuperview()
        uiSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        uiSwitch.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
        separatorHLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateTextBasedOnSwitcher() {
        if textForStateOnOff.count == 2 {
            leftLabel.text = uiSwitch.isOn ? textForStateOnOff[0] : textForStateOnOff[1]
        } else {
            leftLabel.text = nil
        }
    }
    
    @objc func onSwitchValueChanged(_ sender: Any) {
        updateTextBasedOnSwitcher()
    }
}

// @MARK: CellInputField
class CellInputField: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 14)
        return label
    }()
    
    var textInput: UITextField = {
        let textInpt = UITextField()
        textInpt.keyboardType = .decimalPad
        textInpt.textColor = .white
        textInpt.borderStyle = .none
        textInpt.textAlignment = .left
        textInpt.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        textInpt.attributedPlaceholder = NSAttributedString(string: "",
                                                             attributes: [NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .Regular, fontSize: 14)])
        textInpt.addTarget(self, action: #selector(onTextFieldEditingChanged(_:)), for: .editingChanged)
        return textInpt
    }()
    
    var rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        return label
    }()
    
    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()
    
    var model: UIFieldModel? {
        didSet {
            guard let d = model else {
                return
            }
            titleLabel.text = d.getHeaderText()
            textInput.placeholder = d.getPlaceholderText()
            textInput.placeholderColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = nil
        addSubview(titleLabel)
        addSubview(textInput)
        addSubview(rightLabel)
        addSubview(separatorHLineView)
        
        titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        textInput.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        textInput.delegate = self

        rightLabel.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        separatorHLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func onTextFieldEditingChanged(_ senderTextField: UITextField) {
        guard let text = senderTextField.text else { return }
        rightLabel.isHidden = text.isEmpty
    }
}

extension CellInputField: UITextFieldDelegate {
    
}

class CellMoreVariantsField: CellInputField {
    var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icInputFieldArrow")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var model: UIFieldModel? {
        didSet {
            guard let d = model else {
                return
            }
            titleLabel.text = d.getHeaderText()
            textInput.text = d.getPlaceholderText()
            textInput.isEnabled = false
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        selectedBackgroundView = selectedView
        
        addSubview(arrowImage)
        arrowImage.anchor(textInput.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 18, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
