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

// @MARK: TableOrderViewCellWithModel
class TableOrderViewCellWithModel: ExmoTableViewCell {
    var model: ModelOrderViewCell?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = nil 
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// @MARK: TableOrderViewCellTitle
class TableOrderViewCellTitle: TableOrderViewCellWithModel {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 14)
        return label
    }()
    
    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleLabel)
        titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        addSubview(separatorHLineView)
        separatorHLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// @MARK: CellButton
class CellButton: TableOrderViewCellWithModel {
    var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "icWidthButtonBlue"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 14)
        return btn
    }()
    
    var onTouchButton: VoidClosure?
    
    override var model: ModelOrderViewCell? {
        didSet {
            button.setTitle(model?.getHeaderText(), for: .normal)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(button)
        button.addTarget(self, action: #selector(onTouchButton(_:)), for: .touchUpInside)
        button.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func onTouchButton(_ sender: UIButton) {
        onTouchButton?()
    }
}

// @MARK: CellUISwitcher
class CellUISwitcher: TableOrderViewCellTitle {
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
    
    override var model: ModelOrderViewCell? {
        didSet {
            uiSwitch.isOn = false
            titleLabel.text = model?.getHeaderText()
        }
    }
    
    override var datasource: Any? {
        didSet {
            updateTextBasedOnSwitcher()
        }
    }
    
    typealias OnChangeState = (Any?) -> Void
    var onStateChanged: OnChangeState?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(leftLabel)
        leftLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        addSubview(uiSwitch)
        uiSwitch.anchorCenterYToSuperview()
        uiSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        uiSwitch.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func updateTextBasedOnSwitcher() {
        guard let orderType = datasource as? OrderActionType else {
            leftLabel.text = nil
            return
        }
        leftLabel.text = orderType.rawValue
    }
    
    @objc func onSwitchValueChanged(_ sender: Any) {
        datasource = uiSwitch.isOn ? OrderActionType.Buy : OrderActionType.Sell
        onStateChanged?(datasource)
        updateTextBasedOnSwitcher()
    }
}

// @MARK: CellInputField
class CellInputField: TableOrderViewCellTitle {
    var textInput: UITextField = {
        let textInpt = UITextField()
        textInpt.keyboardType = .decimalPad
        textInpt.textColor = .white
        textInpt.borderStyle = .none
        textInpt.textAlignment = .left
        textInpt.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        textInpt.attributedPlaceholder = NSAttributedString(string: "",
                                                             attributes: [NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .Regular, fontSize: 14)])
        return textInpt
    }()
    
    var rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        return label
    }()
    
    override var datasource: Any? {
        didSet {
            guard let value = datasource as? Double else { return }
            textInput.text = Utils.getFormatedPrice(value: value)
        }
    }
    
    var onTextChanged: VoidClosure?
    
    override var model: ModelOrderViewCell? {
        didSet {
            guard let d = model else {
                titleLabel.text = nil
                textInput.text = nil
                textInput.placeholder = nil
                return
            }
            titleLabel.text = d.getHeaderText()
            textInput.placeholder = d.getPlaceholderText()
            textInput.placeholderColor = UIColor.white.withAlphaComponent(0.3)
            textInput.text = nil
            textInput.isEnabled = d.isTextInputEnabled
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textInput)
        addSubview(rightLabel)
        
        textInput.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        textInput.delegate = self
        textInput.addTarget(self, action: #selector(onTextFieldEditingChanged(_:)), for: .editingChanged)
        
        rightLabel.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func onTextFieldEditingChanged(_ senderTextField: UITextField) {
        onTextChanged?()
        guard let text = senderTextField.text else { return }
        rightLabel.isHidden = text.isEmpty
        
    }
    
    func getDoubleValue() -> Double {
        guard let inTextValue = textInput.text,
              let value = Double(inTextValue) else { return 0.0 }
        return value
    }
}

// MARK: CellInputField+UITextFieldDelegate
extension CellInputField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = textField.text ?? ""
        let str = textFieldText + string
        
        if str.hasPrefix("00")  {
            return false
        }
        
        return str.isEmpty || str.isValidDoubleValue()
    }
}

// @MARK: CellMoreVariantsField
class CellMoreVariantsField: CellInputField {
    var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icInputFieldArrow")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var model: ModelOrderViewCell? {
        didSet {
            guard let d = model else {
                titleLabel.text = nil
                textInput.text = nil
                textInput.placeholder = nil
                rightLabel.text = nil
                return
            }
        
            titleLabel.text = d.getHeaderText()
            
            textInput.placeholder = d.getPlaceholderText()
            textInput.isEnabled = d.isTextInputEnabled
            textInput.text = Utils.getDisplayCurrencyPair(rawCurrencyPairName: d.getCurrencyName())
    
            rightLabel.text = d.getRightText()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(arrowImage)
        arrowImage.anchor(textInput.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 18, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
