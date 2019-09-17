//
//  CHCreateAlertPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 12/01/18.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSelectCurrencyCell: ExmoTableViewCell, CurrencyDetailsFormConformity {
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var textInput : UITextField!
    @IBOutlet fileprivate weak var rightLabel: UILabel!
    
    var formItem: CurrencyDetailsItem?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setupViews() {
        super.setupViews()

        backgroundColor = nil
        textInput.attributedPlaceholder = NSAttributedString(string: "",
                                                             attributes: [NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .regular, fontSize: 14)])
        separatorLineView.isHidden = false
    }
    
}

// MARK: - User interaction

private extension CHSelectCurrencyCell {
    
    @IBAction func onTextDidChange(_ textField: UITextField) {
        formItem?.onTextChanged?(textField.text, rightLabel.text)
    }
    
    @IBAction func actSelectCurrency(_ textField: UITextField) {
        formItem?.onSelect?()
    }
    
}


// MARK: - FormUpdatable

extension CHSelectCurrencyCell: FormUpdatable {
    
    func update(item: FormItem?) {
        guard let fi = item as? CurrencyDetailsItem else { return }
        formItem = fi
        titleLabel.text = fi.title
        titleLabel.textColor = fi.uiProperties.titleColor
        textInput.placeholder = fi.placeholder
        textInput.text = fi.leftValue
        textInput.keyboardType = fi.uiProperties.keyboardType
        textInput.placeholderColor = .white30
        rightLabel.text = fi.rightValue
        
        if textInput.text != nil {
            textInput.sendActions(for: .editingChanged)
        }
    }
    
}
