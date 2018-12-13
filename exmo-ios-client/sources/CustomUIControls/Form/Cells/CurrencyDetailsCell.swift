//
//  CurrencyDetails.swift
//  
//
//  Created by Bogdan Sasko on 12/1/18.
//

import UIKit

class CurrencyDetailsCell: ExmoTableViewCell, CurrencyDetailsFormConformity {
    var formItem: CurrencyDetailsItem?
    
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
        textInpt.isUserInteractionEnabled = false
        return textInpt
    }()
    
    var rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Regular, fontSize: 14)
        return label
    }()
    
    var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icInputFieldArrow")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = nil
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't have implementation")
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        addSubview(textInput)
        textInput.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 30, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        textInput.addTarget(self, action: #selector(onTextDidChange(_:)), for: .editingChanged)
        
        addSubview(rightLabel)
        rightLabel.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 0)
        
        addSubview(arrowImage)
        arrowImage.anchor(titleLabel.bottomAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 15, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func onTextDidChange(_ textField: UITextField) {
        formItem?.valueCompletion?(textField.text, rightLabel.text)
    }
}

extension CurrencyDetailsCell: FormUpdatable {
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
